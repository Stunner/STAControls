//
//  STAButton.h
//  STAControls
//
//  Created by Aaron Jubbal on 5/18/15.
//  Copyright (c) 2015 Aaron Jubbal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STAButton : UIButton

- (void)setBackgroundColor:(UIColor *)backgroundColor
                  forState:(UIControlState)state;

/**
 @param title The title to set to the button, denote new lines with '\\n'.
 
 @param attributes An array of dictionaries containing attributes that should be applied to
 each line of text (first item in the array applies to row 1, etc.). If attributes are omitted,
 then the last line's attributes will be applied to subsquent lines.
 
 @param state The state that uses the specified title. Is fed into `addAttributes:range:`.
 */
- (void)setMultilineTitle:(NSString *)title
       withLineAttributes:(NSArray<NSDictionary *> *)attributes
                 forState:(UIControlState)state;

@end
