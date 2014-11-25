//
//  STATextViewBase.m
//  STATextField
//
//  Created by Aaron Jubbal on 11/23/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "STATextViewBase.h"
#import "STATextViewBase+PrivateHeaders.h"

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
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    BOOL returnable = [(STATextViewBase *)textView textViewShouldBeginEditing:textView];
    if ([_userDelegate respondsToSelector:_cmd]) {
        returnable =  [_userDelegate textViewShouldBeginEditing:textView];
    }
    return returnable;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    BOOL returnable = [(STATextViewBase *)textView textViewShouldEndEditing:textView];
    if ([_userDelegate respondsToSelector:_cmd]) {
        returnable =  [_userDelegate textViewShouldEndEditing:textView];
    }
    return returnable;
}

@end

#pragma mark - STATextField

@interface STATextViewBase () {
    STATextViewPrivateDelegate *_internalDelegate;
}

@end


@implementation STATextViewBase

- (void)initInternal {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    _internalDelegate = [[STATextViewPrivateDelegate alloc] init];
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

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return YES;
}


@end
