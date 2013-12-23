//
//  HASettingsVC.m
//  HABITO
//
//  Created by CAwesome on 2013-12-22.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import "HASettingsVC.h"
#import "PFInstallation+userHandler.h"

@implementation HASettingsVC

-(IBAction)logout
{
    [PFUser logOut];
    [[PFInstallation currentInstallation] removeLoggedInUserData];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
