//
//  JSTicTacToeState.h
//  Taliban
//
//  Created by Jonathan Sterling on 5/28/14.
//  Copyright (c) 2014 JS. All rights reserved.
//

@import Foundation.NSObject;

typedef NS_ENUM(NSInteger, JSPlayer) {
    JSPlayerNone = 0,
    JSPlayerHuman,
    JSPlayerComputer
};

@class JSTile;

@protocol JSTicTacToeState <NSObject>
- (JSPlayer)currentTurn;
- (JSPlayer)winner;
- (BOOL)gameOver;
- (JSPlayer)playerAtTile:(JSTile *)tile;
@end

extern NSString *const JSTicTacToeStateErrorDomain;
typedef NS_ENUM(NSInteger, JSTicTacToeStateErrorCode) {
    JSTicTacToeStateErrorCodeInvalidPlay
};

extern JSPlayer JSPlayerNextTurn(JSPlayer currentTurn);