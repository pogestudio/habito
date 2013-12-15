//
//  HAFindHabitoUser.h
//  HABITO
//
//  Created by CAwesome on 2013-12-15.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import <Parse/Parse.h>

@protocol FindHabitoUser

-(void)selectedUser:(PFUser*)user;

@end

@interface HAFindHabitoUser : PFQueryTableViewController <UISearchBarDelegate>

@property (retain) NSString *searchText;
@property (weak) id<FindHabitoUser>objectThatWantUser;

@end
