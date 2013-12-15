//
//  HADatePicker.m
//  HABITO
//
//  Created by CAwesome on 2013-12-14.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import "HADatePicker.h"


@implementation HADatePicker

-(IBAction)pickedDateIsDone
{
    [self.objectThatWantsDatePicked setPickedDate:[self.datePicker date]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
