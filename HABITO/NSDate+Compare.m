//
//  NSDate+Compare.m
//  Planner
//
//  Created by Carl-Arvid Ewerbring on 10/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDate+Compare.h"

@implementation NSDate (Compare)

-(BOOL) isLaterThanOrEqualTo:(NSDate*)date {
    return !([self compare:date] == NSOrderedAscending);
}

-(BOOL) isEarlierThanOrEqualTo:(NSDate*)date {
    return !([self compare:date] == NSOrderedDescending);
}
-(BOOL) isLaterThan:(NSDate*)date {
    return ([self compare:date] == NSOrderedDescending);
    
}
-(BOOL) isEarlierThan:(NSDate*)date {
    return ([self compare:date] == NSOrderedAscending);
}

-(BOOL)isToday
{
    NSDate *today = nil;
    NSDate *beginningOfOtherDate = nil;
    
    NSDate *now = [NSDate date];
    [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&today interval:NULL forDate:now];
    [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&beginningOfOtherDate interval:NULL forDate:self];
    
    if([today compare:beginningOfOtherDate] == NSOrderedSame) {
        return YES;
    } else {
        return NO;
    }
}


-(BOOL)isSameDayAs:(NSDate*)anotherDate
{
    if(!anotherDate)
        return NO;
    
    NSDate *today = nil;
    NSDate *beginningOfOtherDate = nil;
    
    [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&today interval:NULL forDate:self];
    [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&beginningOfOtherDate interval:NULL forDate:anotherDate];
    
    if([today compare:beginningOfOtherDate] == NSOrderedSame) {
        return YES;
    } else {
        return NO;
    }
}



@end