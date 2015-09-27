//
//  NSString+STATextField.h
//  STATextField
//
//  Created by Aaron Jubbal on 10/24/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (STATextField)

- (NSString *)repeatTimes:(NSUInteger)times;
- (NSString*)stringByTrimmingLeadingZeroes;
- (BOOL)isNumeral;
- (NSString *)append:(NSString *)string untilMaxCharacterCount:(NSUInteger)maxCharacterCount;

@end
