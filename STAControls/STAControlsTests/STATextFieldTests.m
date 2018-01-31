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
#import "STATextFieldBase+PrivateHeaders.h"
#import "STAControlsTests.h"

@interface STATextFieldTests : KIFTestCase <UITextFieldDelegate>

@property (nonatomic, strong) NSInvocation *calledDelegateInvocation;

@end

@implementation STATextFieldTests

- (void)beforeAll {
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] inTableViewWithAccessibilityIdentifier:@"RootTableView"];
}

- (void)afterAll {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")) {
        [tester tapViewWithAccessibilityLabel:kRootViewControllerTitle];
    } else {
        [tester tapViewWithAccessibilityLabel:@"Back"];
    }
}

- (void)afterEach {
    STATextField *textField = (STATextField *)[tester waitForViewWithAccessibilityLabel:@"TextField"];
    textField.clearButtonMode = UITextFieldViewModeAlways;
    [self tapClearButtonInTextField:textField];
}

- (void)tapClearButtonInTextField:(UITextField *)textField {
    CGFloat textFieldRightEdge = textField.frame.origin.x + textField.frame.size.width;
    CGFloat textFieldYCenter = textField.frame.origin.y + textField.frame.size.height / 2;
    [tester tapScreenAtPoint:CGPointMake(textFieldRightEdge - 3.0, textFieldYCenter)]; // tap clear button
}

- (BOOL)isClearButtonVisibleInTextField:(STAResizingTextField *)textField {
    BOOL foundClearButton = NO;
    for (UIView *view in textField.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            foundClearButton = YES;
        }
    }
    return foundClearButton;
}

- (void)delegateMethodCalled:(NSString *)selectorString {
    XCTAssert([NSStringFromSelector(self.calledDelegateInvocation.selector) isEqualToString:selectorString], @"selectors not equal!");
    XCTAssert(self.calledDelegateInvocation.target == self, @"targets not equal!");
    self.calledDelegateInvocation = nil;
}

