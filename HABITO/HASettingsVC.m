//
//  HASettingsVC.m
//  HABITO
//
//  Created by CAwesome on 2013-12-22.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import "HASettingsVC.h"
#import "PFInstallation+userHandler.h"
#import "HATutorialVC.h"


@implementation HASettingsVC

-(IBAction)logout
{
    [PFUser logOut];
    [[PFInstallation currentInstallation] removeLoggedInUserData];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"DatePicker"]) {
        
        HADatePicker *datePickerVC = (HADatePicker*)segue.destinationViewController;
        datePickerVC.objectThatWantsDatePicked = self;
    }
}

#pragma mark WantDatePicked protocol
-(void)setPickedDate:(NSDate *)pickedDate
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterLongStyle];
    self.reminderDate.text = [dateFormatter stringFromDate:pickedDate];
    //    NSLog(@" PickedDate: %@", [dateFormatter stringFromDate:pickedDate]);
//    self.theChallenge.schedule.endDate = pickedDate;
}

-(IBAction)showTutorial
{
    [HATutorialVC revokeTutorialCompletion];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
