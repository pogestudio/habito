//
//  HASettings.h
//  HABITO
//
//  Created by CAwesome on 2013-12-14.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import <Parse/Parse.h>

@interface HASettings : PFObject <PFSubclassing>

@property BOOL receiveReminders;
@property BOOL receiveMotivation;
@property BOOL wednesday;
@property BOOL thursday;
@property BOOL friday;
@property BOOL saturday;
@property BOOL sunday;
@property (retain) NSDate *endDate;

+ (NSString *)parseClassName;
@end
