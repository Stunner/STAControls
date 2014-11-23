//
//  STATextViewBase+PrivateHeaders.h
//  STATextField
//
//  Created by Aaron Jubbal on 11/23/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "STATextViewBase.h"

@interface STATextViewBase (PrivateHeaders)

- (void)initInternal;

- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text;

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;

- (BOOL)textViewShouldEndEditing:(UITextView *)textView;

@end
