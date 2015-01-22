//
//  STAPickerView.h
//  STATextField
//
//  Created by Aaron Jubbal on 1/14/15.
//  Copyright (c) 2015 Aaron Jubbal. All rights reserved.
//

#import "STAPickerViewBase.h"

@interface STAPickerView : STAPickerViewBase

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, copy) void (^pickerViewSelectionBlock)(UIPickerView *pickerView, NSInteger component, NSInteger row, NSString *title);

@end
