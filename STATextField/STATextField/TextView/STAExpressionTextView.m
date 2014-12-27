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
    [super textView:textView shouldChangeTextInRange:range replacementText:text];
    
    return YES;
}

@end
