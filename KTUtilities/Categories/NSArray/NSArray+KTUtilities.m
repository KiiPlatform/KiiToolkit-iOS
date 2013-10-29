//
//  NSArray+KTUtilities.m
//  Kii@AppsWorld
//
//  Created by Chris on 10/18/13.
//  Copyright (c) 2013 Kii Corporation. All rights reserved.
//

#import "NSArray+KTUtilities.h"

@implementation NSArray (KTUtilities)

- (NSArray *)reversedArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}


@end
