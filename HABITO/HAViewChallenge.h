//
//  HAViewChallenge.h
//  HABITO
//
//  Created by CAwesome on 2013-12-15.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HAChallenge.h"

@interface HAViewChallenge : UITableViewController

@property (strong, nonatomic) HAChallenge *theChallenge;

@property (strong, nonatomic) IBOutlet UILabel *actionLabel;
@property (strong, nonatomic) IBOutlet UILabel *betLabel;
@property (strong, nonatomic) IBOutlet UILabel *opponentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *statusImage;

@end
