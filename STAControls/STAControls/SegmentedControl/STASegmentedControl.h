//
//  STASegmentedControl.h
//  STAControls
//
//  Created by Aaron Jubbal on 4/19/15.
//  Copyright (c) 2015 Aaron Jubbal. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Adds `UIControlEventTouchUpInside` and `UIControlEventTouchUpOutside` events to `UISegmentedControl`.
 */
@interface STASegmentedControl : UISegmentedControl

/**
 Denotes if selected segments can be tapped to deselect them (consequently 
 setting `selectedSegmentIndex` to `UISegmentedControlNoSegment`). Defaults to NO.
 */
@property (nonatomic, assign) BOOL toggleableSegments;

@end
