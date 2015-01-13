//
//  STAResizingTextField.m
//  STATextField
//
//  Created by Aaron Jubbal on 10/18/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "STAResizingTextField.h"
#import "STATextField+PrivateHeaders.h"

#define kDynamicResizeThresholdOffset 4

#define kDefaultClearTextButtonOffset 28
#define kDynamicResizeClearTextButtonOffset 0
#define kDynamicResizeClearTextButtonOffsetSelection 31
#define kFixedDecimalClearTextButtonOffset 29
#define kTextFieldSidesBuffer 19

@interface STAResizingTextField () {
    CGFloat _initialTextFieldWidth;
}

@end

@implementation STAResizingTextField

- (void)initInternal {
    [super initInternal];
    
    _initialTextFieldWidth = self.frame.size.width;
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    
//    return YES;
//}

- (BOOL)staTextField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
   replacementString:(NSString *)string
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [self resizeSelfForClearButton:textField.text];
    
    return YES;
}

- (void)resizeSelfToWidth:(NSInteger)width {
#ifdef LOGGING_ENABLED
    LogTrace(@"%s", __PRETTY_FUNCTION__);
#endif
    
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
}

- (void)resizeSelfToWidthWithoutShrinking:(CGFloat)width {
#ifdef LOGGING_ENABLED
    LogTrace(@"%s", __PRETTY_FUNCTION__);
#endif
    
    if (width < _initialTextFieldWidth) {
        width = _initialTextFieldWidth;
    }
    NSLog(@"resize to: %f", width);
    [self resizeSelfToWidth:width];
}

- (void)resizeSelfToText:(NSString *)text {
#ifdef LOGGING_ENABLED
    LogTrace(@"%s", __PRETTY_FUNCTION__);
#endif
    
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
#ifdef LOGGING_ENABLED
    LogTrace(@"%s", __PRETTY_FUNCTION__);
#endif
    
    if (text.length > 0 && self.isEditing) {
        [self resizeSelfToWidthWithoutShrinking:_initialTextFieldWidth + kDefaultClearTextButtonOffset];
    } else {
        [self resizeSelfToWidthWithoutShrinking:_initialTextFieldWidth];
    }
}

@end
