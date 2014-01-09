//
//  PFInstallation+userHandler.m
//  HABITO
//
//  Created by CAwesome on 2013-12-22.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import "PFInstallation+userHandler.h"

#define USER_OBJECTID_KEY @"userId"

@implementation PFInstallation (userHandler)

-(void)saveLoggedinUserData
{
    [self setObject:[PFUser currentUser].objectId forKey:USER_OBJECTID_KEY];
    [self saveInBackground];
}

-(void)removeLoggedInUserData
{
    //TEMP FIX FOR BAD VERSION. Remove in 1.03 or so!
    [self removeObjectForKey:@"user"];
    
    [self removeObjectForKey:USER_OBJECTID_KEY];
    [self saveInBackground];
}

@end
