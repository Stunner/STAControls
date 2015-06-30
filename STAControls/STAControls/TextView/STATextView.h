//
//  STATextView.h
//  STATextField
//
//  Created by Aaron Jubbal on 11/21/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STATextViewBase.h"

@interface STATextView : STATextViewBase

@property (nonatomic, strong) UIControl *prevControl;
@property (nonatomic, strong) UIControl *nextControl;
/**
 Attach toolbar to top of keyboard which contains buttons to switch to adjacent responders and dismiss the keyboard.
 */
@property (nonatomic, assign) BOOL showBackForwardToolbar;

@property (nonatomic, assign) BOOL expandsUpward;
@property (nonatomic, assign) BOOL animatesToTopOfKeyboard;
@property (nonatomic, assign) BOOL autoDeterminesHeight;

@end
