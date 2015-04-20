//
//  STASegmentedControl.m
//  STAControls
//
//  Created by Aaron Jubbal on 4/19/15.
//  Copyright (c) 2015 Aaron Jubbal. All rights reserved.
//

#import "STASegmentedControl.h"

@implementation STASegmentedControl

// reference: http://stackoverflow.com/a/21459772/347339
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    CGPoint locationPoint = [[touches anyObject] locationInView:self];
    CGPoint viewPoint = [self convertPoint:locationPoint fromView:self];
    if ([self pointInside:viewPoint withEvent:event]) {
//        NSInteger oldValue = self.selectedSegmentIndex;
        
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
//        if (oldValue == self.selectedSegmentIndex)
//        {
//            [super setSelectedSegmentIndex:UISegmentedControlNoSegment];
//            [self sendActionsForControlEvents:UIControlEventValueChanged];
//        }
    } else {
        [self sendActionsForControlEvents:UIControlEventTouchUpOutside];
    }
}

@end
