//
//  JSTicTacToeViewModelImpl.m
//  Taliban
//
//  Created by Jonathan Sterling on 5/28/14.
//  Copyright (c) 2014 JS. All rights reserved.
//

#import "JSTicTacToeViewModelImpl.h"
#import "JSTile.h"
#import "JSTicTacToeStateImpl.h"
#import "RACSignal+JSOperators.h"
#import "JSStateMachineImpl.h"

#import <ReactiveCocoa/RACDynamicSignalGenerator.h>
#import <ReactiveCocoa/RACSignal+Operations.h>
#import <ReactiveCocoa/RACAction.h>
#import <ReactiveCocoa/RACSubject.h>
#import <ReactiveCocoa/RACScheduler.h>

@interface JSTicTacToeViewModel ()
/// stateMachine : JSStateMachine <JSTicTacToeState>
@property (readonly) JSStateMachine *stateMachine;
@end

@implementation JSTicTacToeViewModel
@synthesize playTileAction = _playTileAction;
@synthesize victoriesSignal = _victoriesSignal;

- (id)init {
    if (self = [super init]) {
        _playTileAction = [RACDynamicSignalGenerator generatorWithBlock:^RACSignal *(JSTile *input) {
            return [input.validatedTile js_mapCurried:^(JSTile *validatedInput, JSTicTacToeState *state) {
                return [state stateFillingTile:validatedInput byPlayer:JSPlayerHuman];
            }];
        }].action;

        _stateMachine = [[JSStateMachine alloc] initWithTransformations:self.playTileAction.results initialState:[JSTicTacToeState emptyState]];

        _victoriesSignal = [[self.stateMachine.statesSignal filter:^BOOL(id<JSTicTacToeState> state) {
            return state.gameOver;
        }] map:^(id<JSTicTacToeState> state) {
            return @(state.winner);
        }];
    }

    return self;
}

- (RACSignal *)statesSignal {
    return self.stateMachine.statesSignal;
}

- (RACSignal *)transitionErrorsSignal {
    return self.stateMachine.transitionErrorsSignal;
}

@end

