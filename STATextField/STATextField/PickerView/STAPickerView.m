//
//  STAPickerView.m
//  STATextField
//
//  Created by Aaron Jubbal on 1/14/15.
//  Copyright (c) 2015 Aaron Jubbal. All rights reserved.
//

#import "STAPickerView.h"

@implementation STAPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
//    NSLog(@"# comonents: %d", self.titleArray.count);
    return self.titleArray.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
//    NSLog(@"# rows in component %d: %lu", component, [(NSArray *)[self.titleArray objectAtIndex:component] count]);
    return [(NSArray *)[self.titleArray objectAtIndex:component] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return [(NSArray *)[self.titleArray objectAtIndex:component] objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (self.pickerViewSelectionBlock) {
        NSString *title = [[self.titleArray objectAtIndex:component] objectAtIndex:row];
        self.pickerViewSelectionBlock(pickerView, component, row, title);
    }
}

@end
