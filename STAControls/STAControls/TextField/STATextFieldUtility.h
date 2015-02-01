//
//  STAUtility.h
//  STATextField
//
//  Created by Aaron Jubbal on 10/24/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STATextFieldUtility : NSObject

+ (void)selectTextForInput:(UITextField *)input
                   atRange:(NSRange)range;

+ (NSString *) append:(id) first, ...;

+ (NSString *)insertDecimalInString:(NSString *)string
                  atPositionFromEnd:(NSUInteger)position;

+ (NSUInteger) numberOfOccurrencesOfString:(NSString *)needle
                                  inString:(NSString *)haystack;

+ (BOOL)shouldChangeCharacters:(NSString *)initialText
                       inRange:(NSRange)range
                      toString:(NSString *)string
                characterLimit:(NSInteger)characterLimit
                  allowDecimal:(BOOL)allowDecimal;

@end
