//
//  NSMutableAttributedString+STAUtils.h
//  STAUtils
//
//  Created by Aaron Jubbal on 2/19/15.
//  Copyright (c) 2015 Aaron Jubbal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (STAUtils)


- (void)removeFirstOccuranceOfSubstring:(NSString *)substring
                         beyondLocation:(NSUInteger)location;

@end
