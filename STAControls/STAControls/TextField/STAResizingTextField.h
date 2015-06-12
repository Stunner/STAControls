//
//  STAResizingTextField.h
//  STATextField
//
//  Created by Aaron Jubbal on 10/18/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "STATextFieldBase.h"
#import "STAButton.h"

@interface STAResizingTextField : STATextFieldBase

/**
 Denotes whether firstResponder status should be resigned upon return key press.
 */
@property (nonatomic, assign) BOOL resignsFirstResponderUponReturnKeyPress;

// this needs to be here as opposed to STATextField so that proper resizing occurs upon
// return key press 
/**
 The next UIControl object that is to claim firstResponder status upon return key press.
 */
@property (nonatomic, strong) UIControl *nextControl;

/**
 Defaults to NO.
 */
@property (nonatomic, assign) BOOL resizesForClearTextButton;

@property (nonatomic, readonly) BOOL clearButtonIsVisible;
/**
 Only returns a valid object after `setClearButtonImage:forState:` is called.
 */
@property (nonatomic, strong, readonly) STAButton *customClearButton;

- (void)setClearButtonImage:(UIImage *)image forState:(UIControlState)state;

@end


@protocol STAResizingTextFieldDelegate <UITextFieldDelegate>

- (BOOL)shouldResizeTextField:(STAResizingTextField *)textField
                    fromWidth:(CGFloat)initialWidth
                      toWidth:(CGFloat)newWidth;

@end
