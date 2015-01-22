//
//  STAResizingTextField.h
//  STATextField
//
//  Created by Aaron Jubbal on 10/18/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "STATextFieldBase.h"

@interface STAResizingTextField : STATextFieldBase

/**
 Denotes whether firstResponder status should be resigned upon return key press.
 */
@property (nonatomic, assign) BOOL resignsFirstResponderUponReturnKeyPress;

/**
 The next UIControl object that is to claim firstResponder status upon return key press.
 */
@property (nonatomic, strong) UIControl *nextFirstResponderUponReturnKeyPress;

/**
 Defaults to NO.
 */
@property (nonatomic, assign) BOOL resizesForClearTextButton;

@property (nonatomic, readonly) BOOL clearButtonIsVisible;

@end
