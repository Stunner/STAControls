//
//  NSMutableAttributedString+STAControls.m
//  STAControls
//
//  Created by Aaron Jubbal on 2/2/15.
//  Copyright (c) 2015 Aaron Jubbal. All rights reserved.
//

#import "NSMutableAttributedString+STAControls.h"

@implementation NSMutableAttributedString (STAControls)

- (void)removeAttributesInDictionary:(NSDictionary *)attributeDictionary
                            forRange:(NSRange)range
{
    for (NSString *key in [attributeDictionary allKeys]) {
        [self removeAttribute:key range:range];
    }
}

@end
