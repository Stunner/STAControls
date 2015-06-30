//
//  STATextField.m
//  STATextField
//
//  Created by Aaron Jubbal on 10/17/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "STATextField.h"
#import "STAResizingTextField+PrivateHeaders.h"
#import "STACommon.h"
#import "STATextFieldUtility.h"
#import "STATextView.h"

@interface STATextField () {
    NSString *_internalPlaceholder;
    NSAttributedString *_internalAttributedPlaceholder;
}

//@property (nonatomic, strong) NSString *textValue;
@property (nonatomic, strong) UIBarButtonItem *rightChevron;
@property (nonatomic, strong) UIBarButtonItem *leftChevron;

@property (nonatomic, assign, readwrite) BOOL textChanged;
// used to determine value of textChanged property
@property (nonatomic, strong) NSString *initialText;

@end

@implementation STATextField

#pragma mark - Class Methods

+ (void)chainTextFieldsInArray:(NSArray *)controlsArray {
    STATextField *prevControl = nil;
    STATextField *currControl = nil;
    for (NSUInteger i = 0; i < controlsArray.count; i++) {
        if (!prevControl) {
            prevControl = controlsArray[i];
            continue;
        }
        currControl = controlsArray[i];
        if (([currControl isKindOfClass:[STATextField class]] || [currControl isKindOfClass:[STATextView class]]) &&
            ([prevControl isKindOfClass:[STATextField class]] || [prevControl isKindOfClass:[STATextView class]]))
        {
            prevControl.nextControl = currControl;
            currControl.prevControl = prevControl;
        }
        prevControl = currControl;
    }
}

#pragma mark - Instance Methods

- (void)initInternal {
    [super initInternal];
    
    _internalPlaceholder = self.placeholder;
    _internalAttributedPlaceholder = self.attributedPlaceholder;
    _showBackForwardToolbar = NO;
    _maxCharacterLength = 0;
    
//    if (_internalAttributedPlaceholder) { //TODO: consider looking at which field was set most recently to determine which placeholder gets priority
//        self.textValue = [_internalAttributedPlaceholder string];
//    } else if (_internalPlaceholder) {
//        self.textValue = _internalPlaceholder;
//    }
}

#pragma mark Getters

- (NSString *)textValue {
    STALog(@"%s", __PRETTY_FUNCTION__);
    
    if (self.text.length > 0) {
        return self.text ? self.text : @"";
    }
    return _internalPlaceholder ? _internalPlaceholder : @"";
}

#pragma mark Setters (of Catan)

- (void)setDefaultValue:(NSString *)defaultValue {
    _defaultValue = defaultValue;
    self.text = defaultValue;
}

// reference: http://stackoverflow.com/a/20192857/347339
- (void)setShowBackForwardToolbar:(BOOL)showBackForwardToolbar {
    _showBackForwardToolbar = showBackForwardToolbar;
    if (_showBackForwardToolbar) {
        UIToolbar *keyboardDoneButtonView = [UIToolbar new];
        [keyboardDoneButtonView sizeToFit];
        self.leftChevron = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:105
                                                                         target:self
                                                                         action:@selector(prevClicked:)];
        self.leftChevron.accessibilityLabel = @"Previous";
        [self updateEnabledStatusForBackChevron];
        
        UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
        fixedSpace.width = 25.0;
        self.rightChevron = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:106
                                                                          target:self
                                                                          action:@selector(nextClicked:)];
        self.rightChevron.accessibilityLabel = @"Next";
        [self updateEnabledStatusForForwardChevron];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleDone target:self
                                                                      action:@selector(doneClicked:)];
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                       target:nil
                                                                                       action:nil];
        [keyboardDoneButtonView setItems:@[self.leftChevron, fixedSpace, self.rightChevron, flexibleSpace, doneButton]];
        self.inputAccessoryView = keyboardDoneButtonView;
    } else {
        self.inputAccessoryView = nil;
    }
}

- (void)setPrevControl:(UIControl *)prevControl {
    _prevControl = prevControl;
    [self updateEnabledStatusForBackChevron];
}

- (void)setNextControl:(UIControl *)nextControl {
    [super setNextControl:nextControl];
    [self updateEnabledStatusForForwardChevron];
}

- (void)prevClicked:(id)sender {
    [self resignFirstResponder];
    [self.prevControl becomeFirstResponder];
}

- (void)nextClicked:(id)sender {
    [self resignFirstResponder];
    [self.nextControl becomeFirstResponder];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _internalPlaceholder = placeholder;
    [super setPlaceholder:placeholder];
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    STALog(@"%s", __PRETTY_FUNCTION__);
    
    _internalAttributedPlaceholder = attributedPlaceholder;
    [super setAttributedPlaceholder:attributedPlaceholder];
}

#pragma mark Helpers

- (void)updateEnabledStatusForForwardChevron {
    self.rightChevron.enabled = (self.nextControl);
}

- (void)updateEnabledStatusForBackChevron {
    self.leftChevron.enabled = (self.prevControl);
}

- (void)doneClicked:(id)sender {
    [self endEditing:YES];
}

#pragma mark Text Field Events

- (void)textFieldDidChange:(STATextFieldBase *)sender {
    STALog(@"%s", __PRETTY_FUNCTION__);
    
    [super textFieldDidChange:sender];
    
    if ([sender.text length] < 1) {
        if (_internalAttributedPlaceholder) { //TODO: consider looking at which field was set most recently to determine which placeholder gets priority
//            self.textValue = [_internalAttributedPlaceholder string];
        } else if (_internalPlaceholder) {
//            self.textValue = _internalPlaceholder;
        }
    } else {
//        self.textValue = sender.text;
    }
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
   replacementString:(NSString *)string
{
    STALog(@"%s", __PRETTY_FUNCTION__);
    
    // reference: http://stackoverflow.com/a/8913595/347339
    if (self.maxCharacterLength > 0) {
        NSUInteger oldLength = textField.text.length;
        NSUInteger replacementLength = string.length;
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        if (!returnKey) {
            if (newLength > self.maxCharacterLength) return NO;
        }
    }
    
    if (self.currencyRepresentation) {
        if (![STATextFieldUtility shouldChangeCharacters:textField.text
                                                 inRange:range
                                        toCurrencyString:string
                                          characterLimit:self.maxCharacterLength
                                            allowDecimal:YES])
        {
            return NO;
        }
    }
    
    return [super textField:textField shouldChangeCharactersInRange:range replacementString:string];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    STALog(@"%s", __PRETTY_FUNCTION__);
    
    [super textFieldDidBeginEditing:textField];
    
    // hide placeholder when editing begins
    [super setPlaceholder:nil];
    [super setAttributedPlaceholder:nil];
    
    self.initialText = textField.text;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    STALog(@"%s", __PRETTY_FUNCTION__);
    
    [super textFieldDidEndEditing:textField];
    
    if (self.currencyRepresentation) {
        if (textField.text.length > 0) {
            self.text = [NSString stringWithFormat:@"%.2f", [textField.text floatValue]];
        }
    }
    
    if ([textField.text length] < 1) {
        if (self.defaultValue) {
            self.text = self.defaultValue;
        } else {
            if (_internalAttributedPlaceholder) { //TODO: consider looking at which field was set most recently to determine which placeholder gets priority
                textField.attributedPlaceholder = _internalAttributedPlaceholder;
            } else if (_internalPlaceholder) {
                textField.placeholder = _internalPlaceholder;
            }
        }
    }
    
    self.textChanged = (![textField.text isEqualToString:self.initialText]);
}

@end
