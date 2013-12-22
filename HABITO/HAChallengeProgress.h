//
//  HAChallangeProgress.h
//  HABITO
//
//  Created by CAwesome on 2013-12-16.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HAChallenge.h"

@interface HAChallengeProgress : UITableViewController

@property (retain) HAChallenge *theChallenge;
@property (retain) NSArray *plannedDatesToShow;

@end
