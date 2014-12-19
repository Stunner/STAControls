//
//  STATextViewBase.m
//  STATextField
//
//  Created by Aaron Jubbal on 11/23/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "STATextViewBase.h"
#import "STATextViewBase+PrivateHeaders.h"

#pragma mark - STATextField

#pragma mark - STATextFieldPrivateDelegate

@interface STATextViewPrivateDelegate : NSObject <UITextViewDelegate> {
@public
    __weak id<UITextViewDelegate> _userDelegate;
}
@end

@implementation STATextViewPrivateDelegate

- (BOOL)respondsToSelector:(SEL)selector {
    return [_userDelegate respondsToSelector:selector] || [super respondsToSelector:selector];
}

#pragma mark Delegate Overrides

// Responding to Editing Notifications

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    BOOL shouldChangeText = [(STATextViewBase *)textView textViewShouldBeginEditing:textView];
    if ([_userDelegate respondsToSelector:_cmd]) {
        if (!shouldChangeText) {
            [_userDelegate textViewShouldBeginEditing:textView];
        } else {
            shouldChangeText = [_userDelegate textViewShouldBeginEditing:textView];
        }
    }
    return shouldChangeText;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [(STATextViewBase *)textView textViewDidBeginEditing:textView];
    if ([_userDelegate respondsToSelector:_cmd]) {
        [_userDelegate textViewDidBeginEditing:textView];
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    BOOL shouldChangeText = [(STATextViewBase *)textView textViewShouldEndEditing:textView];
    if ([_userDelegate respondsToSelector:_cmd]) {
        if (!shouldChangeText) {
            [_userDelegate textViewShouldEndEditing:textView];
        } else {
            shouldChangeText = [_userDelegate textViewShouldEndEditing:textView];
        }
    }
    return shouldChangeText;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [(STATextViewBase *)textView textViewDidEndEditing:textView];
    if ([_userDelegate respondsToSelector:_cmd]) {
        [_userDelegate textViewDidEndEditing:textView];
    }
}

// Responding to Text Changes

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    BOOL shouldChangeText = [(STATextViewBase *)textView textView:textView
                                                shouldChangeTextInRange:range
                                                        replacementText:text];
    if ([_userDelegate respondsToSelector:_cmd]) {
        if (!shouldChangeText) {
            [_userDelegate textView:textView
            shouldChangeTextInRange:range
                    replacementText:text];
        } else {
            shouldChangeText = [_userDelegate textView:textView
                                     shouldChangeTextInRange:range
                                             replacementText:text];
        }
    }
    return shouldChangeText;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [(STATextViewBase *)textView textViewDidChange:textView];
    if ([_userDelegate respondsToSelector:_cmd]) {
        [_userDelegate textViewDidChange:textView];
    }
}

// Responding to Selection Changes

- (void)textViewDidChangeSelection:(UITextView *)textView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [(STATextViewBase *)textView textViewDidChangeSelection:textView];
    if ([_userDelegate respondsToSelector:_cmd]) {
        [_userDelegate textViewDidChangeSelection:textView];
    }
}

// Interacting with Text Data

- (BOOL)textView:(UITextView *)textView
shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment
         inRange:(NSRange)characterRange
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    BOOL shouldInteractWithText = [(STATextViewBase *)textView textView:textView
                                       shouldInteractWithTextAttachment:textAttachment
                                                                inRange:characterRange];
    if ([_userDelegate respondsToSelector:_cmd]) {
        if (!shouldInteractWithText) {
            [_userDelegate textView:textView
   shouldInteractWithTextAttachment:textAttachment
                            inRange:characterRange];
        } else {
            shouldInteractWithText = [_userDelegate textView:textView
                            shouldInteractWithTextAttachment:textAttachment
                                                     inRange:characterRange];
        }
    }
    return shouldInteractWithText;
}

- (BOOL)textView:(UITextView *)textView
shouldInteractWithURL:(NSURL *)URL
         inRange:(NSRange)characterRange
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    BOOL shouldInteractWithURL = [(STATextViewBase *)textView textView:textView
                                                 shouldInteractWithURL:URL
                                                               inRange:characterRange];
    if ([_userDelegate respondsToSelector:_cmd]) {
        if (!shouldInteractWithURL) {
            [_userDelegate textView:textView
              shouldInteractWithURL:URL
                            inRange:characterRange];
        } else {
            shouldInteractWithURL = [_userDelegate textView:textView
                                      shouldInteractWithURL:URL
                                                    inRange:characterRange];
        }
    }
    return shouldInteractWithURL;
}

//- (void)textViewBeganEditing:(NSNotification *)notification {
//    
//}
//
//- (void)textViewStoppedEditing:(NSNotification *)notification {
//    
//}

@end

@interface STATextViewBase () <UITextViewDelegate>{
    STATextViewPrivateDelegate *_internalDelegate;
}

@property (nonatomic, weak) id<UITextViewDelegate> realDelegate;

@end


@implementation STATextViewBase

//reference: https://github.com/steipete/PSPDFTextView
#pragma mark - Delegate Forwarder

- (BOOL)respondsToSelector:(SEL)s {
    return [super respondsToSelector:s] || [self.realDelegate respondsToSelector:s];
}

- (id)forwardingTargetForSelector:(SEL)s {
    id delegate = self.realDelegate;
    return [delegate respondsToSelector:s] ? delegate : [super forwardingTargetForSelector:s];
}

#pragma mark - Initialization

- (void)initInternal {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (!_internalDelegate) {
        _internalDelegate = [[STATextViewPrivateDelegate alloc] init];
    }
    [super setDelegate:_internalDelegate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textChanged:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textViewBeganEditing:)
                                                 name:UITextViewTextDidBeginEditingNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textViewStoppedEditing:)
                                                 name:UITextViewTextDidEndEditingNotification
                                               object:nil];
}

- (instancetype)init {
    if (!(self = [super init])) {
        return nil;
    }
    [self initInternal];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    [self initInternal];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (!(self = [super initWithCoder:aDecoder])) {
        return nil;
    }
    [self initInternal];
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setDelegate:(id<UITextViewDelegate>)delegate {
    // UIScrollView delegate keeps some flags that mark whether the delegate implements some methods (like scrollViewDidScroll:)
    // setting *the same* delegate doesn't recheck the flags, so it's better to simply nil the previous delegate out
    // we have to setup the realDelegate at first, since the flag check happens in setter
    [super setDelegate:nil];
    _internalDelegate->_userDelegate = delegate != _internalDelegate ? delegate : nil;
    [super setDelegate:delegate ? _internalDelegate : nil];
}

- (void)textChanged:(NSNotification *)notification {
    
}

- (void)textViewBeganEditing:(NSNotification *)notification {
    
}

- (void)textViewStoppedEditing:(NSNotification *)notification {
    
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
}

// Responding to Editing Notifications

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
}

// Responding to Text Changes

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
}

// Responding to Selection Changes

- (void)textViewDidChangeSelection:(UITextView *)textView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    
}

// Interacting with Text Data

- (BOOL)textView:(UITextView *)textView
shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment
         inRange:(NSRange)characterRange
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView
shouldInteractWithURL:(NSURL *)URL
         inRange:(NSRange)characterRange
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return YES;
}

@end
