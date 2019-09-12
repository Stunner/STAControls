//
//  SampleSTASegmentedControlViewController.m
//  STAControls
//
//  Created by Aaron Jubbal on 4/20/15.
//  Copyright (c) 2015 Aaron Jubbal. All rights reserved.
//

#import "SampleSTASegmentedControlViewController.h"
#import "STASegmentedControl.h"
#import "STATextField.h"

@interface SampleSTASegmentedControlViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet STATextField *selectedIndexTextField;
@property (nonatomic, strong) IBOutlet STASegmentedControl *segmentedControl;
@property (nonatomic, strong) IBOutlet STASegmentedControl *toggleableSegmentedControl;

@end

@implementation SampleSTASegmentedControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem.accessibilityLabel = @"Back";
    
    self.toggleableSegmentedControl.toggleableSegments = YES;
    
    self.selectedIndexTextField.showBackForwardToolbar = YES;
    self.selectedIndexTextField.text = @"0";
    self.selectedIndexTextField.delegate = self;
}

- (IBAction)touchUpInside:(STASegmentedControl *)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSLog(@"%ld", (long)sender.selectedSegmentIndex);
}

- (IBAction)touchUpOutside:(STASegmentedControl *)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (IBAction)valueChanged:(STASegmentedControl *)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (sender.tag == 1) {
        self.selectedIndexTextField.text = [NSString stringWithFormat:@"%lu", sender.selectedSegmentIndex];
    }
    NSLog(@"%ld", (long)sender.selectedSegmentIndex);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSInteger integer = [textField.text integerValue];
    if (integer < 0 || integer >= self.segmentedControl.numberOfSegments) {
        self.segmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment;
    } else {
        self.segmentedControl.selectedSegmentIndex = integer;
    }
}

@end
