//
//  STAPickerView.m
//  STATextField
//
//  Created by Aaron Jubbal on 1/14/15.
//  Copyright (c) 2015 Aaron Jubbal. All rights reserved.
//

#import "STAPickerView.h"
#import "STACommon.h"

@implementation STAPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    STALog(@"%s", __PRETTY_FUNCTION__);
    
//    STALog(@"# comonents: %d", self.titleArray.count);
    return self.titleArray.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    STALog(@"%s", __PRETTY_FUNCTION__);
    
//    STALog(@"# rows in component %d: %lu", component, [(NSArray *)[self.titleArray objectAtIndex:component] count]);
    return [(NSArray *)[self.titleArray objectAtIndex:component] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    STALog(@"%s", __PRETTY_FUNCTION__);
    
    return [(NSArray *)[self.titleArray objectAtIndex:component] objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    STALog(@"%s", __PRETTY_FUNCTION__);
    
    if (self.pickerViewSelectionBlock) {
        NSString *title = [[self.titleArray objectAtIndex:component] objectAtIndex:row];
        self.pickerViewSelectionBlock(pickerView, component, row, title);
    }
}

@end
