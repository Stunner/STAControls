//
//  UISegmentedControl+TULAdditions.m
//  TipUtil
//
//  Created by Aaron Jubbal on 10/5/14.
//
//

#import "UISegmentedControl+STAControls.h"

@implementation UISegmentedControl (STAControls)

- (void)setAccessibilityLabels:(NSArray *)accessibilityLabels
  correspondingToSegmentTitles:(NSArray *)segmentTitles
{
    if (accessibilityLabels.count != segmentTitles.count) {
        return;
    }
    NSMutableDictionary *titleToLabelMap = [[NSMutableDictionary alloc] initWithCapacity:accessibilityLabels.count];
    NSUInteger i = 0;
    for (NSString *accessibilityLabel in accessibilityLabels) {
        [titleToLabelMap setObject:accessibilityLabel forKey:segmentTitles[i]];
        i++;
    }
    NSArray *segments = [self subviews];
    for (id segment in segments) {
        for (id label in [segment subviews]) {
            if ([label isKindOfClass:[UILabel class]]) {
                NSString *accessibilityLabel = [titleToLabelMap objectForKey:((UILabel *)label).text];
                if (accessibilityLabel) {
                    ((UIView *)segment).accessibilityLabel = accessibilityLabel;
                }
            }
        }
    } // segment in segments
}

@end
