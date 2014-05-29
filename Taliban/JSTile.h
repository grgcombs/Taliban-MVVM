//
//  JSTile.h
//  Taliban
//
//  Created by Jonathan Sterling on 5/28/14.
//  Copyright (c) 2014 JS. All rights reserved.
//

@import Foundation.NSObject;

@class RACSignal;

@interface JSTile : NSObject <NSCopying>
@property (readonly) NSUInteger row;
@property (readonly) NSUInteger column;

- (id)initWithRow:(NSUInteger)horizontal column:(NSUInteger)vertical;
+ (instancetype)row:(NSUInteger)x column:(NSUInteger)y;

- (RACSignal *)validatedTile;
@end

extern NSString *const JSTileErrorDomain;

