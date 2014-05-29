//
//  JSTile.m
//  Taliban
//
//  Created by Jonathan Sterling on 5/28/14.
//  Copyright (c) 2014 JS. All rights reserved.
//

#import "JSTile.h"
#import <ReactiveCocoa/RACSignal+Operations.h>

NSString *const JSTileErrorDomain = @"JSTileErrorDomain";

@implementation JSTile

- (id)initWithRow:(NSUInteger)horizontal column:(NSUInteger)vertical {
    if (self = [super init]) {
        _row = horizontal;
        _column = vertical;
    }

    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

+ (instancetype)row:(NSUInteger)x column:(NSUInteger)y {
    return [[self alloc] initWithRow:x column:y];
}

- (RACSignal *)validatedTile {
    return [RACSignal defer:^RACSignal *{
        if (self.row > 2 || self.row > 2)
            return [RACSignal error:[NSError errorWithDomain:JSTileErrorDomain code:0 userInfo:nil]];

        return [RACSignal return:self];
    }];
}

- (BOOL)isEqual:(JSTile *)object {
    if (![object isKindOfClass:[JSTile class]]) {
        return NO;
    }

    return self.row == object.row && self.column == object.column;
}

- (NSUInteger)hash {
    return self.row ^ self.column;
}

@end
