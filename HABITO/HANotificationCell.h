//
//  HANotificationCell.h
//  HABITO
//
//  Created by CAwesome on 2013-12-20.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  HAMessage;

@interface HANotificationCell : UITableViewCell

@property (retain) IBOutlet UILabel *senderReceiver;
@property (retain) IBOutlet UILabel *message;
@property (retain) IBOutlet UILabel *dateTime;
@property (retain) HAMessage *theMessage;

-(void)setUpCellForMessage:(HAMessage*)message;

@end
