//
//  RACSignal+JSOperators.h
//  Taliban
//
//  Created by Jonathan Sterling on 5/28/14.
//  Copyright (c) 2014 JS. All rights reserved.
//

#import <ReactiveCocoa/RACSignal.h>

@interface RACSignal (JSOperators)
- (instancetype)js_scanWithStart:(id)startingValue flattenReduce:(RACSignal *(^)(id running, id next))block;

/// self : instancetype 'a
/// block : ('a, 'b) -> 'c
/// -> instancetype ('b -> 'c)
- (instancetype)js_mapCurried:(id (^)(id x, id y))block;
@end
