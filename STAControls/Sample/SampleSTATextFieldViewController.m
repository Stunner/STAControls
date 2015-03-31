//
//  SampleSTATextFieldViewController.m
//  STAControls
//
//  Created by Aaron Jubbal on 3/31/15.
//  Copyright (c) 2015 Aaron Jubbal. All rights reserved.
//

#import "SampleSTATextFieldViewController.h"
#import "STAControls.h"

@interface SampleSTATextFieldViewController ()

@property (nonatomic, strong) IBOutlet STAATMTextField *atmTextField;
@property (nonatomic, strong) IBOutlet STATextField *textField;
@property (nonatomic, strong) IBOutlet STAResizingTextField *resizingTextField;
@property (nonatomic, strong) IBOutlet STATextField *dateTextField;
//@property (nonatomic, strong) IBOutlet STAPickerField *dateTextField;
@property (nonatomic, strong) IBOutlet STATextField *nextTextField;
@property (nonatomic, strong) IBOutlet STATextView *textView;

@end

@implementation SampleSTATextFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"STATextField";
    
    _atmTextField.placeholder = @"Hello world!";
    _atmTextField.keyboardType = UIKeyboardTypeDecimalPad;
    //    _atmTextField.atmEntryEnabled = YES;
    _atmTextField.showBackForwardToolbar = YES;
    
    _textField.resignsFirstResponderUponReturnKeyPress = YES;
    _textField.prevControl = _resizingTextField;
    _textField.nextControl = _dateTextField;
    _textField.showBackForwardToolbar = YES;
    //    _textField.showNextButton = YES;
    _textField.placeholder = @"placeholder text";
    //    _textField.maxCharacterLength = 15;
    
    //    _resizingTextField = [[STAResizingTextField alloc] initWithFrame:CGRectMake(200, 180, 50, 30)];
    _resizingTextField.borderStyle = UITextBorderStyleRoundedRect;
    _resizingTextField.placeholder = @"Hello world!";
    _resizingTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _resizingTextField.resizesForClearTextButton = YES;
    //    [self.view addSubview:_resizingTextField];
    
    [_resizingTextField addTarget:self
                           action:@selector(textFieldDidChange:)
                 forControlEvents:UIControlEventEditingChanged];
    
    _dateTextField.prevControl = _textField;
    _dateTextField.nextControl = _nextTextField;
    _dateTextField.showBackForwardToolbar = YES;
    //    _dateTextField.showNextButton = YES;
    //    _dateTextField.pickerView.titleArray = @[@[@"Geometry", @"Trigonometry", @"Calculus", @"Chemistry"]];
    
    //    _dateTextField.pickerView.pickerViewSelectionBlock = ^void(UIPickerView *pickerView, NSInteger component, NSInteger row, NSString *title){
    //        NSLog(@"\npickerView: %@ \ncomponent: %lu\nrow: %lu\ntitle: %@", pickerView, component, row, title);
    //    };
    
    //    _textView.expandsUpward = YES;
    _textView.layer.borderWidth = 1.0f;
    _textView.layer.cornerRadius = 5;
    _textView.layer.borderColor = [[UIColor grayColor] CGColor];
    _textView.autoDeterminesHeight = YES;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
