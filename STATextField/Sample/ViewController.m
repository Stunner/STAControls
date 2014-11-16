//
//  ViewController.m
//  STATextField
//
//  Created by Aaron Jubbal on 10/16/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "ViewController.h"
#import "STAATMTextField.h"
#import "STAResizingTextField.h"

@interface ViewController ()

@property (nonatomic, strong) IBOutlet STAATMTextField *atmTextField;
@property (nonatomic, strong) IBOutlet STATextField *textField;
@property (nonatomic, strong) STATextField *resizingTextField;
@property (nonatomic, strong) IBOutlet STATextField *nextTextField;

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
    _textField.nextFirstResponderUponReturnKeyPress = _nextTextField;
    _textField.showDoneButton = YES;
    _textField.showNextButton = YES;

    _resizingTextField = [[STAResizingTextField alloc] initWithFrame:CGRectMake(200, 180, 50, 30)];
    _resizingTextField.borderStyle = UITextBorderStyleRoundedRect;
    _resizingTextField.placeholder = @"Hello world!";
    _resizingTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_resizingTextField];
    
    [_resizingTextField addTarget:self
                           action:@selector(textFieldDidChange:)
                 forControlEvents:UIControlEventEditingChanged];
}

- (void) textFieldDidChange: (UITextField*) textField
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
//    [UIView animateWithDuration:0.1 animations:^{
//        [textField invalidateIntrinsicContentSize];
//    }];
}

- (IBAction)hideKeyboard:(id)sender {
    [_atmTextField resignFirstResponder];
    [_textField resignFirstResponder];
    [_nextTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
