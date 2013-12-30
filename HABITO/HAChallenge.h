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
@property (retain) PFUser *challenged;
@property (retain) PFUser *owner;
@property (retain) PFUser *wonBy;
@property (retain) HASchedule *schedule;
@property (retain) NSArray *plannedDates;
@property  BOOL isActive;


@property  (retain) NSDate* nextPlannedDay;
@property  BOOL userHasDoneNextDueDate;
@property  BOOL opponentHasDoneNextDueDate;


-(void)createPlannedDatesAndSaveInBackground;
-(void)updatePropertiesToMatchNextDueDate;
-(BOOL)userIsOwner;
-(PFUser*)usersOpponent;

-(void)currentUserDidNextDueDate;

-(PFUser*)userInTheLead;
-(NSUInteger)completedChallangesForUser:(PFUser*)user;
-(NSArray*)plannedDatesBeforeAndIncludingToday;
-(NSUInteger)amountOfPlannedDatesLeftAfterToday;

-(BOOL)dueDateIsToday;
-(NSString*)channelName;

-(void)cancelChallengeAndNotifyOpponent;
-(void)saveAndUpdateTableViewWhenDone;

@end
