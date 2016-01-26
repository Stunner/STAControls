//
//  STATextFieldBase+PrivateHeaders.h
//  STATextField
//
//  Created by Aaron Jubbal on 11/23/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "STATextFieldBase.h"

@interface STATextFieldBase (PrivateHeaders)

/**
 Called after initialization occurs (any init... method called).
 
 MUST call this (super's implementation) method from subclasses.
 */
- (void)initInternal;

- (BOOL)clearTextField;

- (void)textFieldDidChange:(STATextFieldBase *)sender;

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string;

/**
 Where any text updates should occur for subclasses.
 
 Update text within this method instead of in `textField:shouldChangeCharactersInRange:replacementString:`.
 */
- (void)commitTextChanges;

- (BOOL)textFieldShouldClear:(UITextField *)textField;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;

- (void)textFieldDidBeginEditing:(UITextField *)textField;

- (void)textFieldDidEndEditing:(UITextField *)textField;

@end
