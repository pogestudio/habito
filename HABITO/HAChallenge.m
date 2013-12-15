//
//  HAChallenge.m
//  HABITO
//
//  Created by CAwesome on 2013-12-14.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import "HAChallenge.h"
#import <Parse/PFObject+Subclass.h>

@implementation HAChallenge

@dynamic action;
@dynamic theBet;
@dynamic opponentId;
@dynamic owner;
@dynamic winnerUserId;
@dynamic isActive;
@dynamic theSchedule;

+ (NSString *)parseClassName {
    return @"Challenge";
}


@end
