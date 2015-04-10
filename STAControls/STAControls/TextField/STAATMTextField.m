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
@property (nonatomic, assign) NSUInteger insertionPositionFromEnd;
@property (nonatomic, copy) NSString *committedText;

@end

@implementation STAATMTextField

- (void)initInternal {
    [super initInternal];
    
    [super setText:@"0.00"];
    _atmEntryEnabled = YES;
    _atmEntryHasBeenToggled = NO;
    self.insertionPositionFromEnd = 0;
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
    if (cleansedString.length > 0) { // ensure we aren't working with 0.00
        
        // logic for the capability to type . and have text field compensate by shifting without having to enter '0'
        if (self.insertionPositionFromEnd > 0) {
            cleansedString = [[textField.text componentsSeparatedByCharactersInSet:excludedCharacters] componentsJoinedByString:@""];
            cleansedString = [cleansedString stringByTrimmingLeadingZeroes];
            
            NSUInteger characterInsertionPosition = cleansedString.length - self.insertionPositionFromEnd;
            NSString *lastTwoChars = (cleansedString.length > 2) ? [cleansedString substringFromIndex:cleansedString.length - 2] : nil;
            if ([string isEqualToString:@"."]) {
                if (![lastTwoChars isEqualToString:@"00"]) {
                    cleansedString = [STATextFieldUtility append:cleansedString, @"0", nil];
                    self.insertionPositionFromEnd = 2;
                }
            } else {
                cleansedString = [cleansedString stringByReplacingCharactersInRange:NSMakeRange(characterInsertionPosition, 1)
                                                                         withString:string];
                self.insertionPositionFromEnd--;
            }
        } else {
            NSString *lastTwoChars = (cleansedString.length > 2) ? [cleansedString substringFromIndex:cleansedString.length - 2] : nil;
            BOOL willGoOverMaxCharLength = NO;
            if (self.maxCharacterLength) {
                if (cleansedString.length + 2 > self.maxCharacterLength) {
                    willGoOverMaxCharLength = YES;
                }
            }
            if ([string isEqualToString:@"."] && ![lastTwoChars isEqualToString:@"00"] && !willGoOverMaxCharLength) {
                cleansedString = [STATextFieldUtility append:cleansedString, @"0", nil];
                self.insertionPositionFromEnd++;
                lastTwoChars = (cleansedString.length > 2) ? [cleansedString substringFromIndex:cleansedString.length - 2] : nil;
                
                if (self.maxCharacterLength) {
                    if (cleansedString.length + 2 > self.maxCharacterLength) {
                        willGoOverMaxCharLength = YES;
                    }
                }
                if (![lastTwoChars isEqualToString:@"00"] && !willGoOverMaxCharLength) {
                    cleansedString = [STATextFieldUtility append:cleansedString, @"0", nil];
                    self.insertionPositionFromEnd++;
                }
            }
        }
    }
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
