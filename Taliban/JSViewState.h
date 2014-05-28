//
//  JSViewState.h
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

@class JSCoordinate;

@protocol JSViewState <NSObject>
- (JSPlayer)currentTurn;
- (JSPlayer)winner;
- (BOOL)gameOver;
- (JSPlayer)playerAtCoordinate:(JSCoordinate *)coordinate;
@end

extern NSString *const JSViewStateErrorDomain;
typedef NS_ENUM(NSInteger, JSViewStateErrorCode) {
    JSViewStateErrorCodeInvalidPlay
};

extern JSPlayer JSPlayerNextTurn(JSPlayer currentTurn);