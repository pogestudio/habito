//
//  PFInstallation+userHandler.h
//  HABITO
//
//  Created by CAwesome on 2013-12-22.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import <Parse/Parse.h>

@interface PFInstallation (userHandler)

-(void)saveLoggedinUserData;
-(void)removeLoggedInUserData;

@end
