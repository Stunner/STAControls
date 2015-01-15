//
//  STAPickerField.h
//  STATextField
//
//  Created by Aaron Jubbal on 1/12/15.
//  Copyright (c) 2015 Aaron Jubbal. All rights reserved.
//

#import "STATextField.h"
#import "STAPickerView.h"

@interface STAPickerField : STATextField

@property (nonatomic, strong) STAPickerView *pickerView;
@property (nonatomic, strong) NSArray *pickerViewData;

@end
