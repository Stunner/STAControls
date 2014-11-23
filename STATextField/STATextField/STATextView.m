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
    
    [super initInternal];
    
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
