//
//  JSAppDelegate.m
//  Taliban
//
//  Created by Jonathan Sterling on 5/28/14.
//  Copyright (c) 2014 JS. All rights reserved.
//

#import "JSAppDelegate.h"
#import "JSTicTacToeViewController.h"
#import "JSTicTacToeViewModelImpl.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation JSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = [[JSTicTacToeViewController alloc] initWithViewModel:[JSTicTacToeViewModel new]];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
