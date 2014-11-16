//
//  STADateField.m
//  STATextField
//
//  Created by Aaron Jubbal on 11/16/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "STADateField.h"
#import "STATextField+PrivateHeaders.h"

@implementation STADateField

- (void)initInternal {
    [super initInternal];
    
    _datePicker = [[UIDatePicker alloc] init];
    _dateFormatString = @"M/d/yy h:mm a";
    [_datePicker addTarget:self
                    action:@selector(datePickerValueChanged:)
          forControlEvents:UIControlEventValueChanged];
    [self setInputView:_datePicker];
}

- (void)datePickerValueChanged:(UIDatePicker *)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:_dateFormatString];
    NSString *dateText = [dateFormatter stringFromDate:sender.date];
    [self setText:dateText];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [super textFieldDidEndEditing:textField];
    
    
}

@end
