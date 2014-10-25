//
//  NSString+STATextField.m
//  STATextField
//
//  Created by Aaron Jubbal on 10/24/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "NSString+STATextField.h"

@implementation NSString (STATextField)

- (NSString *)repeatTimes:(NSUInteger)times {
    
    return [@"" stringByPaddingToLength:(times * [self length])
                             withString:self
                        startingAtIndex:0];
}

- (NSString*)stringByTrimmingLeadingZeroes {
    
    NSInteger i = 0;
    
    while ((i < [self length])
           && [[NSCharacterSet characterSetWithCharactersInString:@"0"]
               characterIsMember:[self characterAtIndex:i]])
    {
        i++;
    }
    return [self substringFromIndex:i];
}

- (BOOL)isNumeral {
    
    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    for (int i = 0; i < [self length]; i++) {
        unichar c = [self characterAtIndex:i];
        if ([myCharSet characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}

@end
