//
//  STADateField.m
//  STATextField
//
//  Created by Aaron Jubbal on 11/16/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "STADateField.h"
#import "STATextField+PrivateHeaders.h"

@interface STADateField ()

@end

@implementation STADateField

- (void)initInternal {
    [super initInternal];
    
    _datePicker = [[UIDatePicker alloc] init];
    
    _dateFormatString = @"M/d/yy h:mm a";
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:_dateFormatString];
    
    [_datePicker addTarget:self
                    action:@selector(datePickerValueChanged:)
          forControlEvents:UIControlEventValueChanged];
    [self setInputView:_datePicker];
}

- (void)setDate:(NSDate *)date {
    self.datePicker.date = date;
    NSString *dateText = [_dateFormatter stringFromDate:date];
    [self setText:dateText];
}

- (void)setDateFormatString:(NSString *)dateFormatString {
    if (_dateFormatString != dateFormatString) {
        _dateFormatString = dateFormatString;
        [_dateFormatter setDateFormat:_dateFormatString];
    }
}

- (void)datePickerValueChanged:(UIDatePicker *)sender {
    [self setDate:sender.date];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [super textFieldDidEndEditing:textField];
    
    
}

@end
