//
//  HAChallengeSettings.m
//  HABITO
//
//  Created by CAwesome on 2013-12-29.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import "HAChallengeSettings.h"
#import "HAChallenge.h"
@implementation HAChallengeSettings

NSString *correctionText = @"I DO NOT WANT TO CHANGE";

-(IBAction)startCancelAction
{
    //pop controller, asking if they want to cancel
    //if they enter the correct shit, call cancelChallenge
    
	// open an alert with two custom buttons
    NSString *message = [NSString stringWithFormat:@"Do you really want to quit? If so, type '%@' into the box",correctionText];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Really?"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"I changed my mind!"
                                          otherButtonTitles:@"Yes.. I want to quit", nil];
	alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 1 || alertView.alertViewStyle == UIAlertViewStyleDefault) {
        return;
    }
    
    NSString *text = [alertView textFieldAtIndex:0].text;
    
    if( [text caseInsensitiveCompare:correctionText] == NSOrderedSame ) // its OK button, and the correct text is entered :'(
    {
        [self.theChallenge cancelChallengeAndNotifyOpponent];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrecto"
                                                        message:@"Wrong text"
                                                       delegate:self
                                              cancelButtonTitle:@"Ok, maybe I changed my mind"
                                              otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
    }
    
    
}


#pragma mark Navigation
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 2) { // this is my picker cell
        if (self.weAreEditingStartTime) {
            return 162;
        } else {
            return 0;
        }
    } else {
        return self.tableView.rowHeight;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) { // this is my date cell above the picker cell
        self.weAreEditingStartTime = !self.weAreEditingStartTime;
    } else
    {
        self.weAreEditingStartTime = NO;
    }
    
    [UIView animateWithDuration:.4 animations:^{
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
    }];
    
}

#pragma mark DATEPICK
-(IBAction)datePickerDidChange:(id)sender
{
    NSAssert([sender isKindOfClass:[UIDatePicker class]], @"wrong class in date shit!!");
    NSDate *selectedDate = [((UIDatePicker*)sender) date];
    
    if ([self.theChallenge userIsOwner]) {
        self.theChallenge.ownerReminderTime = selectedDate;
    } else {
        self.theChallenge.challengedReminderTime = selectedDate;
    }
    
    [self updateDatelabelValueWithDate:selectedDate];
}

-(void)updateDatelabelValueWithDate:(NSDate*)date
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *currentTime = [dateFormatter stringFromDate:date];
    self.dateLabel.text = currentTime;
}

#pragma mark DATEPICK
-(IBAction)remindersOnOrOffDidChange:(id)sender
{
    NSAssert([sender isKindOfClass:[UISwitch class]], @"wrong class in date shit!!");
    BOOL remindersAreOn = [((UISwitch*)sender) isOn];
    
    if ([self.theChallenge userIsOwner]) {
        self.theChallenge.ownerWantsReminders = remindersAreOn;
    } else {
        self.theChallenge.challengedWantsReminders = remindersAreOn;
    }
}

#pragma mark UIVIEW

-(void)viewWillAppear:(BOOL)animated
{
    
    if ([self.theChallenge userIsOwner]) {
        [self updateDatelabelValueWithDate:self.theChallenge.ownerReminderTime];
        [self.reminderSwitch setOn:self.theChallenge.ownerWantsReminders];
    } else {
        [self updateDatelabelValueWithDate:self.theChallenge.challengedReminderTime];
        [self.reminderSwitch setOn:self.theChallenge.challengedWantsReminders];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //save challenge when we leave view
    [self.theChallenge saveInBackground];
}



@end
