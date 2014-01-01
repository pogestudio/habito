//
//  HAMessage.m
//  HABITO
//
//  Created by CAwesome on 2013-12-19.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>

#import "HAMessage.h"
#import "HAChallenge.h"

@implementation HAMessage

@dynamic sender;
@dynamic challenge;
@dynamic message;
@dynamic sound;

+ (NSString *)parseClassName {
    return @"Message";
}


+(void)createMessageForChallenge:(HAChallenge*)challenge withMessage:(NSString*)message
{
    HAMessage *newMessage = [HAMessage object];
    newMessage.sender = [PFUser currentUser];
    newMessage.challenge = challenge;
    newMessage.message = message;
    [newMessage setDefaultMessageIfEmpty];
    
    
    int randomSlapNumber = arc4random() % 5;
    NSString *soundString = [NSString stringWithFormat:@"slap%d.aiff",randomSlapNumber];
//    [newMessage createPushNotificationWithSound:soundString];
    
    newMessage.sound = soundString;
    [newMessage saveInBackground];
    

}

-(void)createPushNotificationWithSound:(NSString *)sound;
{

    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.message, @"alert",
                          @"Increment", @"badge",
                          sound, @"sound",
                          [PFUser currentUser].username, @"sender",
                          
                          nil];
    
    NSTimeInterval interval = 60*60*24; // 2 days
    
    PFPush *push = [[PFPush alloc] init];
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"user" notEqualTo:[PFUser currentUser]];
    [pushQuery whereKey:@"channels" equalTo:[self.challenge channelName]];
    [push setQuery:pushQuery];
    [push setData:data];
    [push expireAfterTimeInterval:interval];
    [push sendPushInBackground];
}

-(void)setDefaultMessageIfEmpty
{
    if (self.message == nil || [self.message isEqualToString:@""])
    {
        self.message = @"Here is a slap so you can get going!";
    }

}

-(BOOL)messageIsFromCurrentUser
{
    NSString *senderId = self.sender.objectId;
    NSString *currentUserId = [PFUser currentUser].objectId;
    
    return [senderId isEqualToString:currentUserId];
}
@end
