//
//  HASchedule.m
//  HABITO
//
//  Created by CAwesome on 2013-12-14.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import "HASchedule.h"
#import <Parse/PFObject+Subclass.h>


@implementation HASchedule

@dynamic monday;
@dynamic tuesday;
@dynamic wednesday;
@dynamic thursday;
@dynamic friday;
@dynamic saturday;
@dynamic sunday;
@dynamic endDate;

+ (NSString *)parseClassName {
    return @"Schedule";
}

@end
