//
//  NSAttributedString+STAUtils.m
//  STAUtils
//
//  Created by Aaron Jubbal on 2/19/15.
//  Copyright (c) 2015 Aaron Jubbal. All rights reserved.
//

#import "NSAttributedString+STAUtils.h"

@implementation NSAttributedString (STAUtils)

- (NSRange)rangeOfString:(NSString *)aString {
    return [[self string] rangeOfString:aString];
}

- (NSAttributedString *)characterLeftOfLocation:(NSUInteger)location {
    if (location < 1) {
        return nil;
    }
    return [self attributedSubstringFromRange:NSMakeRange(location - 1, 1)];
}

- (NSAttributedString *)characterRightOfLocation:(NSUInteger)location {
    if (location < 1 || location > self.length - 2) {
        return nil;
    }
    return [self attributedSubstringFromRange:NSMakeRange(location + 1, 1)];
}

@end
