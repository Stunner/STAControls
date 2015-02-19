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

@end
