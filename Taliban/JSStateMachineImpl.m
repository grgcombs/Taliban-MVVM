//
//  JSStateMachine.m
//  Taliban
//
//  Created by Jonathan Sterling on 5/28/14.
//  Copyright (c) 2014 JS. All rights reserved.
//

#import "JSStateMachineImpl.h"

#import <ReactiveCocoa/RACSubject.h>
#import <ReactiveCocoa/RACScheduler.h>
#import <ReactiveCocoa/RACSignal+Operations.h>
#import "RACSignal+JSOperators.h"

@interface JSStateMachine ()
@property (readonly) RACSignal *statesSignal;
@property (readonly) RACSignal *transitionErrorsSignal;
@end

@implementation JSStateMachine

- (id)initWithTransformations:(RACSignal *)transformations initialState:(id)initialState {
    if (self = [super init]) {
        RACSignal *(^identityTransform)(id) = ^(id value) {
            return [RACSignal return:value];
        };

        RACSignal *transforms = [[transformations startWith:identityTransform] ignore:nil];

        RACSubject *transitionErrorSubject = [RACSubject subject];
        _transitionErrorsSignal = [transitionErrorSubject deliverOn:[RACScheduler mainThreadScheduler]];

        RACSubject *statesSubject = [RACSubject subject];
        [[transforms js_scanWithStart:initialState flattenReduce:^RACSignal *(id state, id (^transformer)(id)) {
            return [transformer(state) catch:^RACSignal *(NSError *error) {
                [transitionErrorSubject sendNext:error];
                return [RACSignal return:state];
            }];
        }] subscribe:statesSubject];

        _statesSignal = [statesSubject deliverOn:[RACScheduler mainThreadScheduler]];
    }
    
    return self;
}

@end
