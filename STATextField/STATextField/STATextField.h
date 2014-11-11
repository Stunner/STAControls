//
//  STATextField.h
//  STATextField
//
//  Created by Aaron Jubbal on 10/17/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STATextField : UITextField

@property (nonatomic, assign) BOOL resignsFirstResponderUponReturnKeyPress;
@property (nonatomic, strong) UIControl *nextFirstResponderUponReturnKeyPress;
@property (nonatomic, assign) BOOL showDoneButton;

@end
