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
#import "STACommon.h"

@implementation STAATMTextField

- (void)initInternal {
    [super initInternal];
    
    [super setText:@"0.00"];
    _atmEntryEnabled = YES;
}

- (void)setText:(NSString *)text {
    // do not update placeholder text to anything
}

- (CGRect)caretRectForPosition:(UITextPosition *)position {
    STALog(@"%s", __PRETTY_FUNCTION__);
    
    if (!self.atmEntryEnabled) {
        return [super caretRectForPosition:position];
    }
    return CGRectZero;
}

- (UITextPosition *)closestPositionToPoint:(CGPoint)point {
    STALog(@"%s", __PRETTY_FUNCTION__);
    
    if (!self.atmEntryEnabled) {
        return [super closestPositionToPoint:point];
    }
    // always return last text position to prevent moving of cursor
    return [self positionFromPosition:self.endOfDocument offset:0];
}

- (void)textFieldDidChange:(STATextFieldBase *)sender {
    STALog(@"%s", __PRETTY_FUNCTION__);
    
    [super textFieldDidChange:sender];
}

// TODO: add capability to type . and have text field compensate by shifting without having to enter '0'
- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    STALog(@"%s", __PRETTY_FUNCTION__);
    
    if (!self.atmEntryEnabled) {
        return YES;
    }
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range
                                                                  withString:string];
    
    [STATextFieldUtility selectTextForInput:textField
                                   atRange:NSMakeRange(textField.text.length, 0)];
    NSCharacterSet *excludedCharacters = [NSCharacterSet characterSetWithCharactersInString:@"."];
    NSString *cleansedString = [[newString componentsSeparatedByCharactersInSet:excludedCharacters] componentsJoinedByString:@""];
    cleansedString = [cleansedString stringByTrimmingLeadingZeroes];
    if (cleansedString.length < 3) {
        NSUInteger zeroesCount = 3 - cleansedString.length;
        NSString *zeroes = [STATextFieldUtility insertDecimalInString:[@"0" repeatTimes:zeroesCount]
                                                    atPositionFromEnd:(zeroesCount - 1)];
        newString = [STATextFieldUtility append:zeroes, cleansedString, nil];
    } else {
        newString = [STATextFieldUtility insertDecimalInString:cleansedString
                                             atPositionFromEnd:2];
    }
    
    [super setText:newString];
    
    return NO;
}

@end
