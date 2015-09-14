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
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSInteger previousSelectedSegmentIndex = self.selectedSegmentIndex;
    
    [super touchesEnded:touches withEvent:event];
    
    CGPoint locationPoint = [[touches anyObject] locationInView:self];
    CGPoint viewPoint = [self convertPoint:locationPoint fromView:self];
    if (self.toggleableSegments) { // toggle selected segment on/off
        if ([self pointInside:viewPoint withEvent:event] && previousSelectedSegmentIndex == self.selectedSegmentIndex) {
            [self setSelectedSegmentIndex:UISegmentedControlNoSegment];
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
    
    // add touch up inside/outside events
    if ([self pointInside:viewPoint withEvent:event]) {
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    } else {
        [self sendActionsForControlEvents:UIControlEventTouchUpOutside];
    }
}

@end
