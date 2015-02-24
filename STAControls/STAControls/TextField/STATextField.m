//
//  STATextField.m
//  STATextField
//
//  Created by Aaron Jubbal on 10/17/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "STATextField.h"
#import "STAResizingTextField+PrivateHeaders.h"

@interface STATextField () {
    NSString *_internalPlaceholder;
    NSAttributedString *_internalAttributedPlaceholder;
}

@property (nonatomic, strong) NSString *textValue;

@end

@implementation STATextField

- (void)initInternal {
    [super initInternal];
    
    _internalPlaceholder = self.placeholder;
    _internalAttributedPlaceholder = self.attributedPlaceholder;
    
    if (_internalAttributedPlaceholder) { //TODO: consider looking at which field was set most recently to determine which placeholder gets priority
        self.textValue = [_internalAttributedPlaceholder string];
    } else if (_internalPlaceholder) {
        self.textValue = _internalPlaceholder;
    }
}

#pragma mark Setters (of Catan)

- (void)doneClicked:(id)sender {
    [self endEditing:YES];
}

// reference: http://stackoverflow.com/a/20192857/347339
- (void)setShowBackForwardToolbar:(BOOL)showDoneButton {
    _showBackForwardToolbar = showDoneButton;
    if (_showBackForwardToolbar) {
        UIToolbar *keyboardDoneButtonView = [UIToolbar new];
        [keyboardDoneButtonView sizeToFit];
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:105 target:self action:@selector(prevClicked:)];
        leftButton.accessibilityLabel = @"Previous";
        UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedSpace.width = 25.0;
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:106 target:self action:@selector(nextClicked:)];
        rightButton.accessibilityLabel = @"Next";
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleDone target:self
                                                                      action:@selector(doneClicked:)];
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [keyboardDoneButtonView setItems:@[leftButton, fixedSpace, rightButton, flexibleSpace, doneButton]];
        self.inputAccessoryView = keyboardDoneButtonView;
    } else {
        self.inputAccessoryView = nil;
    }
}

- (void)prevClicked:(id)sender {
    [self resignFirstResponder];
    [self.prevControl becomeFirstResponder];
}

- (void)nextClicked:(id)sender {
    [self resignFirstResponder];
    [self.nextControl becomeFirstResponder];
}

- (void)setShowNextButton:(BOOL)showNextButton {
    _showNextButton = showNextButton;
    if (_showNextButton) {
        UIToolbar *keyboardDoneButtonView = [UIToolbar new];
        [keyboardDoneButtonView sizeToFit];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleDone target:self
                                                                      action:@selector(doneClicked:)];
        UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                                       style:UIBarButtonItemStyleDone target:self
                                                                      action:@selector(nextClicked:)];
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [keyboardDoneButtonView setItems:@[doneButton, flexibleSpace, nextButton]];
        self.inputAccessoryView = keyboardDoneButtonView;
    } else {
        self.inputAccessoryView = nil;
    }
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

#pragma mark Helpers

//- (BOOL)resignFirstResponderUponReturnKeyPress {
//    BOOL resignedFirstResponderStatus = NO;
//    if (self.resignsFirstResponderUponReturnKeyPress) {
//        if (self.nextFirstResponderUponReturnKeyPress) {
//            resignedFirstResponderStatus = [self resignFirstResponder];
//            [self.nextFirstResponderUponReturnKeyPress becomeFirstResponder];
//        } else {
//            resignedFirstResponderStatus =[self resignFirstResponder];
//        }
//    }
//    return resignedFirstResponderStatus;
//}

#pragma mark Text Field Events

- (void)textFieldDidChange:(STATextFieldBase *)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([sender.text length] < 1) {
        if (_internalAttributedPlaceholder) { //TODO: consider looking at which field was set most recently to determine which placeholder gets priority
            self.textValue = [_internalAttributedPlaceholder string];
        } else if (_internalPlaceholder) {
            self.textValue = _internalPlaceholder;
        }
    } else {
        self.textValue = sender.text;
    }
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
   replacementString:(NSString *)string
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return [super textField:textField shouldChangeCharactersInRange:range replacementString:string];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [super resignFirstResponderUponReturnKeyPress];
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
