//
//  HAChallengeCell.m
//  HABITO
//
//  Created by CAwesome on 2013-12-15.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import "HAChallengeCell.h"
#import "NSDate+Compare.h"

typedef enum {
    Checkmark = 0,
    Cross = 1,
    Clear = 2
} ImageToShow;

@implementation HAChallengeCell

-(void)setUpForObject:(HAChallenge *)challenge
{
    self.theChallenge = challenge;
    self.theAction.text = challenge.action;
    
    [self setUpViewForUser];
    [self setUpViewForOpponent];
    
}

-(void)setUpViewForUser
{
    //if the player has done the action, show it.
    //if he hasn't, see if due date is today. if it is, color it red.
    //                      if it isnt, leave it.
    
    //NSLog(@"next planned day:: %@", self.theChallenge.nextPlannedDay);
    if (self.theChallenge.userHasDoneNextDueDate) {
        [self.ownerStatus setImage:[UIImage imageNamed:@"checkmark"]];
    } else if ([self.theChallenge.nextPlannedDay isToday])
    {
        [self.ownerStatus setImage:[UIImage imageNamed:@"cross"]];
    } else {
        [self.ownerStatus setImage:[UIImage imageNamed:@"qmark"]];
    }
}

-(void)setUpViewForOpponent
{
    self.theOpponent.text = [self.theChallenge usersOpponent].username;
    
    //if the player has done the action, show it.
    //if he hasn't, see if due date is today. if it is, color it red.
    //                      if it isnt, leave it.
    
    //NSLog(@"next planned day:: %@", self.theChallenge.nextPlannedDay);
    if (self.theChallenge.opponentHasDoneNextDueDate) {
        [self.opponentStatus setImage:[UIImage imageNamed:@"checkmark"]];
    } else if ([self.theChallenge.nextPlannedDay isToday])
    {
        [self.opponentStatus setImage:[UIImage imageNamed:@"cross"]];
    } else {
        [self.opponentStatus setImage:[UIImage imageNamed:@"qmark"]];
    }
}




@end