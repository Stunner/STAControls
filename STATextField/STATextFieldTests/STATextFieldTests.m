//
//  STATextFieldTests.m
//  STATextFieldTests
//
//  Created by Aaron Jubbal on 10/16/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <KIF/KIF.h>

@interface STATextFieldTests : KIFTestCase

@end

@implementation STATextFieldTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
}

// general test case, should be split up into separate functions as tests get more elaborate/complex
- (void)testFields {
    // This is an example of a functional test case.
    [tester enterText:@"1234" intoViewWithAccessibilityLabel:@"ATMTextField" traits:UIAccessibilityTraitNone expectedResult:@"12.34"];
    [tester enterText:@"This is a test of\n" intoViewWithAccessibilityLabel:@"TextField"];
    [tester waitForFirstResponderWithAccessibilityLabel:@"DateTextField"];
    [tester selectDatePickerValue:@[@"Nov 7", @"1", @"28", @"PM"]];
    [tester tapViewWithAccessibilityLabel:@"Next"];
    [tester waitForFirstResponderWithAccessibilityLabel:@"NextTextField"];
    [tester enterText:@"the emergency broadcast system.\n" intoViewWithAccessibilityLabel:@"NextTextField"];
    [tester waitForAbsenceOfKeyboard];
}


@end
