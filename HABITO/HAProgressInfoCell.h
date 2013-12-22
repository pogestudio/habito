//
//  HAProgressInfoCell.h
//  HABITO
//
//  Created by CAwesome on 2013-12-16.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HAChallenge.h"

@interface HAProgressInfoCell : UITableViewCell

@property (retain) IBOutlet UILabel *userName;
@property (retain) IBOutlet UILabel *opponentName;
@property (retain) IBOutlet UILabel *infoLabel;
@property (retain) IBOutlet UILabel *userAmountDone;
@property (retain) IBOutlet UILabel *opponentAmountDone;

@property (retain) IBOutlet UIImageView *userImage;
@property (retain) IBOutlet UIImageView *middleImage;
@property (retain) IBOutlet UIImageView *opponentImage;

-(void)setUpCellForChallenge:(HAChallenge*)theChallenge;

@end
