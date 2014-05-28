//
//  JSViewModel.h
//  Taliban
//
//  Created by Jonathan Sterling on 5/28/14.
//  Copyright (c) 2014 JS. All rights reserved.
//

@import Foundation.NSObject;

@class RACAction, RACSignal;
@class JSStateMachine, JSCoordinate;
@protocol JSViewState;

@interface JSViewModel : NSObject

/// playCoordinateAction : RACAction <JSCoordinate> _
@property (readonly) RACAction *playCoordinateAction;

/// stateMachine : JSStateMachine <JSViewState>
@property (readonly) JSStateMachine *stateMachine;

/// victoriesSignal : RACSignal RACPlayer
@property (readonly) RACSignal *victoriesSignal;

@end
