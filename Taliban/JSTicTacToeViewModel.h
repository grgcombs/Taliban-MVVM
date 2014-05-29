//
//  JSTicTacToeViewModel.h
//  Taliban
//
//  Created by Jonathan Sterling on 5/28/14.
//  Copyright (c) 2014 JS. All rights reserved.
//

#import "JSStateMachine.h"

@class RACAction, RACSignal;

@protocol JSTicTacToeViewModel <JSStateMachine>
// include JSStateMachine where type state = <JSTicTacToeState>

/// playTileAction : RACAction JSTile _
@property (readonly) RACAction *playTileAction;

/// victoriesSignal : RACSignal RACPlayer
@property (readonly) RACSignal *victoriesSignal;

@end
