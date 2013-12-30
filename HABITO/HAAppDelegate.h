//
//  HAAppDelegate.h
//  HABITO
//
//  Created by CAwesome on 2013-12-14.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PFQueryTableViewController;

@interface HAAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property PFQueryTableViewController* challengeQueryTBVC;

@end
