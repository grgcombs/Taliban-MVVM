//
//  JSViewController.h
//  Taliban
//
//  Created by Jonathan Sterling on 5/28/14.
//  Copyright (c) 2014 JS. All rights reserved.
//

@import UIKit.UIViewController;

@protocol JSTicTacToeViewModel;

@interface JSTicTacToeViewController : UIViewController
@property (readonly) id<JSTicTacToeViewModel> viewModel;
- (id)initWithViewModel:(id<JSTicTacToeViewModel>)viewModel;
@end
