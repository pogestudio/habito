//
//  HAChallangeProgress.m
//  HABITO
//
//  Created by CAwesome on 2013-12-16.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import "HAChallengeProgress.h"
#import "NSDate+Compare.h"
#import "HAProgressCell.h"
#import "HAProgressInfoCell.h"

@implementation HAChallengeProgress

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.plannedDatesToShow = [self.theChallenge plannedDatesBeforeAndIncludingToday];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    
    return [self.plannedDatesToShow count];
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
        [self setUpProgressInfoCell:(HAProgressInfoCell *)cell forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ProgressCell"];
        [self setUpProgressCell:(HAProgressCell *)cell forIndexPath:indexPath];
    }
    
    NSAssert(cell != nil, @"cell is nill. wtf is up with sotryboarasdasdadsad lol");
    return cell;
}

-(void)setUpProgressCell:(HAProgressCell*)cell forIndexPath:(NSIndexPath*)indexPath;
{
    NSAssert(cell != nil, @"cell is nill. wtf is up with sotryboarasdasdadsad lol");
    
    // Configure the cell
    NSDictionary *plannedDateForCell = [self.plannedDatesToShow objectAtIndex:indexPath.row];
    NSDate *theDate = (NSDate*)plannedDateForCell[@"date"];
    NSArray *finishedUsers = (NSArray*)plannedDateForCell[@"finishedUsers"];
    BOOL userDidIt = [finishedUsers containsObject:[PFUser currentUser].objectId];
    BOOL opponentDidIt = [finishedUsers containsObject:[self.theChallenge usersOpponent].objectId];
    [cell setUpCellForDate:theDate userDid:userDidIt opponentDid:opponentDidIt];
}

-(void)setUpProgressInfoCell:(HAProgressInfoCell*)cell forIndexPath:(NSIndexPath*)indexPath;
{
    NSAssert(cell != nil, @"cell is nill. wtf is up with sotryboarasdasdadsad lol");
    [cell setUpCellForChallenge:self.theChallenge];
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44;
    if (indexPath.section == 0) {
        height = 131;
    }
    return height;
}


@end
