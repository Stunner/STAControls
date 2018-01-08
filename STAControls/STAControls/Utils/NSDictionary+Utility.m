//
//  NSDictionary+Utility.m
//  TuneDeduplicater
//
//  Created by Aaron Jubbal on 4/22/16.
//  Copyright © 2016 Aaron Jubbal. All rights reserved.
//

#import "NSDictionary+Utility.h"

@implementation NSDictionary (Utility)

- (id)objectForKeyNotNull:(id)key {
    
    id object = [self objectForKey:key];
    if (object == [NSNull null])
        return nil;
    
    return object;
}

- (BOOL)containsKey:(id)key {
    
    return (BOOL)[self objectForKey:key];
}


@end
