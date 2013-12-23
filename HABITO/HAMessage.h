//
//  HAMessage.h
//  HABITO
//
//  Created by CAwesome on 2013-12-19.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import <Parse/Parse.h>
@class HAChallenge;

@interface HAMessage : PFObject <PFSubclassing>

+ (NSString *)parseClassName;


@property (retain) PFUser *sender;
@property (retain) HAChallenge *challenge;
@property (retain) NSString *message;
@property (retain) NSString *sound;

+(void)createMessageForChallenge:(HAChallenge*)challenge withMessage:(NSString*)message;
-(BOOL)messageIsFromCurrentUser;

@end
