//
//  HAProgressInfoCell.m
//  HABITO
//
//  Created by CAwesome on 2013-12-16.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import "HAProgressInfoCell.h"

@implementation HAProgressInfoCell

-(void)setUpCellForChallenge:(HAChallenge *)theChallenge
{
    //USERAMOUNTDONE
    NSUInteger userDone = [theChallenge completedChallangesForUser:[PFUser currentUser]];
    PFUser *opponent = [theChallenge usersOpponent];
    NSUInteger opponentDone = [theChallenge completedChallangesForUser:opponent];
    self.opponentAmountDone.text = [NSString stringWithFormat:@"%lu", (unsigned long)opponentDone];
    self.userAmountDone.text = [NSString stringWithFormat:@"%lu", (unsigned long)userDone];
    
    
    //DECIDE WHO IS WINNING
#warning can skip this call if performance issues, all info is above
    PFUser *userInTheLead = [theChallenge userInTheLead];
    //end warning
    
    NSString *winningUserName = userInTheLead ? userInTheLead.username : nil;
    NSString *isInTheLead = [NSString stringWithFormat:@"%@ is in the lead",winningUserName];
    NSString *evenRace = @"It's an even race";
    NSString *winningText = winningUserName == nil ? evenRace : isInTheLead;
    
    NSInteger daysToGo = [theChallenge amountOfPlannedDatesLeftAfterToday];
    NSString *infoText = [NSString stringWithFormat:@"%@ with %ld habit days to go!",winningText,(long)daysToGo];
    self.infoLabel.text = infoText;
    [self.infoLabel sizeToFit];
    
    //USERNAMES
    self.userName.text = [PFUser currentUser].username;
    self.opponentName.text = [theChallenge usersOpponent].username;
    
    
    [self setUpImagesWithWinningUser:userInTheLead];
}


-(void)setUpImagesWithWinningUser:(PFUser*)winner
{
    UIImageView *imageViewToGetStar;
    if(winner == nil)
    {
        imageViewToGetStar = self.middleImage;
    } else if ([winner.objectId isEqualToString:[PFUser currentUser].objectId]) {
        imageViewToGetStar = self.userImage;
    } else {
        imageViewToGetStar = self.opponentImage;
    }
    
    [imageViewToGetStar setImage:[UIImage imageNamed:@"star"]];
}

@end
