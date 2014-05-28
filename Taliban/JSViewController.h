//
//  JSViewController.h
//  Taliban
//
//  Created by Jonathan Sterling on 5/28/14.
//  Copyright (c) 2014 JS. All rights reserved.
//

@import UIKit.UIViewController;

@class JSViewModel;

@interface JSViewController : UIViewController
@property (readonly) JSViewModel *viewModel;
- (id)initWithViewModel:(JSViewModel *)viewModel;
@end
