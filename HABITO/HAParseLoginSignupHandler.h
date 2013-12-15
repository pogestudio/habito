//
//  HAParseLoginSignupHandler.h
//  HABITO
//
//  Created by CAwesome on 2013-12-14.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HAParseLoginSignupHandler : NSObject <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

+(HAParseLoginSignupHandler*)sharedHandlerpresentFromView:(UIViewController*)callingView;
-(void)makeSureUserIsLoggedIn;


@property (weak, nonatomic) UIViewController * callingView;
@property (weak, nonatomic) UIViewController * loginView;
@property (weak, nonatomic) UIViewController * signupView;

@end
