//
//  STAExpressionTextView.m
//  STATextField
//
//  Created by Aaron Jubbal on 12/24/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "STAExpressionTextView.h"
#import "STATextView+PrivateHeaders.h"

@implementation STAExpressionTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSString *oldText = self.text;
    NSString *newText = [self.text stringByReplacingCharactersInRange:range withString:text];
    
    NSCharacterSet *expressionCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789.+-*/()"];
    if (text.length > 0 && [expressionCharacterSet characterIsMember:[text characterAtIndex:0]]) {
        [super resizeSelfForText:newText];
        return YES;
    } else if (text.length == 0) { // deletion case
        [super resizeSelfForText:newText];
        return YES;
    }
    
//    if ([text isEqualToString:@"("]) {
//        self.text = [newText stringByAppendingString:@")"];
//    }
    
    return NO;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"selected range: %@", NSStringFromRange(self.selectedRange));
    
    
}

@end
