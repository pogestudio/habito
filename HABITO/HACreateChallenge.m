//
//  HACreateChallenge.m
//  HABITO
//
//  Created by CAwesome on 2013-12-14.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import "HACreateChallenge.h"
#import "NSDate-Utilities.h"
#import "HAChallengeRequestHandler.h"

@implementation HACreateChallenge


#pragma mark View Stuff
-(void)viewDidLoad
{
    //    self.theSchedule = [HASchedule object];
    self.theChallenge = [HAChallenge object];
    self.theChallenge.owner = [PFUser currentUser];
    self.theChallenge.schedule = [HASchedule object];//self.theSchedule;
    self.theChallenge.isActive = NO; //not until the opponent has accepted!
    
    self.theChallenge.challengedReminderTime = [NSDate date];
    self.theChallenge.ownerReminderTime = [NSDate date];
    self.theChallenge.ownerWantsReminders = YES;
    self.theChallenge.challengedWantsReminders = YES;
    
    //HOTFIX set nextPlannedDay today, so that it is not null (will crash the list view)
    self.theChallenge.nextPlannedDay = [NSDate date];
    
    self.endDatePicker.minimumDate = [NSDate date];
    self.endDatePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow: 3600 * 24 * 364/2]; //set max date half a year;
}

#pragma mark WantDatePicked protocol
-(void)setPickedDate:(NSDate *)pickedDate
{
    self.theChallenge.schedule.endDate = pickedDate;
    self.pickedDateLabel.text = [NSString stringWithFormat:@"Ends: %@",[pickedDate descriptionOfDateAsMonthAndDay]];
    //    NSLog(@" PickedDate: %@", [dateFormatter stringFromDate:pickedDate]);
}

-(void)updateDaysInSchedule
{
    self.theChallenge.schedule.monday = self.scheduleMon.isOn;
    self.theChallenge.schedule.tuesday = self.scheduleTue.isOn;
    self.theChallenge.schedule.wednesday = self.scheduleWed.isOn;
    self.theChallenge.schedule.thursday = self.scheduleThu.isOn;
    self.theChallenge.schedule.friday = self.scheduleFri.isOn;
    self.theChallenge.schedule.saturday = self.scheduleSat.isOn;
    self.theChallenge.schedule.sunday = self.scheduleSun.isOn;
}

#pragma mark Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"DatePicker"]) {
        
        HADatePicker *datePickerVC = (HADatePicker*)segue.destinationViewController;
        datePickerVC.objectThatWantsDatePicked = self;
        datePickerVC.maxAmountOfDaysInFuture = 364/2;
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
        
        //fix the bet so its not empty.
        if (!self.theChallenge.bet || [self.theChallenge.bet isEqualToString:@""]) {
            self.theChallenge.bet = @"No bet";
        }
        
        [self.theChallenge createPlannedDatesAndSaveInBackground];
        [[HAChallengeRequestHandler sharedHandler] createRequestForNewChallenge:self.theChallenge];
        [self.navigationController popViewControllerAnimated:YES];
        NSString *messageForAlert = [NSString stringWithFormat:@"The challengee, %@, has to accept before you can start. You will be notified when it hits off!",self.theChallenge.challenged.username];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Habit created!"
                                                        message:messageForAlert
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
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
    inputIsCool = inputIsCool && self.theChallenge.challenged != nil;
    inputIsCool = inputIsCool && self.theChallenge.schedule.endDate != nil;
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
    self.theChallenge.action = textField.text;
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    self.theChallenge.bet = textView.text;
    return YES;
}

#pragma mark Opponent
-(IBAction)findOpponent
{
    [self performSegueWithIdentifier:@"FindHabitoUser" sender:self];
    /*
     //POP UIALERT
     UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose friend source"
     delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
     otherButtonTitles:@"HABITO", @"Facebook", nil];
     actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
     actionSheet.destructiveButtonIndex = 2;	// make the second button red (destructive)
     [actionSheet showInView:self.view]; // show from our table view (pops up in the middle of the table)
     */
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
    self.theChallenge.challenged = user;
    NSString *newButtonTitle = [NSString stringWithFormat:@"With: %@", user.username];
    [self.chosenOpponent setTitle:newButtonTitle forState:UIControlStateNormal];
}

#pragma mark
#pragma mark DATEPICK
-(IBAction)datePickerDidChange:(id)sender
{
    NSAssert([sender isKindOfClass:[UIDatePicker class]], @"wrong class in date shit!!");
    NSDate *selectedDate = [((UIDatePicker*)sender) date];
    
    self.theChallenge.schedule.endDate = selectedDate;
    
    self.pickedDateLabel.text = [selectedDate descriptionOfDateAsMonthAndDay];
}

#pragma mark TableViewStuff

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    switch (indexPath.row) {
        case 0:
        {
            height = 73;
            break;
        }
        case 1:
        {
            height = 95;
            break;
        }
        case 2:
        {
            height = 198;
            break;
        }
        case 3:
        {
            height = 62;
            break;
        }
        case 4:
        {
            //PICKERDATE!!
            if (self.weAreEditingEndDate) {
                height = 162;
            } else {
                height = 0;
            }
            break;
        }
        case 5:
        {
            height = 62;
            break;
        }
        default:
            NSAssert(nil,@"more cells then heights in create date!");
            break;
    }
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 3) { // this is my date cell above the picker cell
        self.weAreEditingEndDate = !self.weAreEditingEndDate;
    } else
    {
        self.weAreEditingEndDate = NO;
    }
    
    [UIView animateWithDuration:.4 animations:^{
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
    }];
    
}


@end
