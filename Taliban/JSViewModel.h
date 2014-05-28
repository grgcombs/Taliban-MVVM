//
//  JSViewModel.h
//  Taliban
//
//  Created by Jonathan Sterling on 5/28/14.
//  Copyright (c) 2014 JS. All rights reserved.
//

#import "JSStateMachine.h"

@class RACAction, RACSignal;

@protocol JSViewModel <JSStateMachine>
/// playCoordinateAction : RACAction <JSCoordinate> _
@property (readonly) RACAction *playCoordinateAction;

/// victoriesSignal : RACSignal RACPlayer
@property (readonly) RACSignal *victoriesSignal;
@end
