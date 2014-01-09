//
//  HAPushManager.m
//  HABITO
//
//  Created by CAwesome on 2013-12-29.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import "HAPushManager.h"

static HAPushManager *_sharedManager;

@implementation HAPushManager

+(HAPushManager*)sharedManager
{
    if(!_sharedManager)
    {
        _sharedManager = [[HAPushManager alloc] init];
    }
    return _sharedManager;
}

-(void)sendPushNotificationWithMessage:(NSString*)message exceptPeople:(NSArray*)people inChannel:(NSString*)channelName
{
    NSString *sound = @"slap0.aiff";
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          message, @"alert",
                          @"Increment", @"badge",
                          sound, @"sound",
                          [PFUser currentUser].username, @"sender",
                          nil];
    
    NSTimeInterval interval = 60*60*24; // make it stay for two days
    
    PFPush *push = [[PFPush alloc] init];
    PFQuery *pushQuery = [PFInstallation query];
    for (PFUser *user in people) {
        [pushQuery whereKey:@"userId" notEqualTo:user.objectId];
    }
    [pushQuery whereKey:@"channels" equalTo:channelName];
    [push setQuery:pushQuery];
    [push setData:data];
    [push expireAfterTimeInterval:interval];
    [push sendPushInBackground];
}

-(void)sendPushToUser:(PFUser*)user withMessage:(NSString*)message
{
    NSString *sound = @"slap0.aiff";
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          message, @"alert",
                          @"Increment", @"badge",
                          sound, @"sound",
                          @"server", @"sender",
                          nil];
    
    NSTimeInterval interval = 60*60*24; // make it stay for two days
    
    PFPush *push = [[PFPush alloc] init];
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"user" equalTo:user];
    [push setQuery:pushQuery];
    [push setData:data];
    [push expireAfterTimeInterval:interval];
    [push sendPushInBackground];
}

@end
