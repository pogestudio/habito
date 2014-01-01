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
#import "HAChallengeSettings.h"

@implementation HAViewChallenge

CGRect _slapSentOriginalFrame;

-(void)viewWillAppear:(BOOL)animated
{
    NSAssert(self.theChallenge !=nil, @"challenge is nil in viewChallenge. weeeeeird");
    
    _slapSentOriginalFrame = self.slapSentLabel.frame;
    
    [super viewWillAppear:animated];
    
    [self setUpLabels];
    [self setUpStatusImage];
    [self setUpOpponentCell];
    
    [self giveTipIfFirstTime];
    
}

-(void)giveTipIfFirstTime
{
    NSString *keyString = @"firstTimeWatchViewChallenge";
    NSNumber *hasBeenHereBefore = [[NSUserDefaults standardUserDefaults] objectForKey:keyString];
    if (![hasBeenHereBefore boolValue]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tap tap"
                                                        message:@"When you finish a habit, double tap the cross to mark it as done for the day"
                                                       delegate:nil
                                              cancelButtonTitle:@"Okey dokey!"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    NSNumber *saveValue = [NSNumber numberWithBool:YES];
    [[NSUserDefaults standardUserDefaults] setObject:saveValue forKey:keyString];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setUpLabels
{
    self.actionLabel.text = self.theChallenge.action;
    self.betLabel.text = self.theChallenge.bet;
    self.opponentLabel.text = [self.theChallenge usersOpponent].username;
    
    if ([self.theChallenge opponentHasDoneNextDueDate]) {
        self.sendSlapLabel.hidden = YES;
    }
    self.slapSentLabel.frame = CGRectOffset(_slapSentOriginalFrame, 200, 0);
    
    [self.actionLabel sizeToFit];
    [self.betLabel sizeToFit];
    [self.opponentLabel sizeToFit];
}

-(void)animateInSlapLabel
{
    self.slapSentLabel.frame = CGRectOffset(_slapSentOriginalFrame, 200, 0);
    
    [UIView animateWithDuration:0.5 animations:^(void){
        self.slapSentLabel.frame = CGRectOffset(self.slapSentLabel.frame, -220, 0);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.2 animations:^(void){
            self.slapSentLabel.frame = CGRectOffset(self.slapSentLabel.frame, 20, 0);
        }];

    }];
}

-(void)setUpStatusImage
{
    NSString *imageName;
    if(self.theChallenge.userHasDoneNextDueDate)
    {
        imageName = @"bigCheckmark";
    } else {
        imageName = @"bigCross";
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
    UIColor *backgroundColorToUse = [UIColor colorWithRed:75.0f/255.0f green:216.0f/255.0f blue:13.0f/255.0f alpha:1];
    [opponentCell setBackgroundColor:backgroundColorToUse];
    [self.opponentLabel setBackgroundColor:backgroundColorToUse];
    [self.opponentLabel setTextColor:[UIColor blackColor]];
}

-(void)setOpponentSlacking
{
    UIView *opponentCell = [self.opponentLabel superview];
    UIColor *backgroundColorToUse = [UIColor colorWithRed:216.0f/255.0f green:32.0f/255.0f blue:39.0f/255.0f alpha:1];
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
    } else if ([[segue identifier] isEqualToString:@"Settings"]) {
        
        HAChallengeSettings *settingsVC = (HAChallengeSettings*)segue.destinationViewController;
        settingsVC.theChallenge = self.theChallenge;
    }
    
}

-(IBAction)sendSlap
{
    BOOL opponentIsLate = !self.theChallenge.opponentHasDoneNextDueDate;
    BOOL userIsLate = !self.theChallenge.userHasDoneNextDueDate;
    
    
    if (!userIsLate && opponentIsLate) {
        NSString *challengerName = [self.theChallenge usersOpponent].username;
        NSString *alertText = [NSString stringWithFormat:@"Enter a motivational message that will go along with your slap to %@!",challengerName];
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
        self.sendSlapLabel.hidden = YES;
        [self animateInSlapLabel];
        
    }
}


@end
