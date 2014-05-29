//
//  JSViewController.m
//  Taliban
//
//  Created by Jonathan Sterling on 5/28/14.
//  Copyright (c) 2014 JS. All rights reserved.
//

#import "JSTicTacToeViewController.h"
#import "JSTicTacToeViewModel.h"
#import "JSTicTacToeState.h"
#import "JSTile.h"
#import "JSStateMachine.h"

#import <ReactiveCocoa/RACSignal.h>
#import <ReactiveCocoa/RACAction.h>
#import <ReactiveCocoa/NSObject+RACPropertySubscribing.h>
#import <ReactiveCocoa/RACSubscriptingAssignmentTrampoline.h>
#import <ReactiveCocoa/UIButton+RACSupport.h>

@import UIKit.UIButton;

@interface JSTicTacToeViewController ()
@property id<JSTicTacToeState> currentState;
@end

static inline UIColor *JSColorForPlayer(JSPlayer player) {
    switch (player) {
        case JSPlayerNone:
            return [UIColor grayColor];
        case JSPlayerComputer:
            return [UIColor blackColor];
        case JSPlayerHuman:
            return [UIColor redColor];
    }
}

@implementation JSTicTacToeViewController

- (id)initWithViewModel:(id<JSTicTacToeViewModel>)viewModel {
    if (self = [super init]) {
        _viewModel = viewModel;
        RAC(self, currentState) = self.viewModel.statesSignal;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    static CGSize const kTileSize = { 100.f, 100.f };
    for (NSInteger x = 0; x < 3; x++) {
        for (NSInteger y = 0; y < 3; y++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(x * (kTileSize.width + 10), y * (kTileSize.height + 10) + 20.f, kTileSize.width, kTileSize.height);
            [self.view addSubview:button];

            JSTile *tile = [JSTile row:x column:y];
            [RACObserve(self, currentState) subscribeNext:^(id<JSTicTacToeState> state) {
                button.backgroundColor = JSColorForPlayer([state playerAtTile:tile]);
            }];

            button.rac_action = [[RACSignal return:tile].signalGenerator postcompose:self.viewModel.playTileAction].action;
        }
    }

    [self.viewModel.transitionErrorsSignal subscribeNext:^(NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Whoops" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];

    [[self.viewModel.victoriesSignal map:^(NSNumber *playerValue) {
        switch ((JSPlayer)playerValue.integerValue) {
            case JSPlayerComputer:
                return @"The computer";
            case JSPlayerHuman:
                return @"You";
            case JSPlayerNone:
                return @"Nobody";
        }
    }] subscribeNext:^(NSString *string) {
        NSString *title = [NSString stringWithFormat:@"%@ won!", string];
        [[[UIAlertView alloc] initWithTitle:title message:@"Play Again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

@end
