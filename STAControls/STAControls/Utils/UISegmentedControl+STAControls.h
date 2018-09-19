//
//  UISegmentedControl+TULAdditions.h
//  TipUtil
//
//  Created by Aaron Jubbal on 10/5/14.
//
//

#import <UIKit/UIKit.h>

@interface UISegmentedControl (STAControls)

- (void)setAccessibilityLabels:(NSArray *)accessibilityLabels
  correspondingToSegmentTitles:(NSArray *)segmentTitles;

@end
