//
//  HAChallenge.m
//  HABITO
//
//  Created by CAwesome on 2013-12-14.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import "HAChallenge.h"
#import <Parse/PFObject+Subclass.h>
#import "NSDate-Utilities.h"
#import "HAPushManager.h"
#import "HAMessage.h"
#import "HAAppDelegate.h"

@implementation HAChallenge

@dynamic action;
@dynamic bet;
@dynamic challenged;
@dynamic owner;
@dynamic wonBy;
@dynamic isActive;
@dynamic schedule;
@dynamic plannedDates;

@dynamic ownerWantsReminders;
@dynamic challengedWantsReminders;
@dynamic ownerReminderTime;
@dynamic challengedReminderTime;


@dynamic nextPlannedDay;
@dynamic userHasDoneNextDueDate;
@dynamic opponentHasDoneNextDueDate;

+ (NSString *)parseClassName {
    return @"Challenge";
}

-(void)saveAndUpdateTableViewWhenDone
{
    PFQueryTableViewController *qTBVC = ((HAAppDelegate*)[UIApplication sharedApplication].delegate).challengeQueryTBVC;
    
    [self saveInBackgroundWithTarget:qTBVC selector:@selector(loadObjects)];
}

-(void)createPlannedDatesAndSaveInBackground
{
    [self createPlannedDates];
    [self saveAndUpdateTableViewWhenDone];
}

-(void)createPlannedDates
{
    NSArray *allDates = [self.schedule allDatesThatShouldBePlanned];
    NSMutableArray *plannedDates = [NSMutableArray array];
    for (NSDate *aDate in allDates) {
        NSDictionary *plannedDate = @{@"date": aDate,
                                      @"finishedUsers": @[]};
        [plannedDates addObject:plannedDate];
    }
    self.plannedDates = plannedDates;
}

-(void)updatePropertiesToMatchNextDueDate
{
    [self sortPlannedDates];
    
    NSDictionary *nextPlannedDate = [self getNextPlannedDateInChronologicalOrder];
    
    [self updatePropertiesToMatchNextDueDate:nextPlannedDate];
    //should be no need to save. all the items are still parsed every time we fetch the goal (every time we update the view), and so we don't have to put it at the server
    //[self saveInBackground];
    
}

-(NSDictionary*)getNextPlannedDateInChronologicalOrder
{
    NSDate *today = [NSDate date];
    NSDictionary *nextPlannedDate = nil;
    for (NSDictionary *plannedDate in self.plannedDates) {
        NSDate *nextDate = plannedDate[@"date"];
        if ([nextDate isToday] || [nextDate isLaterThanDate:today]) {
            nextPlannedDate = plannedDate;
            break;
        }
    }
    return nextPlannedDate;
}

-(void)sortPlannedDates
{
    self.plannedDates = [self.plannedDates sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(NSDictionary*)a objectForKey:@"date"];
        NSDate *second = [(NSDictionary*)b objectForKey:@"date"];
        return [first compare:second];
    }];
}

-(void)updatePropertiesToMatchNextDueDate:(NSDictionary*)nextPlannedDate
{
    if(nextPlannedDate)
    {
        self.nextPlannedDay = (NSDate*)nextPlannedDate[@"date"];
        
        NSArray *finishedUsers = (NSArray*)nextPlannedDate[@"finishedUsers"];
        self.userHasDoneNextDueDate = [finishedUsers containsObject:[PFUser currentUser].objectId];
        self.opponentHasDoneNextDueDate = [finishedUsers containsObject:[self usersOpponent].objectId];
    }
}


-(BOOL)userIsOwner{
    return [self.owner.objectId isEqualToString:[PFUser currentUser].objectId];
}

-(PFUser*)usersOpponent
{
    BOOL userIsOwner = [self userIsOwner];
    if (userIsOwner) {
        return self.challenged;
    } else {
        return self.owner;
    }
}

