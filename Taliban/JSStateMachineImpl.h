//
//  JSStateMachine.h
//  Taliban
//
//  Created by Jonathan Sterling on 5/28/14.
//  Copyright (c) 2014 JS. All rights reserved.
//

#import "JSStateMachine.h"

/// JSStateMachine 't :
///   <JSStateMachine where
///     type t = 't
///   >
@interface JSStateMachine : NSObject <JSStateMachine>
- (id)initWithTransformations:(RACSignal *)transformations initialState:(id)initialState;
@end
