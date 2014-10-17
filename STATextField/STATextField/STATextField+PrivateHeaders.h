//
//  STATextField+PrivateHeaders.h
//  STATextField
//
//  Created by Aaron Jubbal on 10/17/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "STATextField.h"

@interface STATextField (PrivateHeaders)

- (BOOL)staTextField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
   replacementString:(NSString *)string;

@end
