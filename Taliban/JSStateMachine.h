//
//  JSStateMachine.h
//  Taliban
//
//  Created by Jonathan Sterling on 5/28/14.
//  Copyright (c) 2014 JS. All rights reserved.
//

@import Foundation.NSObject;

@class RACSignal;

@interface JSStateMachine : NSObject
@property (readonly) RACSignal *statesSignal;
@property (readonly) RACSignal *transitionErrorsSignal;

- (id)initWithTransformations:(RACSignal *)transformations initialState:(id)initialState;
@end
