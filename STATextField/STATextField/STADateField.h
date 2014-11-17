//
//  STADateField.h
//  STATextField
//
//  Created by Aaron Jubbal on 11/16/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "STATextField.h"

@interface STADateField : STATextField

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) UIDatePicker *datePicker;
/**
 Defaults to "M/d/yy h:mm a" ("8/14/13 7:52 AM").
 */
@property (nonatomic, strong) NSString *dateFormatString;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end
