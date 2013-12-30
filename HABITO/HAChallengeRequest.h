//
//  HAChallengeRequest.h
//  HABITO
//
//  Created by CAwesome on 2013-12-30.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import <Parse/Parse.h>
#import "HAChallenge.h"

@interface HAChallengeRequest : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@property (retain) NSString *bet;
@property (retain) PFUser *sender;
@property (retain) PFUser *receiver;
@property (retain) HAChallenge *challenge;

@property  BOOL requestIsAnswered;
@property  BOOL receiverAccepted;


-(void)receiverDeniedChallenge;
-(void)receiverAcceptedChallenge;

@end
