//
//  STAUtility.m
//  STATextField
//
//  Created by Aaron Jubbal on 10/24/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "STATextFieldUtility.h"

@implementation STATextFieldUtility

+ (void)selectTextForInput:(UITextField *)input
                   atRange:(NSRange)range
{
    UITextPosition *start = [input positionFromPosition:[input beginningOfDocument]
                                                 offset:range.location];
    UITextPosition *end = [input positionFromPosition:start
                                               offset:range.length];
    [input setSelectedTextRange:[input textRangeFromPosition:start toPosition:end]];
}

+ (NSString *) append:(id) first, ...
{
    
    NSString * result = @"";
    id eachArg;
    va_list alist;
    if(first)
    {
        result = [result stringByAppendingString:first];
        va_start(alist, first);
        while ((eachArg = va_arg(alist, id)))
            result = [result stringByAppendingString:eachArg];
        va_end(alist);
    }
    return result;
}

+ (NSString *)insertDecimalInString:(NSString *)string
                  atPositionFromEnd:(NSUInteger)position
{
    
    NSUInteger decimalPosition = string.length - position;
    NSString *leftOfDecimal = [string substringToIndex:decimalPosition];
    NSString *rightOfDecimal = [string substringFromIndex:decimalPosition];
    NSString *returnable = [STATextFieldUtility append:leftOfDecimal, @".", rightOfDecimal, nil];
    return returnable;
}

+ (BOOL)maintainTwoDigitsAfterDecimalForChangingCharacters:(NSString *)initialText
                                                   inRange:(NSRange)range
                                                  toString:(NSString *)string
{
    NSString *newString = [initialText stringByReplacingCharactersInRange:range
                                                               withString:string];
    // determine if there are two digits after the decimal
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"."];
    NSRange decimalRange = [newString rangeOfCharacterFromSet:charSet];
    if (decimalRange.location != NSNotFound)
        return ((newString.length-1) - decimalRange.location < 3);
    return YES;
}

/**
 @see http://stackoverflow.com/questions/2166809/number-of-occurrences-of-a-substring-in-an-nsstring
 */
+ (NSUInteger) numberOfOccurrencesOfString:(NSString *)needle
                                  inString:(NSString *)haystack
{
    const char * rawNeedle = [needle UTF8String];
    NSUInteger needleLength = strlen(rawNeedle);
    
    const char * rawHaystack = [haystack UTF8String];
    NSUInteger haystackLength = strlen(rawHaystack);
    
    NSUInteger needleCount = 0;
    NSUInteger needleIndex = 0;
    for (NSUInteger index = 0; index < haystackLength; ++index) {
        const char thisCharacter = rawHaystack[index];
        if (thisCharacter != rawNeedle[needleIndex]) {
            needleIndex = 0; //they don't match; reset the needle index
        }
        
        //resetting the needle might be the beginning of another match
        if (thisCharacter == rawNeedle[needleIndex]) {
            needleIndex++; //char match
            if (needleIndex >= needleLength) {
                needleCount++; //we completed finding the needle
                needleIndex = 0;
            }
        }
    }
    
    return needleCount;
}// numberOfOccurrencesOfString:inString:

+ (BOOL)shouldChangeCharacters:(NSString *)initialText
                       inRange:(NSRange)range
                      toString:(NSString *)string
                characterLimit:(NSInteger)characterLimit
                  allowDecimal:(BOOL)allowDecimal
{
    NSString *newString = [initialText stringByReplacingCharactersInRange:range
                                                               withString:string];
    NSUInteger activeCharacterLimit = characterLimit;
    NSUInteger decimalCount = [STATextFieldUtility numberOfOccurrencesOfString:@"." inString:newString];
    if (allowDecimal) {
        if (decimalCount == 0) {
            activeCharacterLimit = characterLimit - 3; // needs to compensate for the 3 characters: .xx
        } else if (decimalCount == 1) {
            activeCharacterLimit = characterLimit;
            NSUInteger characteristicCharacterLimit = characterLimit - 3;
            NSString *characteristic = [[newString componentsSeparatedByString:@"."] firstObject];
            if (characteristic.length > characteristicCharacterLimit) {
                return NO;
            }
        } else { // decimalCount > 1
            return NO;
        }
    } else { // decimal not allowed
        if (decimalCount > 0) {
            return NO;
        }
    }
    if (newString.length > activeCharacterLimit)
        return NO;
    
    return [STATextFieldUtility maintainTwoDigitsAfterDecimalForChangingCharacters:initialText
                                                                          inRange:range
                                                                         toString:string];
    return YES;
}

@end
