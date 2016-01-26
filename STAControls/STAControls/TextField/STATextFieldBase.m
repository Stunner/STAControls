//
//  STATextFieldBase.m
//  STATextField
//
//  Created by Aaron Jubbal on 11/23/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "STATextFieldBase.h"
#import "STATextFieldBase+PrivateHeaders.h"

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
    [(STATextFieldBase *)textField commitTextChanges];
    return shouldChangeCharacters;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    BOOL returnable = [(STATextFieldBase *)textField textFieldShouldClear:textField];
    if ([_userDelegate respondsToSelector:_cmd]) {
        returnable = [_userDelegate textFieldShouldClear:textField];
    }
    return returnable;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL returnable = [(STATextFieldBase *)textField textFieldShouldReturn:textField];
    if ([_userDelegate respondsToSelector:_cmd]) {
        returnable = [_userDelegate textFieldShouldReturn:textField];
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

- (instancetype)init {
    if ((self = [super init])) {
        [self initInternal];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self initInternal];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self initInternal];
    }
    return self;
}

/////////////
// PRIVATE //
/////////////

- (void)initInternal {
    
    _internalDelegate = [[STATextFieldPrivateDelegate alloc] init];
    [super setDelegate:_internalDelegate];
    [self addTarget:self
             action:@selector(textFieldDidChange:)
   forControlEvents:UIControlEventEditingChanged];
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

- (void)textFieldDidChange:(STATextFieldBase *)sender {
    
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    return YES;
}

- (void)commitTextChanges {
    
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (BOOL)clearTextField {
    BOOL shouldClear = [_internalDelegate textFieldShouldClear:self];
    if (shouldClear) {
        self.text = @"";
        [self sendActionsForControlEvents:UIControlEventEditingChanged];
    }
    return shouldClear;
}

@end
