//
//  HAChallengeRequest.m
//  HABITO
//
//  Created by CAwesome on 2013-12-30.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>
#import "HAChallengeRequest.h"
#import "HAAppDelegate.h"
#import "HAPushManager.h"

@implementation HAChallengeRequest

@dynamic bet;
@dynamic sender;
@dynamic receiver;
@dynamic challenge;

@dynamic requestIsAnswered;
@dynamic receiverAccepted;


+ (NSString *)parseClassName {
    return @"ChallengeRequest";
}

-(void)receiverAcceptedChallenge
{
    self.challenge.isActive = YES;
    [self.challenge saveAndUpdateTableViewWhenDone];
    
    self.requestIsAnswered = YES;
    self.receiverAccepted = YES;
    [self saveInBackground];
    
    NSString *pushMessage = [NSString stringWithFormat:@"%@: I just accepted '%@'. Game on!",[PFUser currentUser].username,self.challenge.action];
    [[HAPushManager sharedManager] sendPushToUser:self.sender withMessage:pushMessage];
}

-(void)receiverDeniedChallenge
{
    self.requestIsAnswered = YES;
    self.receiverAccepted = NO;
    [self saveInBackground];
    
    NSString *pushMessage = [NSString stringWithFormat:@"%@: I don't want to do '%@'. I think I'm a little bit too lazy!",[PFUser currentUser].username,self.challenge.action];
    [[HAPushManager sharedManager] sendPushToUser:self.sender withMessage:pushMessage];
}

@end
