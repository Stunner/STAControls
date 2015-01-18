//
//  STAResizingTextField.m
//  STATextField
//
//  Created by Aaron Jubbal on 10/18/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "STAResizingTextField.h"
#import "STATextFieldBase+ProvideHeaders.h"
#define kDynamicResizeThresholdOffset 4

#define kDefaultClearTextButtonOffset 28
#define kDynamicResizeClearTextButtonOffset 0
#define kDynamicResizeClearTextButtonOffsetSelection 31
#define kFixedDecimalClearTextButtonOffset 29
#define kTextFieldSidesBuffer 19

@interface STAResizingTextField () {
    CGFloat _initialTextFieldWidth;
}

@property (nonatomic, assign) BOOL clearButtonIsVisible;

@end

@implementation STAResizingTextField

- (void)initInternal {
    [super initInternal];
    
    _resizesForClearTextButton = NO;
    _resignsFirstResponderUponReturnKeyPress = YES;
    _initialTextFieldWidth = self.frame.size.width;
}

- (void)setNextFirstResponderUponReturnKeyPress:(UIControl *)nextFirstResponderUponReturnKeyPress {
    self.resignsFirstResponderUponReturnKeyPress = YES;
    _nextFirstResponderUponReturnKeyPress = nextFirstResponderUponReturnKeyPress;
}

#pragma mark Helpers

- (BOOL)resignFirstResponderUponReturnKeyPress {
    BOOL resignedFirstResponderStatus = NO;
    if (self.resignsFirstResponderUponReturnKeyPress) {
        if (self.nextFirstResponderUponReturnKeyPress) {
            resignedFirstResponderStatus = [self resignFirstResponder];
            [self.nextFirstResponderUponReturnKeyPress becomeFirstResponder];
        } else {
            resignedFirstResponderStatus =[self resignFirstResponder];
        }
    }
    return resignedFirstResponderStatus;
}

- (BOOL)becomeFirstResponder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [super becomeFirstResponder];
    
    if (self.clearButtonMode == UITextFieldViewModeWhileEditing) {
        self.clearButtonIsVisible = (self.text.length > 0);
    }
    NSLog(@"clear button visible: %d", self.clearButtonIsVisible);
    
    if (self.resizesForClearTextButton) {
        [self resizeSelfForClearButton:self.text];
    }
    return YES;
}

- (BOOL)resignFirstResponder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [super resignFirstResponder];
    
    if (self.clearButtonMode == UITextFieldViewModeWhileEditing) {
        self.clearButtonIsVisible = NO;
    }
    NSLog(@"clear button visible: %d", self.clearButtonIsVisible);
    
    [self resizeSelfToWidthWithoutShrinking:_initialTextFieldWidth];
    return YES;
}

- (void)textFieldDidChange:(STATextFieldBase *)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (self.clearButtonMode == UITextFieldViewModeWhileEditing) {
        self.clearButtonIsVisible = (sender.text.length > 0);
    }
    NSLog(@"clear button visible: %d", self.clearButtonIsVisible);
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
   replacementString:(NSString *)string
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (self.resizesForClearTextButton) {
        NSString *newText = [self.text stringByReplacingCharactersInRange:range
                                                               withString:string];
        [self resizeSelfForClearButton:newText];
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [self resizeSelfToWidthWithoutShrinking:_initialTextFieldWidth];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([self resignFirstResponderUponReturnKeyPress]) {
        [self resizeSelfToWidthWithoutShrinking:_initialTextFieldWidth];
    }
    return YES;
}

- (void)resizeSelfToWidth:(NSInteger)width {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (width == self.frame.size.width) {
            return;
        }
        
        CGRect selfFrame = self.frame;
        //                         CGRect textFieldFrame = _textField.frame;
        NSInteger changeInLength = width - self.frame.size.width;
        //                         textFieldFrame.size.width = width;
        selfFrame.origin.x -= changeInLength;
        selfFrame.size.width = width;
        //                         _textField.frame = textFieldFrame;
        [UIView animateWithDuration:0.15
                              delay:0.0
                            options:(UIViewAnimationOptions)UIViewAnimationCurveEaseOut
                         animations:^{
                             
                             self.frame = selfFrame;
                         }
                         completion:^(BOOL finished){
                             if (finished) {
                                 self.frame = selfFrame;
                             }
                         }];
    });
}

- (void)resizeSelfToWidthWithoutShrinking:(CGFloat)width {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (width < _initialTextFieldWidth) {
        width = _initialTextFieldWidth;
    }
    NSLog(@"resize to: %f", width);
    [self resizeSelfToWidth:width];
}

- (void)resizeSelfToText:(NSString *)text {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    CGFloat textWidth = [text sizeWithFont:self.font].width;
    if (self.clearButtonMode == UITextFieldViewModeNever) {
        [self resizeSelfToWidthWithoutShrinking:textWidth + kTextFieldSidesBuffer];
    } else if (self.clearButtonMode == UITextFieldViewModeWhileEditing) {
        if (text.length > 0 && self.isEditing) {
            [self resizeSelfToWidthWithoutShrinking:textWidth + kTextFieldSidesBuffer + kDefaultClearTextButtonOffset];
        } else {
            [self resizeSelfToWidthWithoutShrinking:textWidth + kTextFieldSidesBuffer];
        }
    }
}

- (void)resizeSelfForClearButton:(NSString *)text {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (text.length > 0 && self.isEditing) {
        [self resizeSelfToWidthWithoutShrinking:_initialTextFieldWidth + kDefaultClearTextButtonOffset];
    } else {
        [self resizeSelfToWidthWithoutShrinking:_initialTextFieldWidth];
    }
}

@end
