//
//  SampleSTASegmentedControlViewController.m
//  STAControls
//
//  Created by Aaron Jubbal on 4/20/15.
//  Copyright (c) 2015 Aaron Jubbal. All rights reserved.
//

#import "SampleSTASegmentedControlViewController.h"
#import "STASegmentedControl.h"

@interface SampleSTASegmentedControlViewController ()

@property (nonatomic, strong) IBOutlet STASegmentedControl *segmentedControl;

@end

@implementation SampleSTASegmentedControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchUpInside:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (IBAction)touchUpOutside:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (IBAction)valueChanged:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
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