- (void)testDecimalEntryTextField {
    NSString *atmTextFieldAccessibilityLabel = @"ATMTextField";
    STATextField *atmTextField = (STATextField *)[tester waitForViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel];
    atmTextField.delegate = self;
    
    // test ATM text entry behavior
    [tester tapViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel];
    [self delegateMethodCalled:@"textFieldDidBeginEditing:"];
    [tester enterText:@"2" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"0.02"];
    [self delegateMethodCalled:@"textField:shouldChangeCharactersInRange:replacementString:"];
    
    [tester enterText:@"." intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"2.00"];
    [self delegateMethodCalled:@"textField:shouldChangeCharactersInRange:replacementString:"];
    [tester enterText:@"5" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"2.50"];
    [self delegateMethodCalled:@"textField:shouldChangeCharactersInRange:replacementString:"];
    
    [self tapClearButtonInTextField:atmTextField];
    [self delegateMethodCalled:@"textFieldShouldClear:"];
    [tester waitForViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel value:@"0.00" traits:UIAccessibilityTraitNone];
    
    [tester enterText:@"2" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"0.02"];
    [self delegateMethodCalled:@"textField:shouldChangeCharactersInRange:replacementString:"];
    [tester enterText:@"." intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"2.00"];
    [self delegateMethodCalled:@"textField:shouldChangeCharactersInRange:replacementString:"];
    [tester enterText:@"5" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"2.50"];
    [self delegateMethodCalled:@"textField:shouldChangeCharactersInRange:replacementString:"];
    
    [self tapClearButtonInTextField:atmTextField];
    [self delegateMethodCalled:@"textFieldShouldClear:"];
    [tester waitForViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel value:@"0.00" traits:UIAccessibilityTraitNone];
    
    [tester enterText:@"1" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"0.01"];
    [tester enterText:@"\b" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"0.00"];
    [tester enterText:@"\b" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"0.00"];
    [tester enterText:@"1" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"0.01"];
    [tester enterText:@"2" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"0.12"];
    [tester enterText:@"3" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"1.23"];
    [tester enterText:@"4" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"12.34"];
    [tester enterText:@"\b" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"1.23"];
    [tester enterText:@"\b" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"0.12"];
    [tester enterText:@"5" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"1.25"];
    [tester enterText:@"6" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"12.56"];
    [tester enterText:@"7" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"125.67"];
    [tester enterText:@"0" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"1256.70"];
    [tester enterText:@"8" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"12567.08"];
    [tester enterText:@"9" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"12567.08"]; // shouldn't change, hit max char limit
    
    [self tapClearButtonInTextField:atmTextField];
    [tester waitForViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel value:@"0.00" traits:UIAccessibilityTraitNone];
    
    // test decimal button behavior
    [tester enterText:@".8" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"0.80"];
    [tester enterText:@"." intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"8.00"];
    [tester enterText:@"3" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"8.30"];
    [tester enterText:@"5" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"8.35"];
    
    [self tapClearButtonInTextField:atmTextField];
    [tester waitForViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel value:@"0.00" traits:UIAccessibilityTraitNone];
    
    [tester enterText:@"." intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"0.00"];
    [tester enterText:@"0" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"0.00"];
    [tester enterText:@"8" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"0.08"];
    [tester enterText:@"." intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"8.00"];
    [tester enterText:@"3" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"8.30"];
    [tester enterText:@"5" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"8.35"];
    [tester enterText:@"8" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"83.58"];
    [tester enterText:@"0" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"835.80"];
    [tester enterText:@"." intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"83580.00"];
    [tester enterText:@"\b" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"8358.00"];
    [tester enterText:@"." intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"83580.00"];
    [tester enterText:@"4" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"83580.40"];
    
    [tester enterText:@"." intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"83580.40"];
    [tester enterText:@"6" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"83580.46"];
    [tester enterText:@"2" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"83580.46"];
    [tester enterText:@"3" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"83580.46"]; // shouldn't change, hit max char limit
    [tester enterText:@"\b" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"8358.04"];
    [tester enterText:@"." intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"83580.40"];
    [tester enterText:@"1" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"83580.41"];
    [tester enterText:@"3" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"83580.41"]; // shouldn't change, hit max char limit
    [tester enterText:@"\b" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"8358.04"];
    [tester enterText:@"\b" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"835.80"];
    [tester enterText:@"." intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"83580.00"];
    [tester enterText:@"\b" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"8358.00"];
    [tester enterText:@"." intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"83580.00"];
    [tester enterText:@"9" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"83580.90"];
    
    [self tapClearButtonInTextField:atmTextField];
    [tester waitForViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel value:@"0.00" traits:UIAccessibilityTraitNone];
    
    [tester enterText:@"1" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"0.01"];
    [tester enterText:@"0" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"0.10"];
    [tester enterText:@"." intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"10.00"];
    [tester enterText:@"0" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"10.00"];
    [tester enterText:@"2" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"10.02"];
    [tester enterText:@"\b" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"1.00"];
    [tester enterText:@"." intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"100.00"];
    
    [self tapClearButtonInTextField:atmTextField];
    [tester waitForViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel value:@"0.00" traits:UIAccessibilityTraitNone];
    
    [tester enterText:@"1" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"0.01"];
    [tester enterText:@"0" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"0.10"];
    [tester enterText:@"." intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"10.00"];
    [tester enterText:@"0" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"10.00"];
    [tester enterText:@"0" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"10.00"];
    [tester enterText:@"0" intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"100.00"];
    [tester enterText:@"." intoViewWithAccessibilityLabel:atmTextFieldAccessibilityLabel traits:UIAccessibilityTraitNone expectedResult:@"10000.00"];
    
    [tester tapViewWithAccessibilityLabel:@"Done"];
//    [self delegateMethodCalled:@"textFieldShouldReturn:"];
    [tester waitForAbsenceOfSoftwareKeyboard]; // buy some time for the delegate method to be called
    [self delegateMethodCalled:@"textFieldDidEndEditing:"];
}

