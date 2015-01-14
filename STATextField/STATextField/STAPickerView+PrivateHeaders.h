//
//  STAPickerView+PrivateHeaders.h
//  STATextField
//
//  Created by Aaron Jubbal on 1/13/15.
//  Copyright (c) 2015 Aaron Jubbal. All rights reserved.
//

#import "STAPickerView.h"

@interface STAPickerView (PrivateHeaders)

/**
 Called after initialization occurs (any init... method called).
 
 MUST call this (super's implementation) method from subclasses.
 */
- (void)initInternal;

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component;

@end
