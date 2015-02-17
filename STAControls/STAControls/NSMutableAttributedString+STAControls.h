//
//  NSMutableAttributedString+STAControls.h
//  STAControls
//
//  Created by Aaron Jubbal on 2/2/15.
//  Copyright (c) 2015 Aaron Jubbal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (STAControls)

- (void)removeAttributesInDictionary:(NSDictionary *)attributeDictionary
                            forRange:(NSRange)range;

@end
