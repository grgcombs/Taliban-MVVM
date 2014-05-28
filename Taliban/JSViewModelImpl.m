//
//  JSViewModel.m
//  Taliban
//
//  Created by Jonathan Sterling on 5/28/14.
//  Copyright (c) 2014 JS. All rights reserved.
//

#import "JSViewModelImpl.h"
#import "JSCoordinate.h"
#import "JSViewStateImpl.h"
#import "RACSignal+JSOperators.h"
#import "JSStateMachine.h"

#import <ReactiveCocoa/RACDynamicSignalGenerator.h>
#import <ReactiveCocoa/RACSignal+Operations.h>
#import <ReactiveCocoa/RACAction.h>
#import <ReactiveCocoa/RACSubject.h>
#import <ReactiveCocoa/RACScheduler.h>

@interface JSViewModel ()
/// stateMachine : JSStateMachine <JSViewState>
@property (readonly) JSStateMachine *stateMachine;
@end

@implementation JSViewModel
@synthesize playCoordinateAction = _playCoordinateAction;
@synthesize victoriesSignal = _victoriesSignal;

- (id)init {
    if (self = [super init]) {
        _playCoordinateAction = [RACDynamicSignalGenerator generatorWithBlock:^RACSignal *(JSCoordinate *input) {
            return [input.validatedCoordinate map:^id(JSCoordinate *validatedInput) {
                return ^(JSViewState *state) {
                    return [state stateFillingCoordinate:validatedInput byPlayer:JSPlayerHuman];
                };
            }];
        }].action;

        _stateMachine = [[JSStateMachine alloc] initWithTransformations:self.playCoordinateAction.results initialState:[JSViewState emptyState]];

        _victoriesSignal = [[self.stateMachine.statesSignal filter:^BOOL(id<JSViewState> state) {
            return state.gameOver;
        }] map:^(id<JSViewState> state) {
            return @(state.winner);
        }];
    }

    return self;
}

- (RACSignal *)statesSignal {
    return self.stateMachine.statesSignal;
}

- (RACSignal *)transitionErrorsSignal {
    return self.stateMachine.statesSignal;
}

@end

