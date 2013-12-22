//
//  PFInstallation+userHandler.m
//  HABITO
//
//  Created by CAwesome on 2013-12-22.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import "PFInstallation+userHandler.h"

#define USER_OBJECTID_KEY @"user"

@implementation PFInstallation (userHandler)

-(void)saveLoggedinUserData
{
    [self setObject:[PFUser currentUser] forKey:USER_OBJECTID_KEY];
    [self saveInBackground];
}

-(void)removeLoggedInUserData
{
    [self removeObjectForKey:USER_OBJECTID_KEY];
    [self saveInBackground];
}

@end
