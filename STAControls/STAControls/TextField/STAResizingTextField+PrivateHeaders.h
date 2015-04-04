//
//  STAResizingTextField+PrivateHeaders.h
//  STATextField
//
//  Created by Aaron Jubbal on 1/17/15.
//  Copyright (c) 2015 Aaron Jubbal. All rights reserved.
//

#import "STAResizingTextField.h"

@interface STAResizingTextField (PrivateHeaders)

- (void)initInternal;

- (BOOL)resignFirstResponderUponReturnKeyPress;

- (void)textFieldDidChange:(STATextFieldBase *)sender;

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string;

- (BOOL)textFieldShouldClear:(UITextField *)textField;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@end
