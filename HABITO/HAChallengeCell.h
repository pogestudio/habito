//
//  HAChallengeCell.h
//  HABITO
//
//  Created by CAwesome on 2013-12-15.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import <Parse/Parse.h>

#import "HAChallenge.h"
@interface HAChallengeCell : PFTableViewCell

@property (retain) IBOutlet UILabel *theAction;
@property (retain) IBOutlet UILabel *theOpponent;
@property (retain) IBOutlet UIImageView *opponentStatus;
@property (retain) IBOutlet UIImageView *ownerStatus;
@property (weak) HAChallenge *theChallenge;


-(void)setUpForObject:(HAChallenge*)challenge;

@end
