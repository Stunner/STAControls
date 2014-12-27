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

@property (nonatomic, assign) BOOL expandsUpward;
@property (nonatomic, assign) BOOL animatesToTopOfKeyboard;

@end
