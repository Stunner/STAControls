//
//  STATextField.m
//  STATextField
//
//  Created by Aaron Jubbal on 10/17/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "STATextField.h"
#import "STATextField+PrivateHeaders.h"

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
    BOOL returnable = [(STATextField *)textField staTextField:textField
                                shouldChangeCharactersInRange:range
                                            replacementString:string];
    if ([_userDelegate respondsToSelector:_cmd]) {
        returnable = [_userDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return returnable;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL returnable = [(STATextField *)textField textFieldShouldReturn:textField];
    if ([_userDelegate respondsToSelector:_cmd]) {
        returnable = [_userDelegate textFieldShouldReturn:textField];
    }
    return returnable;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [(STATextField *)textField textFieldDidBeginEditing:textField];
    if ([_userDelegate respondsToSelector:_cmd]) {
        [_userDelegate textFieldDidBeginEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [(STATextField *)textField textFieldDidEndEditing:textField];
    if ([_userDelegate respondsToSelector:_cmd]) {
        [_userDelegate textFieldDidEndEditing:textField];
    }
}

@end

#pragma mark - STATextField

@interface STATextField () {
    STATextFieldPrivateDelegate *_internalDelegate;
    NSString *_internalPlaceholder;
    NSAttributedString *_internalAttributedPlaceholder;
}

@end

@implementation STATextField

- (void)initInternal {
    _internalDelegate = [[STATextFieldPrivateDelegate alloc] init];
    [super setDelegate:_internalDelegate];
    [self addTarget:self
             action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidChange:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
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
    _internalPlaceholder = self.placeholder;
    _internalAttributedPlaceholder = self.attributedPlaceholder;
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _internalPlaceholder = placeholder;
    [super setPlaceholder:placeholder];
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    _internalAttributedPlaceholder = attributedPlaceholder;
    [super setAttributedPlaceholder:attributedPlaceholder];
}

#pragma mark Delegate Related

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

- (BOOL)staTextField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
   replacementString:(NSString *)string
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // hide placeholder when editing begins
    [super setPlaceholder:nil];
    [super setAttributedPlaceholder:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([textField.text length] < 1) {
        if (_internalAttributedPlaceholder) { //TODO: consider looking at which field was set most recently to determine which placeholder gets priority
            textField.attributedPlaceholder = _internalAttributedPlaceholder;
        } else if (_internalPlaceholder) {
            textField.placeholder = _internalPlaceholder;
        }
    }
}

@end
