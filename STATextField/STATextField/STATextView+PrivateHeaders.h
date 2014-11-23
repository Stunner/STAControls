//
//  STATextView+PrivateHeaders.h
//  STATextField
//
//  Created by Aaron Jubbal on 11/22/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "STATextView.h"

@interface STATextView (PrivateHeaders)

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;

- (BOOL)textViewShouldEndEditing:(UITextView *)textView;

@end
