//
//  STASegmentedControlTests.m
//  STAControls
//
//  Created by Aaron Jubbal on 5/26/15.
//  Copyright (c) 2015 Aaron Jubbal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <KIF/KIF.h>
#import "STAControls.h"

@interface STASegmentedControlTests : KIFTestCase

@end

@implementation STASegmentedControlTests

- (void)beforeAll {
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] inTableViewWithAccessibilityIdentifier:@"RootTableView"];
}

- (void)afterAll {
    [tester tapViewWithAccessibilityLabel:@"Back"];
}

- (void)testSegmentedControl {
    
}

@end
