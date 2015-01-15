//
//  ViewController.m
//  STATextField
//
//  Created by Aaron Jubbal on 10/16/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "ViewController.h"
#import "STAATMTextField.h"
#import "STATextView.h"
#import "STAPickerField.h"

@interface ViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) IBOutlet STAATMTextField *atmTextField;
@property (nonatomic, strong) IBOutlet STATextField *textField;
@property (nonatomic, strong) IBOutlet STAPickerField *dateTextField;
@property (nonatomic, strong) IBOutlet STATextField *nextTextField;
@property (nonatomic, strong) IBOutlet STATextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _atmTextField.placeholder = @"Hello world!";
    _atmTextField.keyboardType = UIKeyboardTypeDecimalPad;
//    _atmTextField.atmEntryEnabled = YES;
    _atmTextField.showDoneButton = YES;
    
    _textField.resignsFirstResponderUponReturnKeyPress = YES;
    _textField.nextFirstResponderUponReturnKeyPress = _dateTextField;
    _textField.showDoneButton = YES;
    _textField.showNextButton = YES;
    
    _dateTextField.nextFirstResponderUponReturnKeyPress = _nextTextField;
    _dateTextField.showDoneButton = YES;
    _dateTextField.showNextButton = YES;
    _dateTextField.pickerView.titleArray = @[@[@"Geometry", @"Trigonometry", @"Calculus", @"Chemistry"]];
    _dateTextField.pickerView.pickerViewSelectionBlock = ^void(UIPickerView *pickerView, NSInteger component, NSInteger row, NSString *title){
        NSLog(@"\npickerView: %@ \ncomponent: %lu\nrow: %lu\ntitle: %@", pickerView, component, row, title);
    };
    
//    _textView.expandsUpward = YES;
    _textView.layer.borderWidth = 1.0f;
    _textView.layer.cornerRadius = 5;
    _textView.layer.borderColor = [[UIColor grayColor] CGColor];
    _textView.autoDeterminesHeight = YES;
}


- (IBAction)hideKeyboard:(id)sender {
    [_atmTextField resignFirstResponder];
    [_textField resignFirstResponder];
    [_dateTextField resignFirstResponder];
    [_nextTextField resignFirstResponder];
    [_textView resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
