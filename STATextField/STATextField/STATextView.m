//
//  STATextView.m
//  STATextField
//
//  Created by Aaron Jubbal on 11/21/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "STATextView.h"
#import "STATextViewBase+PrivateHeaders.h"

@interface STATextView () {
    NSString *_internalPlaceholder;
    NSAttributedString *_internalAttributedPlaceholder;
    CGFloat _initialYPosition;
    NSTimeInterval _keyboardAnimationDuration;
    UIViewAnimationCurve _keyboardAnimationCurve;
    CGFloat _topOfKeyboardYPosition;
    CGFloat _keyboardYPosition;
}

@property (nonatomic, assign) BOOL nextShowKeyboardNotificationForSelf;
@property (nonatomic, assign) BOOL nextHideKeyboardNotificationForSelf;
@property (assign) BOOL isAnimating;

@end


@implementation STATextView

- (void)animateSelfToPosition:(CGFloat)position {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"animating to %f", position);
        if (!self.isAnimating) {
            [UIView animateWithDuration:0.25 delay:0 options:animationOptionsWithCurve(_keyboardAnimationCurve) animations:^{
                self.isAnimating = YES;
                CGRect newTextViewFrame = self.frame;
                newTextViewFrame.origin.y = position;
                self.frame = newTextViewFrame;
            } completion:^(BOOL finished) {
                if (finished) {
                    self.isAnimating = NO;
                    CGRect newTextViewFrame = self.frame;
                    newTextViewFrame.origin.y = position;
                    self.frame = newTextViewFrame;
                }
            }];
        }
    });
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"animating to %f", position);
//
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:_keyboardAnimationDuration];
//        [UIView setAnimationCurve:_keyboardAnimationCurve];
//
//        CGRect newTextViewFrame = self.frame;
//        newTextViewFrame.origin.y = position;
//        self.frame = newTextViewFrame;
//
//        [UIView commitAnimations];
//    });
}

- (void)parseUserInfoForNotification:(NSNotification *)notification {
    NSNumber *duration = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    if (duration && [duration isKindOfClass:[NSNumber class]])
        _keyboardAnimationDuration = [duration floatValue];
    NSNumber *animationCurve = [[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    if (animationCurve && [animationCurve isKindOfClass:[NSNumber class]])
        _keyboardAnimationCurve = [animationCurve integerValue];
//    NSValue *v = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
}

- (void)textChanged:(NSNotification *)notification {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSDictionary *attributes = @{NSFontAttributeName : self.font};
    CGSize boundingBox = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, 170)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:attributes context:nil].size;
    CGSize size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height + 11));
    [UIView animateWithDuration:0.1 animations:^{
        CGRect newTextViewFrame = self.frame;
        newTextViewFrame.origin.y = _keyboardYPosition - size.height;
        newTextViewFrame.size.height = size.height;
        self.frame = newTextViewFrame;
    } completion:^(BOOL finished) {
        if (finished) {
            CGRect newTextViewFrame = self.frame;
            newTextViewFrame.origin.y = _keyboardYPosition - size.height;
            newTextViewFrame.size.height = size.height;
            self.frame = newTextViewFrame;
        }
    }];
}

- (void)textViewBeganEditing:(NSNotification *)notification {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    
}

- (void)textViewStoppedEditing:(NSNotification *)notification {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [self parseUserInfoForNotification:notification];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&_keyboardAnimationCurve];
        [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&_keyboardAnimationDuration];
        
//        NSLog(@"notification user info: %@", notification);
        if (!_topOfKeyboardYPosition) {
            CGRect keyboardEndFrame;
            [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
            _keyboardYPosition = keyboardEndFrame.origin.y;
            _topOfKeyboardYPosition = keyboardEndFrame.origin.y - self.frame.size.height;
        }
        
        if (!self.nextShowKeyboardNotificationForSelf) {
            return;
        }
        self.nextShowKeyboardNotificationForSelf = NO;
        
        if (!_topOfKeyboardYPosition) {
            CGRect keyboardEndFrame;
            [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
            _topOfKeyboardYPosition = keyboardEndFrame.origin.y - self.frame.size.height;
        }
        
        CGRect endFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        if (self.animatesToTopOfKeyboard) {
            [self animateSelfToPosition:self.frame.origin.y - endFrame.size.height];
        }
    });
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [self parseUserInfoForNotification:notification];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&_keyboardAnimationCurve];
        [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&_keyboardAnimationDuration];
        
        if (!self.nextHideKeyboardNotificationForSelf) {
            return;
        }
        self.nextHideKeyboardNotificationForSelf = NO;
        
        CGRect beginFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        if (self.animatesToTopOfKeyboard) {
            [self animateSelfToPosition:self.frame.origin.y + beginFrame.size.height];
        }
    });
}

- (BOOL)becomeFirstResponder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [super becomeFirstResponder];
    
//    if (self.animatesToTopOfKeyboard && _topOfKeyboardYPosition) {
//        [self animateSelfToPosition:_topOfKeyboardYPosition];
//    }
    
    return YES;
}

- (BOOL)resignFirstResponder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [super resignFirstResponder];
    
//    if (self.animatesToTopOfKeyboard) {
//        [self animateSelfToPosition:_initialYPosition];
//    }
    
    return YES;
}

- (void)initInternal {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [super initInternal];
    
    _initialYPosition = self.frame.origin.y;
    self.animatesToTopOfKeyboard = NO;
    self.nextHideKeyboardNotificationForSelf = NO;
    self.nextShowKeyboardNotificationForSelf = NO;
    self.isAnimating = NO;
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return YES;
}

static inline UIViewAnimationOptions animationOptionsWithCurve(UIViewAnimationCurve curve) {
    UIViewAnimationOptions opt = (UIViewAnimationOptions)curve;
    return opt << 16;
}

@end