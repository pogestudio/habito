//
//  HASchedule.m
//  HABITO
//
//  Created by CAwesome on 2013-12-14.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import "HASchedule.h"
#import <Parse/PFObject+Subclass.h>
#import "NSDate+Compare.h"

static NSDateFormatter *weekDayFormatter;

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

-(NSArray*)allDatesThatShouldBePlanned
{
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 1;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];

    
    NSDate *movingDate = [NSDate date];
    NSMutableArray *allDatesToAdd = [NSMutableArray array];
    while ([movingDate isEarlierThan:self.endDate]) {
        if([self dateShouldBeScheduled:movingDate])
        {
            [allDatesToAdd addObject:movingDate]; //add
        }
        movingDate  = [theCalendar dateByAddingComponents:dayComponent toDate:movingDate options:0]; //create new copy
    }
    return allDatesToAdd;
    
}

-(BOOL)dateShouldBeScheduled:(NSDate*)dateToTry
{
    if(weekDayFormatter == nil)
    {
        weekDayFormatter= [[NSDateFormatter alloc] init];
        [weekDayFormatter setDateFormat:@"e"];
    }

	NSInteger weekdayNumber = [[weekDayFormatter stringFromDate:dateToTry] integerValue];
	//NSLog(@"Day of Week: %ld for date> %@",(long)weekdayNumber, dateToTry);
    BOOL shouldSceheduleOnDay = NO;
    switch (weekdayNumber) {
        case 1:
        {
            shouldSceheduleOnDay = self.monday;
            break;
        }
        case 2:
        {
            shouldSceheduleOnDay = self.tuesday;
            break;
        }
        case 3:
        {
            shouldSceheduleOnDay = self.wednesday;
            break;
        }
        case 4:
        {
            shouldSceheduleOnDay = self.thursday;
            break;
        }
        case 5:
        {
            shouldSceheduleOnDay = self.friday;
            break;
        }
        case 6:
        {
            shouldSceheduleOnDay = self.saturday;
            break;
        }
        case 7:
        {
            shouldSceheduleOnDay = self.sunday;
            break;
        }
            
        default:
            NSAssert(nil, @"got more weekdays than it should be. something weird in haschedule");
            break;
    }
    
    return shouldSceheduleOnDay;

}

@end
