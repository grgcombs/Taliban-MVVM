//
//  JSCoordinate.m
//  Taliban
//
//  Created by Jonathan Sterling on 5/28/14.
//  Copyright (c) 2014 JS. All rights reserved.
//

#import "JSCoordinate.h"
#import <ReactiveCocoa/RACSignal+Operations.h>

NSString *const JSCoordinateErrorDomain = @"JSCoordinateErrorDomain";

@implementation JSCoordinate

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

- (RACSignal *)validatedCoordinate {
    return [RACSignal defer:^RACSignal *{
        if (self.row > 2 || self.row > 2)
            return [RACSignal error:[NSError errorWithDomain:JSCoordinateErrorDomain code:0 userInfo:nil]];

        return [RACSignal return:self];
    }];
}

- (BOOL)isEqual:(JSCoordinate *)object {
    if (![object isKindOfClass:[JSCoordinate class]]) {
        return NO;
    }

    return self.row == object.row && self.column == object.column;
}

- (NSUInteger)hash {
    return self.row ^ self.column;
}

@end
