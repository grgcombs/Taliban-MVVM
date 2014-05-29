//
//  JSTicTacToeState.m
//  Taliban
//
//  Created by Jonathan Sterling on 5/28/14.
//  Copyright (c) 2014 JS. All rights reserved.
//

#import "JSTicTacToeStateImpl.h"
#import "JSTile.h"

#import <ReactiveCocoa/RACSignal+Operations.h>
#import <ReactiveCocoa/NSArray+RACSupport.h>

@import Foundation.NSException;
@import Foundation.NSDictionary;

@interface JSTicTacToeState ()
@property (copy, readonly) NSDictionary *tileMap;
@property (readonly) JSPlayer currentTurn;
@end

@implementation JSTicTacToeState

- (id)initWithTileMap:(NSDictionary *)tileMap turn:(JSPlayer)currentTurn {
    if (self = [super init]) {
        _tileMap = [tileMap copy];
        _currentTurn = currentTurn;
    }

    return self;
}

#pragma mark -

+ (instancetype)emptyState {
    return [[self alloc] initWithTileMap:@{} turn:JSPlayerHuman];
}

- (RACSignal *)stateFillingTile:(JSTile *)tile byPlayer:(JSPlayer)player {
    NSCParameterAssert(player != JSPlayerNone);

    return [[RACSignal defer:^RACSignal *{
        if ([self playerAtTile:tile] != JSPlayerNone || self.currentTurn != player)
            return [RACSignal error:[NSError errorWithDomain:JSTicTacToeStateErrorDomain code:JSTicTacToeStateErrorCodeInvalidPlay userInfo:nil]];

        NSMutableDictionary *tileMap = [self.tileMap mutableCopy];
        tileMap[tile] = @(player);

        NSMutableArray *states = [NSMutableArray array];
        JSTicTacToeState *nextState = [[JSTicTacToeState alloc] initWithTileMap:tileMap turn:JSPlayerNextTurn(player)];
        [states addObject:nextState];

        if (player == JSPlayerHuman && !nextState.gameOver) {
            [states addObject:[nextState playRandomTile]];
        }

        return states.rac_signal;
    }] map:^(JSTicTacToeState *state) {
        if (state.gameOver)
            return [[RACSignal return:[self.class emptyState]] startWith:state];
        return [RACSignal return:state];
    }].switchToLatest;
}

- (instancetype)playRandomTile {
    NSMutableDictionary *tileMap = [self.tileMap mutableCopy];
    JSTile *tileToPlay = [self randomUnoccupiedTile];
    if (tileToPlay != nil) {
        tileMap[tileToPlay] = @(JSPlayerComputer);
    }

    return [[JSTicTacToeState alloc] initWithTileMap:tileMap turn:JSPlayerHuman];
}

- (JSTile *)randomUnoccupiedTile {
    for (int x = 0; x < 3; x++) {
        for (int y = 0; y < 3; y++) {
            JSTile *tile = [JSTile row:x column:y];
            if ([self.tileMap[tile] integerValue] == JSPlayerNone)
                return tile;
        }
    }

    return nil;
}

- (JSPlayer)playerAtTile:(JSTile *)tile {
    NSCParameterAssert(tile);
    NSNumber *player = self.tileMap[tile];
    return player.integerValue;
}

- (JSPlayer)playerOccupyingRow:(NSInteger)row {
    JSPlayer player = [self playerAtTile:[JSTile row:row column:0]];
    for (NSInteger y = 1; y < 3; y++) {
        if ([self playerAtTile:[JSTile row:row column:y]] != player)
            return JSPlayerNone;
    }

    return player;
}

- (JSPlayer)playerOccupyingColumn:(NSInteger)column {
    JSPlayer player = [self playerAtTile:[JSTile row:0 column:column]];
    for (NSInteger x = 1; x < 3; x++) {
        if ([self playerAtTile:[JSTile row:x column:column]] != player)
            return JSPlayerNone;
    }

    return player;
}

- (JSPlayer)winner {
    for (NSInteger x = 0; x < 3; x++) {
        JSPlayer winnerOfRow = [self playerOccupyingRow:x];
        if (winnerOfRow != JSPlayerNone)
            return winnerOfRow;
        JSPlayer winnerOfColumn = [self playerOccupyingColumn:x];
        if (winnerOfColumn != JSPlayerNone)
            return winnerOfColumn;
    }

    JSPlayer centerPlayer = [self playerAtTile:[JSTile row:1 column:1]];
    JSPlayer topLeftPlayer = [self playerAtTile:[JSTile row:0 column:0]];
    JSPlayer bottomRightPlayer = [self playerAtTile:[JSTile row:2 column:2]];
    if (centerPlayer == topLeftPlayer && centerPlayer == bottomRightPlayer)
        return centerPlayer;

    JSPlayer bottomLeftPlayer = [self playerAtTile:[JSTile row:0 column:2]];
    JSPlayer topRightPlayer = [self playerAtTile:[JSTile row:2 column:0]];
    if (centerPlayer == bottomLeftPlayer && centerPlayer == topRightPlayer)
        return centerPlayer;

    return JSPlayerNone;
}

- (BOOL)gameOver {
    if (self.winner != JSPlayerNone)
        return YES;

    return [self.tileMap.allValues.rac_signal filter:^BOOL(NSNumber *player) {
        return player.integerValue != JSPlayerNone;
    }].array.count == (3 * 3);
}

@end