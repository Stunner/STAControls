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
#import "STATextFieldBase+PrivateHeaders.h"
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
        
        // TODO: need to investigate to see if this affects toggling of this setting without reinitialization of text field
        
        self.atmEntryHasBeenToggled = YES; // never set this back to NO
    }
}

#pragma mark Overrides

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(paste:) ||
        action == @selector(copy:))
    {
        return YES;
    }
    return NO;
}

- (void)copy:(id)sender {
    [[UIPasteboard generalPasteboard] setString:self.text];
}

- (void)paste:(id)sender {
    NSString *stringToPaste = [[UIPasteboard generalPasteboard] string];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setAllowsFloats:YES];
    if ([formatter numberFromString:stringToPaste]) {
        self.text = stringToPaste;
    }
}

- (CGRect)caretRectForPosition:(UITextPosition *)position {
    STALog(@"%s", __PRETTY_FUNCTION__);
    
    CGRect caretRect = [super caretRectForPosition:position];
    return caretRect;
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
        [self.afterDecimalString setString:@""];
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
    
    if (rightOfDecimalText.length < 2) {
        if ([rightOfDecimalText isEqualToString:@"0"]) {
            string = [string stringByAppendingString:@"0"];
        }
        rightOfDecimalText = [STATextFieldUtility append:rightOfDecimalText, @"0", nil];
    }
    
    NSString *lastTwoChars = (string.length > 1) ? [string substringFromIndex:string.length - 2] : nil;
    if ([lastTwoChars isEqualToString:rightOfDecimalText]) {
        return string;
    }
    
    NSString *stringVariant1 = [string stringByAppendingString:@"0"];
    NSString *stringVariant2 = [@"0" stringByAppendingString:string];
    NSString *lastTwoChars1 = [stringVariant1 substringFromIndex:stringVariant1.length - 2];
    NSString *lastTwoChars2 = [stringVariant2 substringFromIndex:stringVariant2.length - 2];
    if ([lastTwoChars1 isEqualToString:rightOfDecimalText]) {
        return stringVariant1;
    }
    if ([lastTwoChars2 isEqualToString:rightOfDecimalText]) {
        return stringVariant2;
    }
//    return nil;
    
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
    STALog(@"afterDecimalString: %@", self.afterDecimalString);
    if ([string isEqualToString:@""]) self.isInDecimalInputMode = NO; // backspace
    if (self.isInDecimalInputMode && ![string isEqualToString:@"."]) {
        [self.afterDecimalString appendString:string];
        if (self.afterDecimalString.length > 2) {
            self.isInDecimalInputMode = NO;
            [self.afterDecimalString setString:@""];
        } else {
            if (cleansedString.length > 0) {
                NSString *stringToBeShifted = [[cleansedString substringToIndex:cleansedString.length - ((cleansedString.length > 2) ? 3 : 1)] stringByAppendingString:self.afterDecimalString];
                cleansedString = [self shiftString:stringToBeShifted
                      untilTextAfterDecimalMatches:self.afterDecimalString];
            }
        }
    }
    
    // TODO: use a category method for this!
    NSString *lastTwoDigits = (cleansedString.length >= 2) ? [cleansedString substringFromIndex:cleansedString.length - 2] : nil;
    if ([string isEqualToString:@"."]) {
        if (cleansedString.length + 1 < self.maxCharacterLength) {
            self.isInDecimalInputMode = YES;
//            if (![lastTwoDigits isEqualToString:@"00"]) {
                cleansedString = [self shiftStringForDecimalEntry:cleansedString];
//            }
            [self.afterDecimalString setString:@""];
        }
    }
    
    if (self.maxCharacterLength) {
        if (cleansedString.length + 1 > self.maxCharacterLength) { // +1 for the decimal point that will be added in
            self.overageAmount = cleansedString.length + 1 - self.maxCharacterLength;
            cleansedString = [cleansedString substringToIndex:cleansedString.length - self.overageAmount];
            NSString *lastTwoDigits = [cleansedString substringFromIndex:cleansedString.length - 2];
            if (self.isInDecimalInputMode && ![lastTwoDigits isEqualToString:@"00"]) {
                [self.afterDecimalString setString:@""];
                [self.afterDecimalString appendString:[lastTwoDigits substringToIndex:1]];
            }
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
