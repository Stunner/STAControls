//
//  STAPickerField.m
//  STATextField
//
//  Created by Aaron Jubbal on 1/12/15.
//  Copyright (c) 2015 Aaron Jubbal. All rights reserved.
//

#import "STAPickerField.h"
#import "STATextField+PrivateHeaders.h"

@interface STAPickerField () <UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation STAPickerField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initInternal {
    [super initInternal];
    
    self.pickerView = [STAPickerView new];
    
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    [self setInputView:self.pickerView];
    
    __weak STAPickerField *weakSelf = self;
    self.pickerView.pickerViewSelectionBlock = ^void(UIPickerView *pickerView, NSInteger component, NSInteger row, NSString *title){
        weakSelf.text = title;
    };
}

//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
//    
//}
//
//- (NSInteger)pickerView:(UIPickerView *)pickerView
//numberOfRowsInComponent:(NSInteger)component
//{
//    
//}

//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    
//    return 1;
//}
//
//- (NSInteger)pickerView:(UIPickerView *)pickerView
//numberOfRowsInComponent:(NSInteger)component
//{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    
//    return 0;
//}

@end
