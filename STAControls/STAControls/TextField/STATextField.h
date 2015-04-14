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
@property (nonatomic, assign) BOOL currencyRepresentation;
/**
 Defaults text field to contain value specified by this property. Upon going empty, the text field populates with this value.
 */
@property (nonatomic, strong) NSString *defaultValue;
/**
 @returns Text displayed in text field, including that of the placeholder text. Will return empty string (@"") instead of nil.
 */
@property (nonatomic, readonly) NSString *textValue;
/**
 Maximum amount of characters that can be displayed by the text field.
 */
@property (nonatomic, assign) NSUInteger maxCharacterLength;
/**
 @returns Value denoting if edits between `textFieldDidBeginEditing:` and `textFieldDidEndEditing:` caused change in text.
 */
@property (nonatomic, assign, readonly) BOOL textChanged;

@end
