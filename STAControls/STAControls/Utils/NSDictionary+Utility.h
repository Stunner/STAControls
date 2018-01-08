//
//  NSDictionary+Utility.h
//  TuneDeduplicater
//
//  Created by Aaron Jubbal on 4/22/16.
//  Copyright © 2016 Aaron Jubbal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Utility)

// Returns nil instead of [NSNull null].
- (id)objectForKeyNotNull:(id)key;

// Returnes BOOL value denoting if key is present.
- (BOOL)containsKey:(id)key;

@end
