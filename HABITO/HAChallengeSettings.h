//
//  HAChallengeSettings.h
//  HABITO
//
//  Created by CAwesome on 2013-12-29.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HAChallenge;

@interface HAChallengeSettings : UITableViewController <UIAlertViewDelegate,UIPickerViewDelegate>

@property (retain) HAChallenge *theChallenge;
@property (retain) IBOutlet UILabel *dateLabel;
@property (retain) IBOutlet UISwitch *reminderSwitch;

@property (assign) BOOL weAreEditingStartTime;

@end
