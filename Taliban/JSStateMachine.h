//
//  JSStateMachine.h
//  Taliban
//
//  Created by Jonathan Sterling on 5/29/14.
//  Copyright (c) 2014 JS. All rights reserved.
//

@import Foundation.NSObject;
@class RACSignal;

@protocol JSStateMachine <NSObject>
// type t

/// statesSignal : RACSignal t
- (RACSignal *)statesSignal;

/// transitionErrorsSignal : RACSignal NSError
- (RACSignal *)transitionErrorsSignal;
@end

