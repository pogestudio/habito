//
//  HAProgressCell.m
//  HABITO
//
//  Created by CAwesome on 2013-12-16.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import "HAProgressCell.h"

static NSDateFormatter *shortDateFormatter;

@implementation HAProgressCell

-(void)setUpCellForDate:(NSDate *)date userDid:(BOOL)userFinished opponentDid:(BOOL)opponentFinished
{
    NSAssert([date isKindOfClass:[NSDate class]], @"wrong date class");
    self.dateLabel.text = [[self sharedFormatter] stringFromDate:date];
    
    
    NSString *finishedImage = @"checkmark";
    NSString *notFinishedImage = @"cross";
    NSString *userImageName = userFinished ? finishedImage : notFinishedImage;
    NSString *opponentImageName = opponentFinished ? finishedImage : notFinishedImage;
    [self.userImage setImage:[UIImage imageNamed:userImageName]];
    [self.opponentImage setImage:[UIImage imageNamed:opponentImageName]];
    
}

-(NSDateFormatter*)sharedFormatter
{
    if (!shortDateFormatter) {
        shortDateFormatter = [[NSDateFormatter alloc] init];
        [shortDateFormatter setDateFormat:@"d/M"];
    }
    return shortDateFormatter;
}

@end