-(void)currentUserDidNextDueDate
{
    NSString *finishedUsersKey = @"finishedUsers";
    
    //make it simple.
    //get a mutable copy of the entire array.
    NSMutableArray *tempCopy = [self.plannedDates mutableCopy];
    //copy the nextplanned date
    NSDictionary *nextPlannedDate = [self getNextPlannedDateInChronologicalOrder];
    //save index to insert at same place
    NSUInteger indexOfPlannedDate = [self.plannedDates indexOfObject:nextPlannedDate];
    //remove it from array
    [tempCopy removeObject:nextPlannedDate];
    //modify it.
    NSMutableDictionary *mutablePlannedDate = [nextPlannedDate mutableCopy];
    NSMutableArray *finishedUsers = [(NSArray*)mutablePlannedDate[finishedUsersKey] mutableCopy];
    [mutablePlannedDate removeObjectForKey:finishedUsersKey];
    
    [finishedUsers addObject:[PFUser currentUser].objectId];
    //put it back
    [mutablePlannedDate setObject:finishedUsers forKey:finishedUsersKey];
    [tempCopy insertObject:mutablePlannedDate atIndex:indexOfPlannedDate];
    //copy mutableArray back to plannedDates as array
    self.plannedDates = [NSArray arrayWithArray:tempCopy];
    [self saveAndUpdateTableViewWhenDone];
    
    NSString *pushMessage = [NSString stringWithFormat:@"%@ just completed %@. Don't fall behind, get going!",[PFUser currentUser].username, self.action];
    [[HAPushManager sharedManager] sendPushNotificationWithMessage:pushMessage exceptPeople:@[[PFUser currentUser]] inChannel:[self channelName]];
    
    
    
#warning This does not seem to save the goal. alternatively, the goal is inaccurately saved.
    
}

-(PFUser*)userInTheLead
{
    NSUInteger ownerCount = [self completedChallangesForUser:self.owner];
    NSUInteger opponentCount = [self completedChallangesForUser:self.challenged];
    PFUser *winningUser;
    if (ownerCount > opponentCount) {
        winningUser = self.owner;
    } else if(ownerCount < opponentCount) {
        winningUser = self.challenged;
    }
    return winningUser;
}

-(NSUInteger)completedChallangesForUser:(PFUser *)user
{
    NSUInteger count = 0;
    for (NSDictionary* plannedDate in self.plannedDates) {
        NSArray *finishedUsers = plannedDate[@"finishedUsers"];
        if ([finishedUsers containsObject:user.objectId]) {
            count++;
        }
    }
    return count;
}

-(NSArray*)plannedDatesBeforeAndIncludingToday
{
    NSMutableArray *datesToShow = [NSMutableArray array];
    NSDate *today = [NSDate date];
    for (NSDictionary *plannedDate in self.plannedDates) {
        NSAssert([[plannedDate objectForKey:@"date"] isKindOfClass:[NSDate class]],@"wrong class in dictionary");
        NSDate *planned = (NSDate*)[plannedDate objectForKey:@"date"];
        if ([planned isToday] || [planned isEarlierThanDate:today]) {
            [datesToShow addObject:plannedDate];
        }
    }
    return [[datesToShow reverseObjectEnumerator] allObjects];
}

-(NSUInteger)amountOfPlannedDatesLeftAfterToday
{
    NSUInteger allDates = [self.plannedDates count];
    NSUInteger remaining = allDates - [[self plannedDatesBeforeAndIncludingToday] count];
    return remaining;
}

-(BOOL)dueDateIsToday
{
    return [self.nextPlannedDay isToday];
}
-(NSString*)channelName
{
    NSString *channel = [NSString stringWithFormat:@"channel%@",self.objectId];
    return channel;
}

-(void)cancelChallengeAndNotifyOpponent
{
//    NSLog(@"want to cancel!");
    //set winner to other person
    //set isactive to no
    //save
    
    PFUser *opponent = [self usersOpponent];
    self.wonBy = opponent;
    self.isActive = NO;
    [self saveInBackground];
    
    NSString *message = [NSString stringWithFormat:@"I just gave up %@, so you win the bet: %@",self.action,self.bet];
    [HAMessage createMessageForChallenge:self withMessage:message];
}
@end
