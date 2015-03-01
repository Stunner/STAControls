//
//  UITextView+STAControls.m
//  STAControls
//
//  Created by Aaron Jubbal on 2/28/15.
//  Copyright (c) 2015 Aaron Jubbal. All rights reserved.
//

#import "UITextView+STAControls.h"

@implementation UITextView (STAControls)

- (NSRange)selectedTextRangeToRange {
    UITextPosition *beginning = self.beginningOfDocument;
    
    UITextRange *selectedRange = self.selectedTextRange;
    UITextPosition *selectionStart = selectedRange.start;
    UITextPosition *selectionEnd = selectedRange.end;
    
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

@end
