//
//  STATextField.m
//  STATextField
//
//  Created by Aaron Jubbal on 10/17/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "STATextField.h"
#import "STATextFieldBase+ProvideHeaders.h"

@interface STATextField () {
    NSString *_internalPlaceholder;
    NSAttributedString *_internalAttributedPlaceholder;
}

@end

@implementation STATextField

- (void)initInternal {
    [super initInternal];
    
    _resignsFirstResponderUponReturnKeyPress = YES;
    _internalPlaceholder = self.placeholder;
    _internalAttributedPlaceholder = self.attributedPlaceholder;
}

#pragma mark Setters (of Catan)

- (void)doneClicked:(id)sender {
    [self endEditing:YES];
}

// reference: http://stackoverflow.com/a/20192857/347339
- (void)setShowDoneButton:(BOOL)showDoneButton {
    _showDoneButton = showDoneButton;
    if (_showDoneButton) {
        UIToolbar *keyboardDoneButtonView = [UIToolbar new];
        [keyboardDoneButtonView sizeToFit];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleBordered target:self
                                                                      action:@selector(doneClicked:)];
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [keyboardDoneButtonView setItems:@[flexibleSpace, doneButton]];
        self.inputAccessoryView = keyboardDoneButtonView;
    } else {
        self.inputAccessoryView = nil;
    }
}

- (void)nextClicked:(id)sender {
    [self resignFirstResponder];
    [self.nextFirstResponderUponReturnKeyPress becomeFirstResponder];
}

- (void)setShowNextButton:(BOOL)showNextButton {
    _showNextButton = showNextButton;
    if (_showNextButton) {
        UIToolbar *keyboardDoneButtonView = [UIToolbar new];
        [keyboardDoneButtonView sizeToFit];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleBordered target:self
                                                                      action:@selector(doneClicked:)];
        UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                                       style:UIBarButtonItemStyleBordered target:self
                                                                      action:@selector(nextClicked:)];
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [keyboardDoneButtonView setItems:@[doneButton, flexibleSpace, nextButton]];
        self.inputAccessoryView = keyboardDoneButtonView;
    } else {
        self.inputAccessoryView = nil;
    }
}

- (void)setNextFirstResponderUponReturnKeyPress:(UIControl *)nextFirstResponderUponReturnKeyPress {
    self.resignsFirstResponderUponReturnKeyPress = YES;
    _nextFirstResponderUponReturnKeyPress = nextFirstResponderUponReturnKeyPress;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _internalPlaceholder = placeholder;
    [super setPlaceholder:placeholder];
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    _internalAttributedPlaceholder = attributedPlaceholder;
    [super setAttributedPlaceholder:attributedPlaceholder];
}

#pragma mark Text Field Events

- (void)textFieldDidChange:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
   replacementString:(NSString *)string
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (self.resignsFirstResponderUponReturnKeyPress) {
        if (self.nextFirstResponderUponReturnKeyPress) {
            [textField resignFirstResponder];
            [self.nextFirstResponderUponReturnKeyPress becomeFirstResponder];
        } else {
            [textField resignFirstResponder];
        }
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // hide placeholder when editing begins
    [super setPlaceholder:nil];
    [super setAttributedPlaceholder:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([textField.text length] < 1) {
        if (_internalAttributedPlaceholder) { //TODO: consider looking at which field was set most recently to determine which placeholder gets priority
            textField.attributedPlaceholder = _internalAttributedPlaceholder;
        } else if (_internalPlaceholder) {
            textField.placeholder = _internalPlaceholder;
        }
    }
}

@end
