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
#import "STAControlsTests.h"

@interface STASegmentedControlTests : KIFTestCase

@end

@implementation STASegmentedControlTests

- (void)beforeAll {
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] inTableViewWithAccessibilityIdentifier:@"RootTableView"];
}

- (void)afterAll {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")) {
        [tester tapViewWithAccessibilityLabel:kRootViewControllerTitle];
    } else {
        [tester tapViewWithAccessibilityLabel:@"Back"];
    }
}

- (void)testSegmentedControl {
    
    STASegmentedControl *segmentedControl = (STASegmentedControl *)[tester waitForViewWithAccessibilityLabel:@"SegmentedControl"];
    
    [tester tapViewWithAccessibilityLabel:@"First"];
    XCTAssertEqual(segmentedControl.selectedSegmentIndex, 0, @"Selected segment index mismatch!");
    [tester tapViewWithAccessibilityLabel:@"First"];
    XCTAssertEqual(segmentedControl.selectedSegmentIndex, 0, @"Selected segment index mismatch!");
    
    [tester tapViewWithAccessibilityLabel:@"Second"];
    XCTAssertEqual(segmentedControl.selectedSegmentIndex, 1, @"Selected segment index mismatch!");
     [tester tapViewWithAccessibilityLabel:@"Second"];
    
    [tester tapViewWithAccessibilityLabel:@"Third"];
    XCTAssertEqual(segmentedControl.selectedSegmentIndex, 2, @"Selected segment index mismatch!");
    [tester tapViewWithAccessibilityLabel:@"Third"];
    XCTAssertEqual(segmentedControl.selectedSegmentIndex, 2, @"Selected segment index mismatch!");
    
    [tester tapViewWithAccessibilityLabel:@"Fourth"];
    XCTAssertEqual(segmentedControl.selectedSegmentIndex, 3, @"Selected segment index mismatch!");
    [tester tapViewWithAccessibilityLabel:@"Fourth"];
    XCTAssertEqual(segmentedControl.selectedSegmentIndex, 3, @"Selected segment index mismatch!");
    
    [tester tapViewWithAccessibilityLabel:@"Third"];
    XCTAssertEqual(segmentedControl.selectedSegmentIndex, 2, @"Selected segment index mismatch!");
    
    
    STASegmentedControl *toggleableSegmentedControl = (STASegmentedControl *)[tester waitForViewWithAccessibilityLabel:@"ToggleableSegmentedControl"];
    
    [tester tapViewWithAccessibilityLabel:@"First2"];
    XCTAssertEqual(toggleableSegmentedControl.selectedSegmentIndex, UISegmentedControlNoSegment, @"Selected segment index mismatch!");
    [tester tapViewWithAccessibilityLabel:@"First2"];
    XCTAssertEqual(toggleableSegmentedControl.selectedSegmentIndex, 0, @"Selected segment index mismatch!");
    
    [tester tapViewWithAccessibilityLabel:@"Second2"];
    XCTAssertEqual(toggleableSegmentedControl.selectedSegmentIndex, 1, @"Selected segment index mismatch!");
    [tester tapViewWithAccessibilityLabel:@"Second2"];
    XCTAssertEqual(toggleableSegmentedControl.selectedSegmentIndex, UISegmentedControlNoSegment, @"Selected segment index mismatch!");
    
    [tester tapViewWithAccessibilityLabel:@"Third2"];
    XCTAssertEqual(toggleableSegmentedControl.selectedSegmentIndex, 2, @"Selected segment index mismatch!");
    [tester tapViewWithAccessibilityLabel:@"Third2"];
    XCTAssertEqual(toggleableSegmentedControl.selectedSegmentIndex, UISegmentedControlNoSegment, @"Selected segment index mismatch!");
    [tester tapViewWithAccessibilityLabel:@"Third2"];
    XCTAssertEqual(toggleableSegmentedControl.selectedSegmentIndex, 2, @"Selected segment index mismatch!");
    
    [tester tapViewWithAccessibilityLabel:@"Fourth2"];
    XCTAssertEqual(toggleableSegmentedControl.selectedSegmentIndex, 3, @"Selected segment index mismatch!");
    [tester tapViewWithAccessibilityLabel:@"Fourth2"];
    XCTAssertEqual(toggleableSegmentedControl.selectedSegmentIndex, UISegmentedControlNoSegment, @"Selected segment index mismatch!");
    [tester tapViewWithAccessibilityLabel:@"Fourth2"];
    XCTAssertEqual(toggleableSegmentedControl.selectedSegmentIndex, 3, @"Selected segment index mismatch!");
    

}

@end
