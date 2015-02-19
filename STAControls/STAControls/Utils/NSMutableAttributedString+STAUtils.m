//
//  NSMutableAttributedString+STAUtils.m
//  STAUtils
//
//  Created by Aaron Jubbal on 2/19/15.
//  Copyright (c) 2015 Aaron Jubbal. All rights reserved.
//

#import "NSMutableAttributedString+STAUtils.h"
#import "NSAttributedString+STAUtils.h"

@implementation NSMutableAttributedString (STAUtils)

- (void)removeFirstOccuranceOfSubstring:(NSString *)substring
                         beyondLocation:(NSUInteger)location
{
    NSAttributedString *beyondSubstring = [self attributedSubstringFromRange:NSMakeRange(location, self.length - location)];
    NSRange substringRange = [beyondSubstring rangeOfString:substring];
    if (substringRange.location != NSNotFound) {
        [self deleteCharactersInRange:NSMakeRange(substringRange.location + location, substringRange.length)];
    }
}

@end
