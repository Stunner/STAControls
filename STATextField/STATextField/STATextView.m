//
//  STATextView.m
//  STATextField
//
//  Created by Aaron Jubbal on 11/21/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "STATextView.h"
#import "STATextView+PrivateHeaders.h"

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
    return YES;
}

@end

#pragma mark - STATextField

@interface STATextView () {
    STATextViewPrivateDelegate *_internalDelegate;
    NSString *_internalPlaceholder;
    NSAttributedString *_internalAttributedPlaceholder;
}

@end


@implementation STATextView

- (void)initInternal {
    _internalDelegate = [[STATextViewPrivateDelegate alloc] init];
    [super setDelegate:_internalDelegate];
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

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return YES;
}

@end
