//
//  STAButtonTests.m
//  STAControls
//
//  Created by Aaron Jubbal on 5/26/15.
//  Copyright (c) 2015 Aaron Jubbal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <KIF/KIF.h>
#import "STAControls.h"
#import "STAControlsTests.h"

@interface STAButtonTests : KIFTestCase

@end

@implementation STAButtonTests

- (void)beforeAll {
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] inTableViewWithAccessibilityIdentifier:@"RootTableView"];
}

- (void)afterAll {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")) {
        [tester tapViewWithAccessibilityLabel:kRootViewControllerTitle];
    } else {
        [tester tapViewWithAccessibilityLabel:@"Back"];
    }
}

- (void)testButton {
    STAButton *button = (STAButton *)[tester waitForViewWithAccessibilityLabel:@"Button"];
    XCTAssert(!button.backgroundColor, @"background color is non-nil!");
    [tester tapViewWithAccessibilityLabel:@"Button"];
    XCTAssert(!button.backgroundColor, @"background color is non-nil!");
    
    [tester longPressViewWithAccessibilityLabel:@"Button" duration:1.0];
    XCTAssert(!button.backgroundColor, @"background color is non-nil!");
    
    button.backgroundColor = [UIColor blueColor];
    [tester longPressViewWithAccessibilityLabel:@"Button" duration:1.0];
    XCTAssert([button.backgroundColor isEqual:[UIColor blueColor]], @"background colors don't match!");
    
    [button setBackgroundColor:[UIColor redColor] forState:UIControlStateNormal];
    XCTAssert([button.backgroundColor isEqual:[UIColor redColor]], @"background colors don't match!");
    
    [button setBackgroundColor:[UIColor yellowColor] forState:UIControlStateNormal];
    XCTAssert([button.backgroundColor isEqual:[UIColor yellowColor]], @"background colors don't match!");
}

@end
