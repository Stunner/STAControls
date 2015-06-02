//
//  STAATMTextField.h
//  STATextField
//
//  Created by Aaron Jubbal on 10/20/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "STATextField.h"

/**
 Provides a text field that mimics ATM machine input behavior.
 
 By default the `keyboardType` is set to `UIKeyboardTypeDecimalPad` as this text field does 
 exhibit special behavior when a decimal is entered. If you wish to disable decimal entry behavior,
 set the `keyboardType` to `UIKeyboardTypeNumberPad`.
 */
@interface STAATMTextField : STATextField

/**
 Allows for enabling/disabling of ATM text entry behavior.
 
 Comes in use if you provide settings for the user to (en/dis)able this behavior within your app.
 */
@property (nonatomic, assign) BOOL atmEntryEnabled;

@end
