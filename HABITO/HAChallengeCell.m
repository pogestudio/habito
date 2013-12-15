//
//  HAChallengeCell.m
//  HABITO
//
//  Created by CAwesome on 2013-12-15.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import "HAChallengeCell.h"

@implementation HAChallengeCell

-(void)setUpForObject:(PFObject *)theObject
{
    self.theAction.text = theObject[@"action"];
    PFObject *opponent = theObject[@"opponent"];
    [opponent fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        self.theOpponent.text = object[@"username"];
    }];
}

@end
