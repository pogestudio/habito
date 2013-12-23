//
//  HAViewChallenge.m
//  HABITO
//
//  Created by CAwesome on 2013-12-15.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import "HAViewChallenge.h"
#import "HAChallengeProgress.h"
#import "HAMessage.h"

@implementation HAViewChallenge


-(void)viewWillAppear:(BOOL)animated
{
    NSAssert(self.theChallenge !=nil, @"challenge is nil in viewChallenge. weeeeeird");
    
    [super viewWillAppear:animated];
    
    [self setUpLabels];
    [self setUpStatusImage];
    [self setUpOpponentCell];
    
}

-(void)setUpLabels
{
    self.actionLabel.text = self.theChallenge.action;
    self.betLabel.text = self.theChallenge.bet;
    self.opponentLabel.text = [self.theChallenge usersOpponent].username;
    
    [self.actionLabel sizeToFit];
    [self.betLabel sizeToFit];
    [self.opponentLabel sizeToFit];
}

-(void)setUpStatusImage
{
    NSString *imageName;
    if(self.theChallenge.userHasDoneNextDueDate)
    {
        imageName = @"checkmark";
    } else {
        imageName = @"cross";
    }
    
    UIImage *imageTouse = [UIImage imageNamed:imageName];
    [self.statusImage setImage:imageTouse];
    
}

-(void)setUpOpponentCell
{
    if (self.theChallenge.opponentHasDoneNextDueDate)
    {
        [self setOpponentDone];
    } else if([self.theChallenge dueDateIsToday]) {
        [self setOpponentSlacking];
    }
    

}

-(void)setOpponentDone
{
    UIView *opponentCell = [self.opponentLabel superview];
    UIColor *backgroundColorToUse = [UIColor greenColor];
    [opponentCell setBackgroundColor:backgroundColorToUse];
    [self.opponentLabel setBackgroundColor:backgroundColorToUse];
    [self.opponentLabel setTextColor:[UIColor blackColor]];
}

-(void)setOpponentSlacking
{
    UIView *opponentCell = [self.opponentLabel superview];
    UIColor *backgroundColorToUse = [UIColor redColor];
    [opponentCell setBackgroundColor:backgroundColorToUse];
    [self.opponentLabel setBackgroundColor:backgroundColorToUse];
    [self.opponentLabel setTextColor:[UIColor whiteColor]];
}

-(IBAction)doubleTapImageView
{
    //user has marked as done
    //switch bool
    //update image
    
    //add user to finished users in planned dates
    //update challenge
    
    self.theChallenge.userHasDoneNextDueDate = YES;
    [self setUpStatusImage];
    [self.theChallenge currentUserDidNextDueDate];
    
    
}

#pragma mark Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"Progress"]) {
        
        HAChallengeProgress *progressVC = (HAChallengeProgress*)segue.destinationViewController;
        progressVC.theChallenge = self.theChallenge;
    }
    
}

-(IBAction)sendSlap
{
    BOOL opponentIsLate = !self.theChallenge.opponentHasDoneNextDueDate;
    BOOL userIsLate = !self.theChallenge.userHasDoneNextDueDate;
    
    
    if (!userIsLate && opponentIsLate) {
        NSString *challengerName = [self.theChallenge usersOpponent].username;
        NSString *alertText = [NSString stringWithFormat:@"Enter a motivational message that will go along with your slap, which will slap %@ into action!",challengerName];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Send motivation!"
                                                        message:alertText
                                                       delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
    } else if(![self.theChallenge dueDateIsToday]) {
        NSString *alertText = [NSString stringWithFormat:@"You can't slap unless they are falling behind. Jeez"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Slap? Cannot"
                                                        message:alertText
                                                       delegate:self
                                              cancelButtonTitle:@"Ok..."
                                              otherButtonTitles: nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
    } else if(userIsLate){
        NSString *alertText = [NSString stringWithFormat:@"Hah! Trying to slap while you yourself are being lazy? I think NOT!"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Slap yourself!"
                                                        message:alertText
                                                       delegate:self
                                              cancelButtonTitle:@"Ok..."
                                              otherButtonTitles: nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
    }
}

#pragma mark -
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *textFromUser = [alertView textFieldAtIndex:0].text;
        [HAMessage createMessageForChallenge:self.theChallenge withMessage:textFromUser];
    }
}

@end
