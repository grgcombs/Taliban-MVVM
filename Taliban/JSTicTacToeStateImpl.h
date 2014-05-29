//
//  JSTicTacToeState.h
//  Taliban
//
//  Created by Jonathan Sterling on 5/28/14.
//  Copyright (c) 2014 JS. All rights reserved.
//

#import "JSTicTacToeState.h"

@class RACSignal;
@interface JSTicTacToeState : NSObject <JSTicTacToeState>
+ (instancetype)emptyState;

/// -> RACSignal instancetype
- (RACSignal *)stateFillingTile:(JSTile *)tile byPlayer:(JSPlayer)player;
@end

