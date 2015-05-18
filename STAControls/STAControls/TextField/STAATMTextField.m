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
#import "STATextFieldBase+ProvideHeaders.h"
#import "NSString+STATextField.h"
#import "STACommon.h"

@interface STAATMTextField ()

@property (nonatomic, copy) NSString *lastSetText;
// helps determine when deviating from default _atmEntryEnabled setting **for the first time**
@property (nonatomic, assign) BOOL atmEntryHasBeenToggled; // TODO: thoroughly test
@property (nonatomic, copy) NSString *committedText;

// decimal behavior
@property (nonatomic, strong) NSMutableString *afterDecimalString;
@property (nonatomic, assign) BOOL isInDecimalInputMode;
@property (nonatomic, assign) NSUInteger overageAmount; // amount of chars over the max char limit

@end

@implementation STAATMTextField

- (void)initInternal {
    [super initInternal];
    
    [super setText:@"0.00"];
    self.keyboardType = UIKeyboardTypeDecimalPad;
    _atmEntryEnabled = YES;
    _atmEntryHasBeenToggled = NO;
    self.afterDecimalString = [[NSMutableString alloc] initWithCapacity:2];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    self.lastSetText = text;
}

- (void)setAtmEntryEnabled:(BOOL)atmEntryEnabled {
    STALog(@"%s", __PRETTY_FUNCTION__);
    
    BOOL initialAtmEntryEnabledValue = _atmEntryEnabled;
    _atmEntryEnabled = atmEntryEnabled;
    if (!atmEntryEnabled && !self.atmEntryHasBeenToggled) { // when deviating from default for the first time...
        [self setText:self.lastSetText];
    }
    if (initialAtmEntryEnabledValue != atmEntryEnabled) {
        self.atmEntryHasBeenToggled = YES; // never set this back to NO
    }
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

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    STALog(@"%s", __PRETTY_FUNCTION__);
    
    BOOL returnable = !self.atmEntryEnabled;
    if (self.atmEntryEnabled) {
        [super setText:@"0.00"];
        self.isInDecimalInputMode = NO;
    }
    
    [super textFieldShouldClear:textField];
    return returnable;
}

- (NSString *)shiftStringForDecimalEntry:(NSString *)string {
    STALog(@"%s", __PRETTY_FUNCTION__);
    
    NSUInteger zeroesCount = (self.afterDecimalString.length > 0) ? self.afterDecimalString.length : 2;
    string = [STATextFieldUtility append:string, [@"0" repeatTimes:zeroesCount], nil];
    return string;
}

- (NSString *)shiftString:(NSString *)string untilTextAfterDecimalMatches:(NSString *)rightOfDecimalText {
    STALog(@"%s", __PRETTY_FUNCTION__);
    
    NSUInteger zeroesCount = (rightOfDecimalText.length > 0) ? 2 - rightOfDecimalText.length : 0;
    if (string.length < 4) { // acommodate for case where string could be less than 4 characters (i.e. user enters '.3' for instance)
        string = [STATextFieldUtility append:[@"0" repeatTimes:4 - string.length], string, nil];
    }
    NSString *shiftedString = [string substringToIndex:self.overageAmount ? string.length - 2 : string.length - 3];
    string = [STATextFieldUtility append:shiftedString, rightOfDecimalText, [@"0" repeatTimes:zeroesCount], nil];
    return string;
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    STALog(@"%s", __PRETTY_FUNCTION__);
    
    BOOL returnFromSuper = [super textField:textField shouldChangeCharactersInRange:range replacementString:string];
    
    if (!self.atmEntryEnabled) {
        return returnFromSuper;
    }
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range
                                                                  withString:string];
    NSCharacterSet *excludedCharacters = [NSCharacterSet characterSetWithCharactersInString:@"."];
    NSString *cleansedString = [[newString componentsSeparatedByCharactersInSet:excludedCharacters] componentsJoinedByString:@""];
    cleansedString = [cleansedString stringByTrimmingLeadingZeroes];
    
    ////////////////////////////////////////////////
    // decimal character behavior:
    // logic for the capability to type . and have text field compensate by shifting without having to enter '0'
    if ([string isEqualToString:@""]) self.isInDecimalInputMode = NO; // backspace
    if (self.isInDecimalInputMode && ![string isEqualToString:@"."]) {
        [self.afterDecimalString appendString:string];
        if (self.afterDecimalString.length > 2) {
            self.isInDecimalInputMode = NO;
            [self.afterDecimalString setString:@""];
        } else {
            cleansedString = [self shiftString:cleansedString untilTextAfterDecimalMatches:self.afterDecimalString];
        }
    }
    
    NSString *lastTwoDigits = (cleansedString.length > 2) ? [cleansedString substringFromIndex:cleansedString.length - 2] : nil;
    if ([string isEqualToString:@"."] && ![lastTwoDigits isEqualToString:@"00"]) {
        self.isInDecimalInputMode = YES;
        cleansedString = [self shiftStringForDecimalEntry:cleansedString];
        [self.afterDecimalString setString:@""];
    }
    
    if (self.maxCharacterLength) {
        if (cleansedString.length + 1 > self.maxCharacterLength) { // +1 for the decimal point that will be added in
            self.overageAmount = cleansedString.length + 1 - self.maxCharacterLength;
            cleansedString = [cleansedString substringToIndex:cleansedString.length - self.overageAmount];
        } else {
            self.overageAmount = 0;
        }
    }
    //\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    
    // place decimal back in string
    if (cleansedString.length < 3) {
        NSUInteger zeroesCount = 3 - cleansedString.length;
        NSString *zeroes = [STATextFieldUtility insertDecimalInString:[@"0" repeatTimes:zeroesCount]
                                                    atPositionFromEnd:(zeroesCount - 1)];
        newString = [STATextFieldUtility append:zeroes, cleansedString, nil];
    } else {
        newString = [STATextFieldUtility insertDecimalInString:cleansedString
                                             atPositionFromEnd:2];
    }
    if (self.maxCharacterLength) {
        if (newString.length > self.maxCharacterLength) {
            return NO;
        }
    }
    
    self.committedText = newString;
    [STATextFieldUtility selectTextForInput:textField
                                    atRange:NSMakeRange(textField.text.length, 0)];
    
    return NO;
}

- (void)commitTextChanges {
    STALog(@"%s", __PRETTY_FUNCTION__);
    
    if (self.atmEntryEnabled) {
        [super setText:self.committedText];
    }
}

@end
