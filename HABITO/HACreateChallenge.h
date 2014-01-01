//
//  HACreateChallenge.h
//  HABITO
//
//  Created by CAwesome on 2013-12-14.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HADatePicker.h"
#import "HAFindHabitoUser.h"

#import "HAChallenge.h"

@interface HACreateChallenge : UITableViewController <WantDatePicked, FindHabitoUser,UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate>

//THE CHALLENGE
@property (strong, nonatomic) HAChallenge *theChallenge;
//@property (strong, nonatomic) HASchedule *theSchedule;

//THE INPUT FIELDS
@property (strong, nonatomic) IBOutlet UITextField * theAction;
@property (strong, nonatomic) IBOutlet UITextView * theBet;


//SCHEDULE
@property (strong, nonatomic) IBOutlet UISwitch *scheduleMon;
@property (strong, nonatomic) IBOutlet UISwitch *scheduleTue;
@property (strong, nonatomic) IBOutlet UISwitch *scheduleWed;
@property (strong, nonatomic) IBOutlet UISwitch *scheduleThu;
@property (strong, nonatomic) IBOutlet UISwitch *scheduleFri;
@property (strong, nonatomic) IBOutlet UISwitch *scheduleSat;
@property (strong, nonatomic) IBOutlet UISwitch *scheduleSun;

@property (strong, nonatomic) IBOutlet UILabel *pickedDateLabel;
@property (strong, nonatomic) IBOutlet UIButton *chosenOpponent;

@property (assign) BOOL weAreEditingEndDate;
@property (retain) IBOutlet UIDatePicker *endDatePicker;

@end
