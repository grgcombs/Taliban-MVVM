//
//  JSViewStateImpl.m
//  Taliban
//
//  Created by Jonathan Sterling on 5/28/14.
//  Copyright (c) 2014 JS. All rights reserved.
//

#import "JSViewStateImpl.h"
#import "JSCoordinate.h"

#import <ReactiveCocoa/RACSignal+Operations.h>
#import <ReactiveCocoa/NSArray+RACSupport.h>

@import Foundation.NSException;
@import Foundation.NSDictionary;

@interface JSViewState ()
@property (copy, readonly) NSDictionary *coordinateMap;
@property (readonly) JSPlayer currentTurn;
@end

@implementation JSViewState

- (id)initWithCoordinateMap:(NSDictionary *)coordinateMap turn:(JSPlayer)currentTurn {
    if (self = [super init]) {
        _coordinateMap = [coordinateMap copy];
        _currentTurn = currentTurn;
    }

    return self;
}

#pragma mark -

+ (instancetype)emptyState {
    return [[self alloc] initWithCoordinateMap:@{} turn:JSPlayerHuman];
}

- (RACSignal *)stateFillingCoordinate:(JSCoordinate *)coordinate byPlayer:(JSPlayer)player {
    NSCParameterAssert(player != JSPlayerNone);

    return [[RACSignal defer:^RACSignal *{
        if ([self playerAtCoordinate:coordinate] != JSPlayerNone || self.currentTurn != player)
            return [RACSignal error:[NSError errorWithDomain:JSViewStateErrorDomain code:JSViewStateErrorCodeInvalidPlay userInfo:nil]];

        NSMutableDictionary *coordinateMap = [self.coordinateMap mutableCopy];
        coordinateMap[coordinate] = @(player);

        NSMutableArray *states = [NSMutableArray array];
        JSViewState *nextState = [[JSViewState alloc] initWithCoordinateMap:coordinateMap turn:JSPlayerNextTurn(player)];
        [states addObject:nextState];

        if (player == JSPlayerHuman && !nextState.gameOver) {
            [states addObject:[nextState playRandomTile]];
        }

        return states.rac_signal;
    }] map:^(JSViewState *state) {
        if (state.gameOver)
            return [[RACSignal return:[self.class emptyState]] startWith:state];
        return [RACSignal return:state];
    }].switchToLatest;
}

- (instancetype)playRandomTile {
    NSMutableDictionary *coordinateMap = [self.coordinateMap mutableCopy];
    JSCoordinate *tileToPlay = [self randomUnoccupiedTile];
    if (tileToPlay != nil) {
        coordinateMap[tileToPlay] = @(JSPlayerComputer);
    }

    return [[JSViewState alloc] initWithCoordinateMap:coordinateMap turn:JSPlayerHuman];
}

- (JSCoordinate *)randomUnoccupiedTile {
    for (int x = 0; x < 3; x++) {
        for (int y = 0; y < 3; y++) {
            JSCoordinate *tile = [JSCoordinate row:x column:y];
            if ([self.coordinateMap[tile] integerValue] == JSPlayerNone)
                return tile;
        }
    }

    return nil;
}

- (JSPlayer)playerAtCoordinate:(JSCoordinate *)coordinate {
    NSCParameterAssert(coordinate);
    NSNumber *player = self.coordinateMap[coordinate];
    return player.integerValue;
}

- (JSPlayer)playerOccupyingRow:(NSInteger)row {
    JSPlayer player = [self playerAtCoordinate:[JSCoordinate row:row column:0]];
    for (NSInteger y = 1; y < 3; y++) {
        if ([self playerAtCoordinate:[JSCoordinate row:row column:y]] != player)
            return JSPlayerNone;
    }

    return player;
}

- (JSPlayer)playerOccupyingColumn:(NSInteger)column {
    JSPlayer player = [self playerAtCoordinate:[JSCoordinate row:0 column:column]];
    for (NSInteger x = 1; x < 3; x++) {
        if ([self playerAtCoordinate:[JSCoordinate row:x column:column]] != player)
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

    JSPlayer centerPlayer = [self playerAtCoordinate:[JSCoordinate row:1 column:1]];
    JSPlayer topLeftPlayer = [self playerAtCoordinate:[JSCoordinate row:0 column:0]];
    JSPlayer bottomRightPlayer = [self playerAtCoordinate:[JSCoordinate row:2 column:2]];
    if (centerPlayer == topLeftPlayer && centerPlayer == bottomRightPlayer)
        return centerPlayer;

    JSPlayer bottomLeftPlayer = [self playerAtCoordinate:[JSCoordinate row:0 column:2]];
    JSPlayer topRightPlayer = [self playerAtCoordinate:[JSCoordinate row:2 column:0]];
    if (centerPlayer == bottomLeftPlayer && centerPlayer == topRightPlayer)
        return centerPlayer;

    return JSPlayerNone;
}

- (BOOL)gameOver {
    if (self.winner != JSPlayerNone)
        return YES;

    return [self.coordinateMap.allValues.rac_signal filter:^BOOL(NSNumber *player) {
        return player.integerValue != JSPlayerNone;
    }].array.count == (3 * 3);
}

@end