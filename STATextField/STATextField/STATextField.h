//
//  STATextField.h
//  STATextField
//
//  Created by Aaron Jubbal on 10/17/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STATextFieldBase.h"

@interface STATextField : STATextFieldBase

@property (nonatomic, assign) BOOL resignsFirstResponderUponReturnKeyPress;
@property (nonatomic, strong) UIControl *nextFirstResponderUponReturnKeyPress;
@property (nonatomic, assign) BOOL showDoneButton;
@property (nonatomic, assign) BOOL showNextButton;

@end
