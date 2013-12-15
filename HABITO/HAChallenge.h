//
//  HAChallenge.h
//  HABITO
//
//  Created by CAwesome on 2013-12-14.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import <Parse/Parse.h>

#import "HASchedule.h"

@interface HAChallenge : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@property (retain) NSString *action;
@property (retain) NSString *bet;
@property (retain) PFUser *opponent;
@property (retain) PFUser *owner;
@property (retain) PFUser *winner;
@property (retain) HASchedule *theSchedule;
@property  BOOL isActive;

//-(void)setSchedule:(HASchedule*)theSchedule;

@end
