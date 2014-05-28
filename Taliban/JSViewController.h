//
//  JSViewController.h
//  Taliban
//
//  Created by Jonathan Sterling on 5/28/14.
//  Copyright (c) 2014 JS. All rights reserved.
//

@import UIKit.UIViewController;

@protocol JSViewModel;

@interface JSViewController : UIViewController
@property (readonly) id<JSViewModel> viewModel;
- (id)initWithViewModel:(id<JSViewModel>)viewModel;
@end
