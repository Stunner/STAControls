//
//  SampleSTAButtonViewController.m
//  STAControls
//
//  Created by Aaron Jubbal on 5/19/15.
//  Copyright (c) 2015 Aaron Jubbal. All rights reserved.
//

#import "SampleSTAButtonViewController.h"
#import "STAButton.h"

@interface SampleSTAButtonViewController ()

@property (nonatomic, strong) IBOutlet STAButton *button;

@end

@implementation SampleSTAButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.button setBackgroundColor:[UIColor grayColor] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
