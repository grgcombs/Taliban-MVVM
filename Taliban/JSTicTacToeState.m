//
//  JSTicTacToeState.m
//  Taliban
//
//  Created by Jonathan Sterling on 5/28/14.
//  Copyright (c) 2014 JS. All rights reserved.
//

#import "JSTicTacToeState.h"

NSString *const JSTicTacToeStateErrorDomain = @"JSTicTacToeStateErrorDomain";

JSPlayer JSPlayerNextTurn(JSPlayer currentTurn) {
    switch (currentTurn) {
        case JSPlayerHuman:
            return JSPlayerComputer;
        default:
            return JSPlayerHuman;
    }
}