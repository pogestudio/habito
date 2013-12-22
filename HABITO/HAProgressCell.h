//
//  HAProgressCell.h
//  HABITO
//
//  Created by CAwesome on 2013-12-16.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HAProgressCell : UITableViewCell

@property (retain) IBOutlet UILabel *dateLabel;
@property (retain) IBOutlet UIImageView *userImage;
@property (retain) IBOutlet UIImageView *opponentImage;

-(void)setUpCellForDate:(NSDate*)date userDid:(BOOL)userFinished opponentDid:(BOOL)opponentFinished;

@end
