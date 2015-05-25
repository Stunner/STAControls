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
#import "STAControls.h"

@interface STATextFieldTests : KIFTestCase

@end

@implementation STATextFieldTests

- (void)beforeAll {
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] inTableViewWithAccessibilityIdentifier:@"RootTableView"];
}

//- (void)afterAll {
//    [tester tapViewWithAccessibilityLabel:@"Back"];
//}

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    STATextField *textField = (STATextField *)[tester waitForViewWithAccessibilityLabel:@"TextField"];
    textField.clearButtonMode = UITextFieldViewModeAlways;
    [self tapClearButtonInTextField:textField];
}

- (void)tapClearButtonInTextField:(UITextField *)textField {
    CGFloat textFieldRightEdge = textField.frame.origin.x + textField.frame.size.width;
    CGFloat textFieldYCenter = textField.frame.origin.y + textField.frame.size.height / 2;
    [tester tapScreenAtPoint:CGPointMake(textFieldRightEdge - 3.0, textFieldYCenter)]; // tap clear button
}

- (void)testDecimalEntryTextField {
    NSString *atmTextFieldAccessibilityLabel = @"ATMTextField";
    STATextField *atmTextField = (STATextField *)[tester waitForViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel];
    
    [tester enterText:@"1234" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"12.34"];
    [self tapClearButtonInTextField:atmTextField];
    [tester waitForViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel value:@"0.00" traits:UIAccessibilityTraitNone];
    
    [tester enterText:@".8" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"0.80"];
    [tester enterText:@"." intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"8.00"];
    [tester enterText:@"3" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"8.30"];
    [tester enterText:@"5" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"8.35"];
    [tester enterText:@"8" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"83.58"];
    [tester enterText:@"0." intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"83580.00"];
    [tester enterText:@"\b" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"8358.00"];
    [tester enterText:@"." intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"8358.00"];
    [tester enterText:@"4" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"8358.40"];
                                                                                                                                            // adding a '.7' changes it to '83580.07' which is incorrect
    [tester enterText:@"." intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"83584.00"];
}

- (void)testClearButtonState {
    STAResizingTextField *resizingTextField = (STAResizingTextField *)[tester waitForViewWithAccessibilityLabel:@"ResizingTextField"];
    
    resizingTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    XCTAssert(!resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    [tester enterText:@"R" intoViewWithAccessibilityLabel:@"ResizingTextField"];
    XCTAssert(resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    [tester enterText:@"esizing test" intoViewWithAccessibilityLabel:@"ResizingTextField"
               traits:UIAccessibilityTraitNone
       expectedResult:@"Resizing test"];
    
    [tester tapViewWithAccessibilityLabel:@"HideKeyboard"];
    XCTAssert(!resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    
    [tester tapViewWithAccessibilityLabel:@"ResizingTextField"];
    XCTAssert(resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    
    [self tapClearButtonInTextField:resizingTextField];
    [tester waitForViewWithAccessibilityLabel:@"ResizingTextField" value:@"" traits:UIAccessibilityTraitNone];
    XCTAssert(!resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    
    resizingTextField.clearButtonMode = UITextFieldViewModeAlways;
    XCTAssert(resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    [tester enterText:@"Clear button is now always visible" intoViewWithAccessibilityLabel:@"ResizingTextField"];
    XCTAssert(resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    [tester tapViewWithAccessibilityLabel:@"HideKeyboard"];
    XCTAssert(resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    [self tapClearButtonInTextField:resizingTextField];
    [tester waitForViewWithAccessibilityLabel:@"ResizingTextField" value:@"" traits:UIAccessibilityTraitNone];
    XCTAssert(!resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    
    resizingTextField.clearButtonMode = UITextFieldViewModeNever;
    XCTAssert(!resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    [tester enterText:@"Clear button is now never visible" intoViewWithAccessibilityLabel:@"ResizingTextField"];
    XCTAssert(!resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    [tester tapViewWithAccessibilityLabel:@"HideKeyboard"];
    XCTAssert(!resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    [tester enterText:@"\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b"
intoViewWithAccessibilityLabel:@"ResizingTextField"
               traits:UIAccessibilityTraitNone
       expectedResult:@""];
    XCTAssert(!resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    
    resizingTextField.clearButtonMode = UITextFieldViewModeUnlessEditing;
    XCTAssert(!resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    [tester enterText:@"Clear button is now visible when not first responder" intoViewWithAccessibilityLabel:@"ResizingTextField"];
    XCTAssert(!resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    [tester tapViewWithAccessibilityLabel:@"HideKeyboard"];
    XCTAssert(resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    [self tapClearButtonInTextField:resizingTextField];
    [tester waitForViewWithAccessibilityLabel:@"ResizingTextField" value:@"" traits:UIAccessibilityTraitNone];
    XCTAssert(!resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    
    [tester enterText:@"Some text" intoViewWithAccessibilityLabel:@"ResizingTextField"];
    XCTAssert(!resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    resizingTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    XCTAssert(resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    
    [tester tapViewWithAccessibilityLabel:@"HideKeyboard"];
    XCTAssert(!resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    resizingTextField.clearButtonMode = UITextFieldViewModeUnlessEditing;
    XCTAssert(resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    
    [tester tapViewWithAccessibilityLabel:@"ResizingTextField"];
    XCTAssert(!resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    resizingTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    XCTAssert(resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    resizingTextField.clearButtonMode = UITextFieldViewModeUnlessEditing;
    XCTAssert(!resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
}

- (void)testTextValue {
    STATextField *textField = (STATextField *)[tester waitForViewWithAccessibilityLabel:@"TextField"];
    XCTAssert([textField.textValue isEqualToString:@"placeholder text"], @"Improper textValue value.");
    [tester enterText:@"Testing text value now" intoViewWithAccessibilityLabel:@"TextField"];
    XCTAssert([textField.textValue isEqualToString:@"Testing text value now"], @"Improper textValue value.");
}

// general test case, should be split up into separate functions as tests get more elaborate/complex
- (void)testFields {
//    [tester enterText:@"1234" intoViewWithAccessibilityLabel:@"ATMTextField" traits:UIAccessibilityTraitNone expectedResult:@"12.34"];
    [tester enterText:@"This is a test of\n" intoViewWithAccessibilityLabel:@"TextField"];
    [tester waitForFirstResponderWithAccessibilityLabel:@"DateTextField"];
    [tester selectDatePickerValue:@[@"Nov 7", @"1", @"28", @"PM"]];
    [tester tapViewWithAccessibilityLabel:@"Next"];
    [tester waitForFirstResponderWithAccessibilityLabel:@"NextTextField"];
    [tester enterText:@"the emergency broadcast system.\n" intoViewWithAccessibilityLabel:@"NextTextField"];
    [tester waitForAbsenceOfSoftwareKeyboard];
}


@end
