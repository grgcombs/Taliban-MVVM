//
//  RACSignal+JSOperators.m
//  Taliban
//
//  Created by Jonathan Sterling on 5/28/14.
//  Copyright (c) 2014 JS. All rights reserved.
//

#import "RACSignal+JSOperators.h"

@implementation RACSignal (JSOperators)

- (instancetype)js_scanWithStart:(id)startingValue flattenReduce:(RACSignal *(^)(id running, id next))block {
    NSCParameterAssert(block != nil);

    return [self bind:^{
        __block id running = startingValue;

        return ^(id value, BOOL *stop) {
            return [block(running, value) map:^(id innerValue) {
                running = innerValue;
                return innerValue;
            }];
        };
    }];
}

- (instancetype)js_mapCurried:(id (^)(id, id))block {
    NSCParameterAssert(block != nil);

    return [self map:^id(id x) {
        return ^(id y) {
            return block(x, y);
        };
    }];
}

@end
