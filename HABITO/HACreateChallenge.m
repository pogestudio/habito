//
//  HACreateChallenge.m
//  HABITO
//
//  Created by CAwesome on 2013-12-14.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import "HACreateChallenge.h"

@implementation HACreateChallenge


#pragma mark View Stuff
-(void)viewDidLoad
{
    self.theSchedule = [PFObject objectWithClassName:@"Schedule"];
    self.theChallenge = [PFObject objectWithClassName:@"Challenge"];
    self.theChallenge[@"owner"] = [PFUser currentUser];
    self.theChallenge[@"schedule"] = self.theSchedule;
    self.theChallenge[@"isActive"] = @YES;
}

#pragma mark WantDatePicked protocol
-(void)setPickedDate:(NSDate *)pickedDate
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterLongStyle];
    self.pickedDateLabel.text = [dateFormatter stringFromDate:pickedDate];
    //    NSLog(@" PickedDate: %@", [dateFormatter stringFromDate:pickedDate]);
    self.theSchedule[@"endDate"] = pickedDate;
}

-(void)updateDaysInSchedule
{
    self.theSchedule[@"monday"] = @(self.scheduleMon.isOn);
    self.theSchedule[@"tuesday"] = @(self.scheduleTue.isOn);
    self.theSchedule[@"wednesday"] = @(self.scheduleWed.isOn);
    self.theSchedule[@"thursday"] = @(self.scheduleThu.isOn);
    self.theSchedule[@"friday"] = @(self.scheduleFri.isOn);
    self.theSchedule[@"saturday"] = @(self.scheduleSat.isOn);
    self.theSchedule[@"sunday"] = @(self.scheduleSun.isOn);
}

#pragma mark Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"DatePicker"]) {
        
        HADatePicker *datePickerVC = (HADatePicker*)segue.destinationViewController;
        datePickerVC.objectThatWantsDatePicked = self;
    }
    
    if ([[segue identifier] isEqualToString:@"FindHabitoUser"]) {
        
        HAFindHabitoUser *findHabitoUser = (HAFindHabitoUser*)segue.destinationViewController;
        findHabitoUser.objectThatWantUser = self;
    }
}

-(IBAction)saveGoalAndReturn
{
    if([self inputIsOk])
    {
        [self updateDaysInSchedule];
        [self.theChallenge saveInBackground];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        
        // open an alert with just an OK button
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid input"
                                                        message:@"Something is wrong with input. Make sure you have an action, a bet, at least one day, an end date, and an opponent!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

-(BOOL)inputIsOk
{
    BOOL inputIsCool = ![self.theAction.text isEqualToString:@""];
    inputIsCool = inputIsCool && ![self.theBet.text isEqualToString:@""];
    inputIsCool = inputIsCool && (self.scheduleMon.isOn || self.scheduleTue.isOn || self.scheduleWed.isOn || self.scheduleThu.isOn || self.scheduleFri.isOn || self.scheduleSat.isOn || self.scheduleSun.isOn);
    inputIsCool = inputIsCool && self.theChallenge[@"opponent"] != nil;
    inputIsCool = inputIsCool && self.theSchedule[@"endDate"] != nil;
    return inputIsCool;
}

#pragma mark TextDelegates
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL shouldChange = YES;
    if ([string isEqualToString:@"\n"]) {
        [self.theBet becomeFirstResponder];
        shouldChange = NO;
    }
    return shouldChange;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL shouldChange = YES;
    if ([text isEqualToString:@"\n"]) {
        [self.theBet resignFirstResponder];
        shouldChange = NO;
    } else if([[textView text] length] - range.length + text.length > 90)
    {
        shouldChange = NO;
    }
    return shouldChange;
}


-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.theChallenge[@"action"] = textField.text;
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    self.theChallenge[@"bet"] = textView.text;
    return YES;
}

#pragma mark Opponent
-(IBAction)findOpponent
{
    //POP UIALERT
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose friend source"
                                                             delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                                                    otherButtonTitles:@"HABITO", @"Facebook", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    actionSheet.destructiveButtonIndex = 2;	// make the second button red (destructive)
    [actionSheet showInView:self.view]; // show from our table view (pops up in the middle of the table)
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self performSegueWithIdentifier:@"FindHabitoUser" sender:self];
    }
    else if(buttonIndex == 1)
    {
        
        // open an alert with just an OK button
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook coming soon" message:@"Facebook integration will be implemented in the next update. Check back soon!"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark -
#pragma mark FindHabitoUser
-(void)selectedUser:(PFUser *)user
{
    self.theChallenge[@"opponent"] = user;
    NSString *newButtonTitle = [NSString stringWithFormat:@"With: %@", user.username];
    [self.chosenOpponent setTitle:newButtonTitle forState:UIControlStateNormal];
}

@end