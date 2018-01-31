//
//  SampleSTATextFieldViewController.m
//  STAControls
//
//  Created by Aaron Jubbal on 3/31/15.
//  Copyright (c) 2015 Aaron Jubbal. All rights reserved.
//

#import "SampleSTATextFieldViewController.h"
#import "STAControls.h"

@interface SampleSTATextFieldViewController () <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet STAATMTextField *atmTextField;
@property (nonatomic, strong) IBOutlet STATextField *textField;
@property (nonatomic, strong) IBOutlet STATextField *resizingTextField;
@property (nonatomic, strong) IBOutlet STATextField *dateTextField;
//@property (nonatomic, strong) IBOutlet STAPickerField *dateTextField;
@property (nonatomic, strong) IBOutlet STATextField *nextTextField;
@property (nonatomic, strong) IBOutlet STATextView *textView;

@end

@implementation SampleSTATextFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"STATextField";
    self.navigationItem.leftBarButtonItem.accessibilityLabel = @"Back";
    
    self.atmTextField.placeholder = @"Hello world!";
    self.atmTextField.keyboardType = UIKeyboardTypeDecimalPad;
    //    self.atmTextField.atmEntryEnabled = YES;
    self.atmTextField.resizesForClearTextButton = YES;
    self.atmTextField.maxCharacterLength = 8;
    self.atmTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.atmTextField.delegate = self;
    
    self.textField.resignsFirstResponderUponReturnKeyPress = YES;
    //    self.textField.showNextButton = YES;
    self.textField.placeholder = @"placeholder text";
    //    self.textField.maxCharacterLength = 15;
    
    //    self.resizingTextField = [[STAResizingTextField alloc] initWithFrame:CGRectMake(200, 180, 50, 30)];
    self.resizingTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.resizingTextField.placeholder = @"Hello world!";
    self.resizingTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.resizingTextField.resizesForClearTextButton = YES;
    //    [self.view addSubview:_resizingTextField];
    
    [self.resizingTextField addTarget:self
                               action:@selector(textFieldDidChange:)
                     forControlEvents:UIControlEventEditingChanged];
    
    //    _dateTextField.showNextButton = YES;
    //    _dateTextField.pickerView.titleArray = @[@[@"Geometry", @"Trigonometry", @"Calculus", @"Chemistry"]];
    
    //    _dateTextField.pickerView.pickerViewSelectionBlock = ^void(UIPickerView *pickerView, NSInteger component, NSInteger row, NSString *title){
    //        NSLog(@"\npickerView: %@ \ncomponent: %lu\nrow: %lu\ntitle: %@", pickerView, component, row, title);
    //    };
    
    self.nextTextField.keyboardType = UIKeyboardTypeAlphabet;
    self.nextTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.nextTextField setClearButtonImage:[UIImage imageNamed:@"Clear Button Image"]
                                   forState:UIControlStateNormal];
    [self.nextTextField setClearButtonImage:[UIImage imageNamed:@"Clear Button Image 2"]
                                   forState:UIControlStateHighlighted];
//    _nextTextField.maxCharacterLength = 8;
//    _nextTextField.currencyRepresentation = YES;
//    _nextTextField.defaultValue = @"0.00";
    
    //    _textView.expandsUpward = YES;
    self.textView.layer.borderWidth = 1.0f;
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.textView.autoDeterminesHeight = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.atmTextField.showBackForwardToolbar = YES;
    
    self.textField.prevControl = self.resizingTextField;
    self.textField.nextControl = self.dateTextField;
    self.textField.showBackForwardToolbar = YES;
    
    self.dateTextField.prevControl = self.textField;
    self.dateTextField.nextControl = self.nextTextField;
    self.dateTextField.showBackForwardToolbar = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidChange:(UITextField *)textField {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
}

- (IBAction)hideKeyboard:(id)sender {
    [_atmTextField resignFirstResponder];
    [_textField resignFirstResponder];
    [_resizingTextField resignFirstResponder];
    [_dateTextField resignFirstResponder];
    [_nextTextField resignFirstResponder];
    [_textView resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSLog(@"text changed: %d", ((STATextField *)textField).textChanged);
}

@end
