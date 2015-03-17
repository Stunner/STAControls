//
//  STATextField.h
//  STATextField
//
//  Created by Aaron Jubbal on 10/17/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STAResizingTextField.h"

/**
 Provides following capabilities:
 
 - replacing placeholder text whenever the text field is set back to the empty string ("")
 - dismissing the keyboard when the *return* key is pressed
 - switching to another text field when the *return* key is pressed
 - display an accessory view atop keyboard that allows for fast switching between adjacent UIControls
 */
@interface STATextField : STAResizingTextField

/**
 Denotes whether firstResponder status should be resigned upon return key press.
 */
//@property (nonatomic, assign) BOOL resignsFirstResponderUponReturnKeyPress;
/**
 The next UIControl object that is to claim firstResponder status upon return key press.
 */
//@property (nonatomic, strong) UIControl *nextFirstResponderUponReturnKeyPress;

@property (nonatomic, strong) UIControl *prevControl;
@property (nonatomic, assign) BOOL showBackForwardToolbar;

@property (nonatomic, readonly) NSString *textValue;

@property (nonatomic, assign) NSUInteger maxCharacterLength;

@end
