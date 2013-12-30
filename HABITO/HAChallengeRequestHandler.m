//
//  HAChallengeRequestHandler.m
//  HABITO
//
//  Created by CAwesome on 2013-12-30.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import "HAChallengeRequestHandler.h"
#import "HAChallengeRequest.h"
#import "HAChallenge.h"
#import "NSDate-Utilities.h"
#import "HAPushManager.h"

static HAChallengeRequestHandler *_sharedHandler;

@implementation HAChallengeRequestHandler

+(HAChallengeRequestHandler*)sharedHandler
{
    if(!_sharedHandler)
    {
        _sharedHandler = [[HAChallengeRequestHandler alloc] init];
        _sharedHandler.alreadyAskedRequestIds = [[NSMutableArray alloc] init];
    }
    
    return _sharedHandler;
}

-(void)createRequestForNewChallenge:(HAChallenge *)theChallenge
{
    HAChallengeRequest *newRequest = [HAChallengeRequest object];
    newRequest.sender = [PFUser currentUser];
    newRequest.receiver = theChallenge.challenged;
    newRequest.requestIsAnswered = NO;
    newRequest.receiverAccepted = NO;
    newRequest.challenge = theChallenge;
    [newRequest saveInBackground];
    NSString *pushMessage = [NSString stringWithFormat:@"%@ wants to start a habit with you! The invite will pop up soon with more details.",newRequest.sender.username];
    [[HAPushManager sharedManager] sendPushToUser:newRequest.receiver withMessage:pushMessage];
    
}

-(void)loadRequestsAndPopInView
{
    PFQuery *query = [PFQuery queryWithClassName:@"ChallengeRequest"];
    [query whereKey:@"receiver" equalTo:[PFUser currentUser]];
    [query whereKey:@"requestIsAnswered" equalTo:@NO];
    [query includeKey:@"challenge"];
    [query includeKey:@"challenge.schedule"];
    [query includeKey:@"sender"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            
            // Do something with the found objects
            for (HAChallengeRequest *object in objects) {
                NSLog(@"%@", object.objectId);
                [self popAlertViewForChallenge:object];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)popAlertViewForChallenge:(HAChallengeRequest*)request
{
    
    //if we've answered it already, don't bother
    if ([self.alreadyAskedRequestIds indexOfObject:request.objectId] != NSNotFound) {
        return;
    }
    
    //if we're busy, ask again in 5 sec.
    if (self.requestWhichIsBeingCurrentlyAsked != nil) {
        [self performSelector:@selector(popAlertViewForChallenge:) withObject:request afterDelay:5];
        return;
    }
    
    self.requestWhichIsBeingCurrentlyAsked = request;
    NSLog(@"want to ask shit for... %@",request);
    NSString *theMessage = [NSString stringWithFormat:@"%@ wants to start: %@, with you. It goes on until %@, and if you lose the bet is: %@. Do you accept?", request.sender.username, request.challenge.action, [request.challenge.schedule.endDate descriptionOfDateAsMonthAndDay],request.challenge.bet];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Habit!"
                                                    message:theMessage
                                                   delegate:self
                                          cancelButtonTitle:@"No, I am lazy"
                                          otherButtonTitles:@"OH YEAH!", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 ) {
        [self.requestWhichIsBeingCurrentlyAsked receiverDeniedChallenge];
    } else if  (buttonIndex == 1)
    {
        [self.requestWhichIsBeingCurrentlyAsked receiverAcceptedChallenge];
    }
    [self.alreadyAskedRequestIds addObject:self.requestWhichIsBeingCurrentlyAsked.objectId];
    self.requestWhichIsBeingCurrentlyAsked = nil;
    
    
}
@end
