//
//  HASettingsVC.h
//  HABITO
//
//  Created by CAwesome on 2013-12-22.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HADatePicker.h"
@interface HASettingsVC : UITableViewController <WantDatePicked>

@property (retain) IBOutlet UILabel *reminderDate;

@end
