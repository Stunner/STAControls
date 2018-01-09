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
@property (strong, nonatomic) IBOutlet STAButton *multilineButton;

@end

@implementation SampleSTAButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.button setBackgroundColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.button setBackgroundColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [self.multilineButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    self.multilineButton.titleLabel.numberOfLines = 0;
    NSArray *attributes = @[@{NSForegroundColorAttributeName : [UIColor redColor]},
                            @{NSForegroundColorAttributeName : [UIColor greenColor]},
                            @{NSForegroundColorAttributeName : [UIColor orangeColor]}];
    [self.multilineButton setMultilineTitle:@"123\n45\n678" withLineAttributes:attributes forState:UIControlStateNormal];
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
