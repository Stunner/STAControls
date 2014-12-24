//
//  STATextViewBase+PrivateHeaders.h
//  STATextField
//
//  Created by Aaron Jubbal on 11/23/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "STATextViewBase.h"

@interface STATextViewBase (PrivateHeaders)

/**
 Called during initialization, between the call to super's init and returning of self.
 
 Use this method to specify any initial configuration.
 */
- (void)initInternal;

// Notifications

- (void)keyboardWillShow:(NSNotification *)notification;

- (void)keyboardWillHide:(NSNotification *)notification;

- (void)textViewBeganEditing:(NSNotification *)notification;

- (void)textViewStoppedEditing:(NSNotification *)notification;

- (void)textChanged:(NSNotification *)notification;

// Responding to Editing Notifications

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;

- (void)textViewDidBeginEditing:(UITextView *)textView;

- (BOOL)textViewShouldEndEditing:(UITextView *)textView;

- (void)textViewDidEndEditing:(UITextView *)textView;

// Responding to Text Changes

- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text;

- (void)textViewDidChange:(UITextView *)textView;

// Responding to Selection Changes

- (void)textViewDidChangeSelection:(UITextView *)textView;

// Interacting with Text Data

- (BOOL)textView:(UITextView *)textView
shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment
         inRange:(NSRange)characterRange;

- (BOOL)textView:(UITextView *)textView
shouldInteractWithURL:(NSURL *)URL
         inRange:(NSRange)characterRange;

@end
