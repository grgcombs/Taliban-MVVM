//
//  JSViewStateImpl.h
//  Taliban
//
//  Created by Jonathan Sterling on 5/28/14.
//  Copyright (c) 2014 JS. All rights reserved.
//

#import "JSViewState.h"

@class RACSignal;
@interface JSViewState : NSObject <JSViewState>
+ (instancetype)emptyState;
- (RACSignal *)stateFillingCoordinate:(JSCoordinate *)coordinate byPlayer:(JSPlayer)player;
@end

