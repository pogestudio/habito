//
//  HAAppDelegate.m
//  HABITO
//
//  Created by CAwesome on 2013-12-14.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//
#import <Parse/Parse.h>
#import <Instabug/Instabug.h>

#import "HAAppDelegate.h"
#import "HAChallenge.h"
#import "HAMessage.h"
#import "HAChallengeRequest.h"


@implementation HAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self setUpParseApp:application withLaunchOptions:launchOptions];
    [self setUpInstaBug];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)setUpParseApp:(UIApplication*)application withLaunchOptions:(NSDictionary*)launchOptions{
    
    [Parse setApplicationId:@"zGZLPGMFijXnh1MSGfuH36idkutOZMtbYHFhmwSo"
                  clientKey:@"vUajLVejPqwngPXaMSSg54bFBLOpbQiwjzIAbsY9"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [self setUpParseSubclasses];
    
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    

}

-(void)setUpParseSubclasses
{
    [HAChallenge registerSubclass];
    [HASchedule registerSubclass];
    [HAMessage registerSubclass];
    [HAChallengeRequest registerSubclass];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {

    UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
    NSString *sender = [userInfo objectForKey:@"sender"];
    [PFPush handlePush:userInfo];
    if ([sender isEqualToString:@"server"]) {
        //its a reminder, go to goals!
        UINavigationController *navCon = [tabController.childViewControllers objectAtIndex:0];
        tabController.selectedViewController = navCon;
        [navCon popToRootViewControllerAnimated:YES];
    } else {
        //NSLog(@"got a message, go to notif center!");
        tabController.selectedViewController = [tabController.childViewControllers objectAtIndex:1];
    }
}

-(void)setUpInstaBug
{
    [Instabug KickOffWithToken:@"69007dc48423847240f91642eed204dc"
                 CaptureSource:InstabugCaptureSourceUIKit
                 FeedbackEvent:InstabugFeedbackEventShake
            IsTrackingLocation:NO];
    [Instabug setShowEmail:NO];
    [Instabug setEmailIsRequired:NO];
    [Instabug setCommentIsRequired:YES];
    [Instabug setShowStartAlert:YES];
}

@end
