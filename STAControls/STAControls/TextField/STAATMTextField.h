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
 */
@interface STAATMTextField : STATextField

/**
 Allows for enabling/disabling of ATM text entry behavior.
 
 Comes in use if you provide settings for the user to (en/dis)able this behavior within your app.
 */
@property (nonatomic, assign) BOOL atmEntryEnabled;

@end
