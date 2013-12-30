//
//  HAChallengeRequestHandler.h
//  HABITO
//
//  Created by CAwesome on 2013-12-30.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HAChallenge;
@class HAChallengeRequest;

@interface HAChallengeRequestHandler : NSObject <UIAlertViewDelegate>

@property (retain) NSMutableArray *alreadyAskedRequestIds;
@property (retain) HAChallengeRequest* requestWhichIsBeingCurrentlyAsked;;

+(HAChallengeRequestHandler*)sharedHandler;
-(void)createRequestForNewChallenge:(HAChallenge*)theChallenge;

-(void)loadRequestsAndPopInView;

@end
