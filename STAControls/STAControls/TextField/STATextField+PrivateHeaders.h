//
//  STATextField+PrivateHeaders.h
//  STATextField
//
//  Created by Aaron Jubbal on 10/17/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "STATextField.h"

@interface STATextField (PrivateHeaders)

- (void)initInternal;

- (BOOL)resignFirstResponderUponReturnKeyPress;

- (void)textFieldDidChange:(STATextFieldBase *)sender;

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
   replacementString:(NSString *)string;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;

- (void)textFieldDidBeginEditing:(UITextField *)textField;

- (void)textFieldDidEndEditing:(UITextField *)textField;

@end
