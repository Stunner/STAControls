//
//  STATextView.m
//  STATextField
//
//  Created by Aaron Jubbal on 11/21/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "STATextView.h"
#import "STATextView+PrivateHeaders.h"

#pragma mark - STATextViewPrivateDelegate

@interface STATextViewPrivateDelegate : NSObject <UITextViewDelegate> {
@public
    __weak id<UITextViewDelegate> _userDelegate;
}
@end

@implementation STATextViewPrivateDelegate

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

- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    BOOL returnable = [(STATextView *)textView textViewShouldBeginEditing:textView];
    if ([_userDelegate respondsToSelector:_cmd]) {
        returnable =  [_userDelegate textViewShouldBeginEditing:textView];
    }
    return returnable;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    BOOL returnable = [(STATextView *)textView textViewShouldEndEditing:textView];
    if ([_userDelegate respondsToSelector:_cmd]) {
        returnable =  [_userDelegate textViewShouldEndEditing:textView];
    }
    return returnable;
}

@end

#pragma mark - STATextField

@interface STATextView () {
    STATextViewPrivateDelegate *_internalDelegate;
    NSString *_internalPlaceholder;
    NSAttributedString *_internalAttributedPlaceholder;
    CGFloat _initialYPosition;
}

@property (nonatomic, assign) BOOL nextShowKeyboardNotificationForSelf;
@property (nonatomic, assign) BOOL nextHideKeyboardNotificationForSelf;

@end


@implementation STATextView

- (void)animateSelfToPosition:(CGFloat)position notification:(NSNotification *)notification {
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newTextViewFrame = self.frame;
    newTextViewFrame.origin.y = position;
    self.frame = newTextViewFrame;
    
    [UIView commitAnimations];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (!self.nextShowKeyboardNotificationForSelf) {
        return;
    }
    self.nextShowKeyboardNotificationForSelf = NO;
    
    if (self.animatesToTopOfKeyboard) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CGRect keyboardEndFrame;
            [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
            CGFloat newPosition = keyboardEndFrame.origin.y - self.frame.size.height;
            [self animateSelfToPosition:newPosition notification:notification];
        });
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (!self.nextHideKeyboardNotificationForSelf) {
        return;
    }
    self.nextHideKeyboardNotificationForSelf = NO;
    
    if (self.animatesToTopOfKeyboard) {
        [self animateSelfToPosition:_initialYPosition notification:notification];
    }
}

- (BOOL)resignFirstResponder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [super resignFirstResponder];
    
    
    
    return YES;
}

- (void)initInternal {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    _internalDelegate = [[STATextViewPrivateDelegate alloc] init];
    [super setDelegate:_internalDelegate];
    
    _initialYPosition = self.frame.origin.y;
    self.animatesToTopOfKeyboard = NO;
    self.nextHideKeyboardNotificationForSelf = NO;
    self.nextShowKeyboardNotificationForSelf = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    [self initInternal];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    [self initInternal];
    return self;
}

- (void)setDelegate:(id<UITextViewDelegate>)delegate {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    _internalDelegate->_userDelegate = delegate;
    // Scroll view delegate caches whether the delegate responds to some of the delegate
    // methods, so we need to force it to re-evaluate if the delegate responds to them
    super.delegate = nil;
    super.delegate = (id)_internalDelegate;
}

- (id<UITextViewDelegate>)delegate {
    if (!_internalDelegate) {
        return nil;
    }
    return _internalDelegate->_userDelegate;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    self.nextShowKeyboardNotificationForSelf = YES;
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    self.nextHideKeyboardNotificationForSelf = YES;
    
    return YES;
}

@end
