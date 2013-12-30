//
//  HADatePicker.m
//  HABITO
//
//  Created by CAwesome on 2013-12-14.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import "HADatePicker.h"
#import "NSDate-Utilities.h"

@implementation HADatePicker

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.datePicker addTarget:self action:@selector(dateDidChange:) forControlEvents:UIControlEventValueChanged];
}

-(void)dateDidChange:(id)sender
{
    NSAssert([sender isKindOfClass:[UIDatePicker class]], @"wrong class in date shit!!");
    NSDate *selectedDate = self.datePicker.date;
    
    NSDate *maxDate = [NSDate dateWithTimeIntervalSinceNow:self.maxAmountOfDaysInFuture * 24 * 3600];
    
    if ([selectedDate isEarlierThanDate:[NSDate date]]) {
        self.datePicker.date = [NSDate date];
    }
    
    if ([selectedDate isLaterThanDate:maxDate]) {
        self.datePicker.date = maxDate;
    }
    
    
}

-(IBAction)pickedDateIsDone
{
    [self.objectThatWantsDatePicked setPickedDate:[self.datePicker date]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
