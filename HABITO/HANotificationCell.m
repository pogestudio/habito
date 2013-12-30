//
//  HANotificationCell.m
//  HABITO
//
//  Created by CAwesome on 2013-12-20.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import "HANotificationCell.h"
#import "HAMessage.h"
#import "HAChallenge.h"

static NSDateFormatter *_dateFormatter;

@implementation HANotificationCell

-(void)prepareForReuse
{
    [super prepareForReuse];
    
}

-(void)setUpCellForMessage:(HAMessage *)message
{
    self.theMessage = message;
    [self fillInValues];
    [self layoutLabels];
    [self resizeCell];
    
}

-(void)resizeCell
{
    CGFloat yPadding = 5;
    CGFloat newHeight = self.dateTime.frame.origin.y + self.dateTime.frame.size.height + yPadding;
    CGRect newFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, newHeight);
    self.frame = newFrame;
}

-(void)fillInValues
{
    self.message.text = self.theMessage.message;
    self.dateTime.text = [[self sharedFormatter] stringFromDate:self.theMessage.createdAt];
    NSString *userNameBet = @"";
    if (self.theMessage.sender != nil && ![self.theMessage.sender.objectId isEqualToString: [PFUser currentUser].objectId]) //if we sent it, dont show our username.
    {
        userNameBet = [NSString stringWithFormat:@"%@ - ",self.theMessage.sender.username];
    }
    self.senderReceiver.text = [NSString stringWithFormat:@"%@%@",userNameBet, self.theMessage.challenge.action];
}

-(void)layoutLabels
{
    CGFloat xPadding = 10;
    CGFloat yPadding = 5;
    CGFloat cellWidthFractionForLabels = 0.7;
    CGFloat labelWidth = self.frame.size.width * cellWidthFractionForLabels;
    
    //layout top frame
    CGFloat xPositionOfLabels = xPadding;
    NSTextAlignment suitableAlignment;
    if ([self.theMessage messageIsFromCurrentUser]) {
        suitableAlignment = NSTextAlignmentRight;
        xPositionOfLabels = self.frame.size.width - labelWidth - xPadding;
    } else {
        suitableAlignment = NSTextAlignmentLeft;
    }
    
    
    self.message.textAlignment = suitableAlignment;
    self.senderReceiver.textAlignment = suitableAlignment;
    self.dateTime.textAlignment = suitableAlignment;
    
    
    CGFloat yPosForSenderReceiver = yPadding;
    CGFloat yPosForMsg = yPadding * 2 + self.senderReceiver.frame.size.height;
    CGSize newSizeForMsg = [self calculatedSizeForLabel:self.message];
    
    
    //TOPFRAME
    self.senderReceiver.frame = CGRectMake(xPositionOfLabels,
                                           yPosForSenderReceiver,
                                           labelWidth,
                                           self.senderReceiver.frame.size.height);
    //MESSAGE FRAME
    self.message.frame = CGRectMake(xPositionOfLabels,
                                    yPosForMsg,
                                    labelWidth,
                                    ceilf(newSizeForMsg.height));
    [self.message sizeToFit];
    
    //position frame to be closer to the edge, if it's a single line.
    if ([self.theMessage messageIsFromCurrentUser]) {
        [self.message setFrame:CGRectMake(self.frame.size.width - (self.message.frame.size.width + xPadding),
                                          self.message.frame.origin.y,
                                          self.message.frame.size.width,
                                          self.message.frame.size.height)];
    }
    
    
    //DATETIMEFRAME
    CGFloat yPosForDate = yPosForMsg + self.message.frame.size.height + yPadding;
    self.dateTime.frame = CGRectMake(xPositionOfLabels,
                                     yPosForDate,
                                     labelWidth,
                                     self.dateTime.frame.size.height);
    
}

-(CGSize)calculatedSizeForLabel:(UILabel*)label
{
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:label.text
     attributes:@
     {
     NSFontAttributeName: label.font
     }];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){label.frame.size.width, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    return size;
}


-(CGFloat)heightForCell
{
    
    return 44;
}

-(NSDateFormatter*)sharedFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"dd/MM - HH:mm"];
    }
    return _dateFormatter;
}

@end
