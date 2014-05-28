//
//  JSViewController.m
//  Taliban
//
//  Created by Jonathan Sterling on 5/28/14.
//  Copyright (c) 2014 JS. All rights reserved.
//

#import "JSViewController.h"
#import "JSViewModel.h"
#import "JSViewState.h"
#import "JSCoordinate.h"
#import "JSStateMachine.h"

#import <ReactiveCocoa/RACSignal.h>
#import <ReactiveCocoa/RACAction.h>
#import <ReactiveCocoa/NSObject+RACPropertySubscribing.h>
#import <ReactiveCocoa/RACSubscriptingAssignmentTrampoline.h>
#import <ReactiveCocoa/UIButton+RACSupport.h>

@import UIKit.UIButton;

@interface JSViewController ()
@property id<JSViewState> currentState;
@end

@implementation JSViewController

- (id)initWithViewModel:(id<JSViewModel>)viewModel {
    if (self = [super init]) {
        _viewModel = viewModel;
        RAC(self, currentState) = self.viewModel.statesSignal;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    static CGFloat kButtonWidth = 100.f;
    static CGFloat kButtonHeight = 100.f;

    for (NSInteger x = 0; x < 3; x++) {
        for (NSInteger y = 0; y < 3; y++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(x * (kButtonWidth + 10), y * (kButtonHeight + 10) + 20.f, kButtonWidth, kButtonHeight);
            [self.view addSubview:button];

            JSCoordinate *coordinate = [JSCoordinate row:x column:y];
            [RACObserve(self, currentState) subscribeNext:^(id<JSViewState> state) {
                switch ([state playerAtCoordinate:coordinate]) {
                    case JSPlayerNone:
                        [button setBackgroundColor:[UIColor grayColor]];
                        break;
                    case JSPlayerComputer:
                        [button setBackgroundColor:[UIColor blackColor]];
                        break;
                    default:
                        [button setBackgroundColor:[UIColor redColor]];
                        break;
                }
            }];

            button.rac_action = [[RACSignal return:coordinate].signalGenerator postcompose:self.viewModel.playCoordinateAction].action;
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