- (void)testClearButtonState {
    STAResizingTextField *resizingTextField = (STAResizingTextField *)[tester waitForViewWithAccessibilityLabel:@"ResizingTextField"];
    
    resizingTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    XCTAssert(!resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    XCTAssert(![self isClearButtonVisibleInTextField:resizingTextField], @"Clear button was found within UITextField.");
    [tester enterText:@"R" intoViewWithAccessibilityLabel:@"ResizingTextField"];
    XCTAssert(resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    XCTAssert([self isClearButtonVisibleInTextField:resizingTextField], @"Clear button was not found within UITextField.");
    [tester enterText:@"esizing test" intoViewWithAccessibilityLabel:@"ResizingTextField"
               traits:UIAccessibilityTraitNone
       expectedResult:@"Resizing test"];
    
    [tester tapViewWithAccessibilityLabel:@"HideKeyboard"];
    XCTAssert(!resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    XCTAssert(![self isClearButtonVisibleInTextField:resizingTextField], @"Clear button was found within UITextField.");
    
    [tester tapViewWithAccessibilityLabel:@"ResizingTextField"];
    XCTAssert(resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    XCTAssert([self isClearButtonVisibleInTextField:resizingTextField], @"Clear button was not found within UITextField.");
    
    [self tapClearButtonInTextField:resizingTextField];
    [tester waitForViewWithAccessibilityLabel:@"ResizingTextField" value:@"" traits:UIAccessibilityTraitNone];
    XCTAssert(!resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    XCTAssert([self isClearButtonVisibleInTextField:resizingTextField], @"Clear button was not found within UITextField.");
    
    resizingTextField.clearButtonMode = UITextFieldViewModeAlways;
    XCTAssert(resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    XCTAssert([self isClearButtonVisibleInTextField:resizingTextField], @"Clear button was not found within UITextField.");
    [tester enterText:@"Clear button is now always visible" intoViewWithAccessibilityLabel:@"ResizingTextField"];
    XCTAssert(resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    XCTAssert([self isClearButtonVisibleInTextField:resizingTextField], @"Clear button was not found within UITextField.");
    [tester tapViewWithAccessibilityLabel:@"HideKeyboard"];
    XCTAssert(resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    XCTAssert([self isClearButtonVisibleInTextField:resizingTextField], @"Clear button was not found within UITextField.");
    [self tapClearButtonInTextField:resizingTextField];
    [tester waitForViewWithAccessibilityLabel:@"ResizingTextField" value:@"" traits:UIAccessibilityTraitNone];
    XCTAssert(!resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    XCTAssert([self isClearButtonVisibleInTextField:resizingTextField], @"Clear button was not found within UITextField.");
    
    resizingTextField.clearButtonMode = UITextFieldViewModeNever;
    XCTAssert(!resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
//    XCTAssert(![self isClearButtonVisibleInTextField:resizingTextField], @"Clear button was found within UITextField.");
    [tester enterText:@"Clear button is now never visible" intoViewWithAccessibilityLabel:@"ResizingTextField"];
    XCTAssert(!resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    XCTAssert(![self isClearButtonVisibleInTextField:resizingTextField], @"Clear button was found within UITextField.");
    [tester tapViewWithAccessibilityLabel:@"HideKeyboard"];
    XCTAssert(!resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    XCTAssert(![self isClearButtonVisibleInTextField:resizingTextField], @"Clear button was found within UITextField.");
    [tester enterText:@"\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b"
intoViewWithAccessibilityLabel:@"ResizingTextField"
               traits:UIAccessibilityTraitNone
       expectedResult:@""];
    XCTAssert(!resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    XCTAssert(![self isClearButtonVisibleInTextField:resizingTextField], @"Clear button was found within UITextField.");
    
    resizingTextField.clearButtonMode = UITextFieldViewModeUnlessEditing;
    XCTAssert(!resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    XCTAssert(![self isClearButtonVisibleInTextField:resizingTextField], @"Clear button was found within UITextField.");
    [tester enterText:@"Clear button is now visible when not first responder" intoViewWithAccessibilityLabel:@"ResizingTextField"];
    XCTAssert(!resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    XCTAssert(![self isClearButtonVisibleInTextField:resizingTextField], @"Clear button was found within UITextField.");
    [tester tapViewWithAccessibilityLabel:@"HideKeyboard"];
    XCTAssert(resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    XCTAssert([self isClearButtonVisibleInTextField:resizingTextField], @"Clear button was not found within UITextField.");
    [self tapClearButtonInTextField:resizingTextField];
    [tester waitForViewWithAccessibilityLabel:@"ResizingTextField" value:@"" traits:UIAccessibilityTraitNone];
    XCTAssert(!resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    XCTAssert([self isClearButtonVisibleInTextField:resizingTextField], @"Clear button was found within UITextField.");
    
    [tester enterText:@"Some text" intoViewWithAccessibilityLabel:@"ResizingTextField"];
    XCTAssert(!resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    XCTAssert(![self isClearButtonVisibleInTextField:resizingTextField], @"Clear button was found within UITextField.");
    resizingTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    XCTAssert(resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
//    XCTAssert([self isClearButtonVisibleInTextField:resizingTextField], @"Clear button was not found within UITextField.");
    
    [tester tapViewWithAccessibilityLabel:@"HideKeyboard"];
    XCTAssert(!resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    XCTAssert(![self isClearButtonVisibleInTextField:resizingTextField], @"Clear button was found within UITextField.");
    resizingTextField.clearButtonMode = UITextFieldViewModeUnlessEditing;
    XCTAssert(resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
//    XCTAssert([self isClearButtonVisibleInTextField:resizingTextField], @"Clear button was not found within UITextField.");
    
    [tester tapViewWithAccessibilityLabel:@"ResizingTextField"];
    XCTAssert(!resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    XCTAssert(![self isClearButtonVisibleInTextField:resizingTextField], @"Clear button was found within UITextField.");
    resizingTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    XCTAssert(resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
//    XCTAssert([self isClearButtonVisibleInTextField:resizingTextField], @"Clear button was not found within UITextField.");
    resizingTextField.clearButtonMode = UITextFieldViewModeUnlessEditing;
    XCTAssert(!resizingTextField.clearButtonIsVisible, @"Improper clearButtonIsVisible value.");
    XCTAssert(![self isClearButtonVisibleInTextField:resizingTextField], @"Clear button was found within UITextField.");
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

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textField:(STATextFieldBase *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    NSMethodSignature *sig = [[self class] instanceMethodSignatureForSelector:_cmd];
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
    [inv setTarget:self];
    [inv setSelector:_cmd];
    [inv setArgument:&textField atIndex:2];
    [inv setArgument:&range atIndex:3];
    [inv setArgument:&string atIndex:4];
    
    self.calledDelegateInvocation = inv;
    
    return YES;
//    return [textField textField:textField shouldChangeCharactersInRange:range replacementString:string];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSMethodSignature *sig = [[self class] instanceMethodSignatureForSelector:_cmd];
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
    [inv setTarget:self];
    [inv setSelector:_cmd];
    [inv setArgument:&textField atIndex:2];
    
    self.calledDelegateInvocation = inv;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSMethodSignature *sig = [[self class] instanceMethodSignatureForSelector:_cmd];
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
    [inv setTarget:self];
    [inv setSelector:_cmd];
    [inv setArgument:&textField atIndex:2];
    
    self.calledDelegateInvocation = inv;
}

- (BOOL)textFieldShouldClear:(STATextFieldBase *)textField {
    NSMethodSignature *sig = [[self class] instanceMethodSignatureForSelector:_cmd];
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
    [inv setTarget:self];
    [inv setSelector:_cmd];
    [inv setArgument:&textField atIndex:2];
    
    self.calledDelegateInvocation = inv;
    
    return [textField textFieldShouldClear:textField];
}

- (BOOL)textFieldShouldReturn:(STATextFieldBase *)textField {
    NSMethodSignature *sig = [[self class] instanceMethodSignatureForSelector:_cmd];
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
    [inv setTarget:self];
    [inv setSelector:_cmd];
    [inv setArgument:&textField atIndex:2];
    
    self.calledDelegateInvocation = inv;
    
    return [textField textFieldShouldReturn:textField];
}

@end
