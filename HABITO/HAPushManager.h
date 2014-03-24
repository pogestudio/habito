//
//  HAPushManager.h
//  HABITO
//
//  Created by CAwesome on 2013-12-29.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HAPushManager : NSObject

+(HAPushManager*)sharedManager;

-(void)sendPushNotificationWithMessage:(NSString*)message exceptPeople:(NSArray*)people inChannel:(NSString*)channelName;
-(void)sendPushToUser:(PFUser*)user withMessage:(NSString*)message;

@end
