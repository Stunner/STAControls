//
//  STAATMTextField.m
//  STATextField
//
//  Created by Aaron Jubbal on 10/20/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "STAATMTextField.h"
#import "STATextField+PrivateHeaders.h"
#import "STATextFieldUtility.h"
#import "NSString+STATextField.h"

@implementation STAATMTextField

- (void)initInternal {
    [super initInternal];
    
    [super setText:@"0.00"];
}

- (void)setText:(NSString *)text {
    // do not update placeholder text to anything
}

- (CGRect)caretRectForPosition:(UITextPosition *)position {
    
    return CGRectZero;
}

- (BOOL)staTextField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
   replacementString:(NSString *)string
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range
                                                                  withString:string];
    
    [STATextFieldUtility selectTextForInput:textField
                                   atRange:NSMakeRange(textField.text.length, 0)];
    NSCharacterSet *excludedCharacters = [NSCharacterSet characterSetWithCharactersInString:@"."];
    NSString *cleansedString = [[newString componentsSeparatedByCharactersInSet:excludedCharacters] componentsJoinedByString:@""];
    cleansedString = [cleansedString stringByTrimmingLeadingZeroes];
    if (cleansedString.length < 3) {
        NSUInteger zeroesCount = 3-cleansedString.length;
        NSString *zeroes = [STATextFieldUtility insertDecimalInString:[@"0" repeatTimes:zeroesCount]
                                                    atPositionFromEnd:(zeroesCount - 1)];
        newString = [STATextFieldUtility append:zeroes, cleansedString, nil];
    } else {
        newString = [STATextFieldUtility insertDecimalInString:cleansedString
                                             atPositionFromEnd:2];
    }
    
    [super setText:newString];
//    if (newString.length < textField.text.length) { // update immediately when deleting
//        [self setText:newString];
//    } else {
//        [self performSelector:@selector(setText:) withObject:newString afterDelay:0.08];
//    }
    
    return NO;
}

@end
