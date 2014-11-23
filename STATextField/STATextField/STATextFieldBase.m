//
//  STATextFieldBase.m
//  STATextField
//
//  Created by Aaron Jubbal on 11/23/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "STATextFieldBase.h"
#import "STATextFieldBase+ProvideHeaders.h"

// reference: http://stackoverflow.com/a/9986842/347339
#pragma mark - STATextFieldPrivateDelegate

@interface STATextFieldPrivateDelegate : NSObject <UITextFieldDelegate> {
@public
    __weak id<UITextFieldDelegate> _userDelegate;
}
@end

@implementation STATextFieldPrivateDelegate

- (BOOL)respondsToSelector:(SEL)selector {
    return [_userDelegate respondsToSelector:selector] || [super respondsToSelector:selector];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    // This should only ever be called from `UITextField`, after it has verified
    // that `_userDelegate` responds to the selector by sending me
    // `respondsToSelector:`.  So I don't need to check again here.
    [invocation invokeWithTarget:_userDelegate];
}

#pragma mark Delegate Overrides

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    BOOL shouldChangeCharacters = [(STATextFieldBase *)textField textField:textField
                                            shouldChangeCharactersInRange:range
                                                        replacementString:string];
    if ([_userDelegate respondsToSelector:_cmd]) {
        if (!shouldChangeCharacters) {
            [_userDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
        } else {
            shouldChangeCharacters = [_userDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
        }
    }
    return shouldChangeCharacters;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL returnable = YES;
    if ([_userDelegate respondsToSelector:_cmd]) {
        returnable = [_userDelegate textFieldShouldReturn:textField];
    }
    if (returnable) {
        returnable = [(STATextFieldBase *)textField textFieldShouldReturn:textField];
    }
    return returnable;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [(STATextFieldBase *)textField textFieldDidBeginEditing:textField];
    if ([_userDelegate respondsToSelector:_cmd]) {
        [_userDelegate textFieldDidBeginEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [(STATextFieldBase *)textField textFieldDidEndEditing:textField];
    if ([_userDelegate respondsToSelector:_cmd]) {
        [_userDelegate textFieldDidEndEditing:textField];
    }
}

@end

#pragma mark - STATextField

@interface STATextFieldBase () {
    STATextFieldPrivateDelegate *_internalDelegate;
}

@end


@implementation STATextFieldBase

- (void)initInternal {
    
    _internalDelegate = [[STATextFieldPrivateDelegate alloc] init];
    [super setDelegate:_internalDelegate];
    [self addTarget:self
             action:@selector(textFieldDidChange:)
   forControlEvents:UIControlEventEditingChanged];
}

- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    [self initInternal];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    [self initInternal];
    return self;
}

#pragma mark Setters/Getters

- (void)setDelegate:(id<UITextFieldDelegate>)delegate {
    _internalDelegate->_userDelegate = delegate;
    // Scroll view delegate caches whether the delegate responds to some of the delegate
    // methods, so we need to force it to re-evaluate if the delegate responds to them
    super.delegate = nil;
    super.delegate = (id)_internalDelegate;
}

- (id<UITextFieldDelegate>)delegate {
    return _internalDelegate->_userDelegate;
}

#pragma mark Text Field Events

- (void)textFieldDidChange:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

@end
