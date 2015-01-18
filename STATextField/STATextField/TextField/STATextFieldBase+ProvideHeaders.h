//
//  STATextFieldBase+ProvideHeaders.h
//  STATextField
//
//  Created by Aaron Jubbal on 11/23/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "STATextFieldBase.h"

@interface STATextFieldBase (ProvideHeaders)

/**
 Called after initialization occurs (any init... method called).
 
 MUST call this (super's implementation) method from subclasses.
 */
- (void)initInternal;

- (void)textFieldDidChange:(STATextFieldBase *)sender;

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string;

- (BOOL)textFieldShouldClear:(UITextField *)textField;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;

- (void)textFieldDidBeginEditing:(UITextField *)textField;

- (void)textFieldDidEndEditing:(UITextField *)textField;

@end
