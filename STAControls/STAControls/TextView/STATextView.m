//
//  STATextView.m
//  STATextField
//
//  Created by Aaron Jubbal on 11/21/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "STATextView.h"
#import "STATextViewBase+PrivateHeaders.h"
#import "STACommon.h"

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
@property (nonatomic, assign) BOOL layoutSubviewsHasBeenCalled;
@property (assign) BOOL isAnimating;

@end


@implementation STATextView

- (CGSize)sizeForText:(NSString *)text {
    //TODO: override text inset in order to update appropriately
    //TODO: compensate for default text being more than one line long
    // TODO: look at typing attributes
    NSDictionary *attributes = @{NSFontAttributeName : self.font}; //scan through nsttributed text and acount for characters with nsattributed font
    UIEdgeInsets textContainerInset = self.textContainerInset;
    UIEdgeInsets contentInset = self.contentInset;
    UIEdgeInsets totalInsets = UIEdgeInsetsMake(textContainerInset.top + contentInset.top,
                                                textContainerInset.left + contentInset.left,
                                                textContainerInset.bottom + contentInset.bottom,
                                                textContainerInset.right + contentInset.right);
    CGSize boundingBox = [text boundingRectWithSize:CGSizeMake(self.bounds.size.width - (totalInsets.left + totalInsets.right), 170)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:attributes context:nil].size;
    CGSize size = CGSizeMake(ceil(boundingBox.width + (totalInsets.left + totalInsets.right)), ceil(boundingBox.height + totalInsets.top + totalInsets.bottom));
    return size;
}

#pragma mark - Subclassed Methods

- (void)layoutSubviews {
    STALog(@"%s", __PRETTY_FUNCTION__);
    
    [super layoutSubviews];
    
    if (self.autoDeterminesHeight && !self.layoutSubviewsHasBeenCalled) {
        CGSize size = [self sizeForText:@"A"]; // placeholder text
        CGRect newFrame = self.frame;
        newFrame.size.height = size.height;
        self.frame = newFrame;
    }
    self.layoutSubviewsHasBeenCalled = YES;
}

- (void)textChanged:(NSNotification *)notification {
    STALog(@"%s", __PRETTY_FUNCTION__);
    
    
}

- (void)textViewBeganEditing:(NSNotification *)notification {
    STALog(@"%s", __PRETTY_FUNCTION__);
    
    
}

- (void)textViewStoppedEditing:(NSNotification *)notification {
    STALog(@"%s", __PRETTY_FUNCTION__);
    
    
}

- (void)keyboardWillShow:(NSNotification *)notification {
    STALog(@"%s", __PRETTY_FUNCTION__);
    
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    STALog(@"%s", __PRETTY_FUNCTION__);
    
    
}

- (BOOL)becomeFirstResponder {
    STALog(@"%s", __PRETTY_FUNCTION__);
    
    [super becomeFirstResponder];
    
    return YES;
}

- (BOOL)resignFirstResponder {
    STALog(@"%s", __PRETTY_FUNCTION__);
    
    [super resignFirstResponder];
    
    return YES;
}

- (void)initInternal {
    STALog(@"%s", __PRETTY_FUNCTION__);
    
    [super initInternal];
    
    _initialYPosition = self.frame.origin.y;
    self.expandsUpward = NO;
    self.animatesToTopOfKeyboard = NO;
    self.nextHideKeyboardNotificationForSelf = NO;
    self.nextShowKeyboardNotificationForSelf = NO;
    self.isAnimating = NO;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    STALog(@"%s", __PRETTY_FUNCTION__);
    
    self.nextShowKeyboardNotificationForSelf = YES;
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    STALog(@"%s", __PRETTY_FUNCTION__);
    
    self.nextHideKeyboardNotificationForSelf = YES;
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    STALog(@"%s", __PRETTY_FUNCTION__);
    
    NSString *newText = [self.text stringByReplacingCharactersInRange:range withString:text];
    CGSize size = [self sizeForText:newText];
    
    __weak STATextView *weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        CGRect newTextViewFrame = weakSelf.frame;
        if (self.expandsUpward) {
            CGFloat heightDelta = newTextViewFrame.size.height - size.height;
            newTextViewFrame.origin.y += heightDelta;
        }
        newTextViewFrame.size.height = size.height;
        weakSelf.frame = newTextViewFrame;
    } completion:^(BOOL finished) {
        if (finished) {
            CGRect newTextViewFrame = weakSelf.frame;
            if (self.expandsUpward) {
                CGFloat heightDelta = newTextViewFrame.size.height - size.height;
                newTextViewFrame.origin.y += heightDelta;
            }
            newTextViewFrame.size.height = size.height;
            weakSelf.frame = newTextViewFrame;
        }
    }];
    
    return YES;
}

@end
