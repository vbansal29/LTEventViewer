//
//  DateCalculator.m
//  TempleVersion2
//
//  Created by Vidya on 3/28/13.
//  Copyright (c) 2013 Vidya. All rights reserved.
//


#import "DateCalculator.h"
#import "Header.h"


@implementation DateCalculator

- (id)init {
    
    self = [super init];
    if (self)  {
        NSDate *date = [[NSDate alloc] init];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *dateComponents = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit| NSWeekCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfYearCalendarUnit ) fromDate:date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        
        // Initialize all the today date components
        
        _todayDateStr = [formatter stringFromDate:date];
        _todayDate = [formatter dateFromString:_todayDateStr];
        _todayYear = dateComponents.year;
        _todayMonth = dateComponents.month;
        _todayWeek = dateComponents.week;
        _todayWeekdayOrdinal = dateComponents.weekdayOrdinal;
        _todayDay = dateComponents.day;
        _todayWeekdayValue = dateComponents.weekday;
        NSArray *weekdayNames = [NSArray arrayWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday",nil];
        _todayWeekdayName = [weekdayNames objectAtIndex:_todayWeekdayValue - 1];
    }
    return self;
}

//1
-(NSString *)getDateStrFromDate:(NSDate *)date inDateFormat:(NSString *)dateFormat {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    NSString *dateStr = [formatter stringFromDate:date];
    
    return dateStr;
}

//2

// This function assumes that the date part is not empty. Changes the format of date based on whether the time component is empty or not

-(NSDate *) getDateFromDateStr:(NSString *)dateStr dateFormat:(NSString *)dateFormatStr withTimeStr:(NSString *)timeStr timeFormat:(NSString *)timeFormatStr {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([timeStr isEqualToString:@""]) {
        [formatter setDateFormat:dateFormatStr];
        NSDate *date = [formatter dateFromString:dateStr];
        return date;
    } else {
        NSString *tempStr = [dateFormatStr stringByAppendingString:@" "];
        tempStr = [tempStr stringByAppendingString:timeFormatStr];
        [formatter setDateFormat:tempStr];
        tempStr = [dateStr stringByAppendingString:@" "];
        tempStr = [tempStr stringByAppendingString:timeStr];
        NSDate *date = [formatter dateFromString:tempStr];
        return date;
    }
    
    
}

// 3

-(NSUInteger) getWeekdayValueForWeekdayName:(NSString * )weekdayName
{
    NSArray *arrayOfWeekdayNames = [NSArray arrayWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday",nil];
    NSUInteger weekdayValue =  [arrayOfWeekdayNames indexOfObject:weekdayName] + 1;
    
    return weekdayValue;
}

// 4

-(NSString *) getDateForWeekday:(NSString *)weekday{
    
    if ([self.todayWeekdayName caseInsensitiveCompare:weekday] == NSOrderedSame) {
        NSString *dateStr = self.todayDateStr;
        return dateStr;
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *dateComponentsToAdd = [[NSDateComponents alloc] init];
        NSUInteger nextWeekday = [self getWeekdayValueForWeekdayName:weekday];
        if (self.todayWeekdayValue > nextWeekday) {
            dateComponentsToAdd.week = 1;
        }
        dateComponentsToAdd.weekday = nextWeekday - self.todayWeekdayValue;
        NSDate *nextDate = [gregorian dateByAddingComponents:dateComponentsToAdd toDate:self.todayDate options:0];
        NSString *dateStr = [formatter stringFromDate:nextDate];
        return dateStr;
    }
}

//5

-(NSString *) getDateForWeekday:(NSString *)weekday forWeekdayOrdinal:(NSUInteger)weekdayOrdinal forRecurringType:(NSString *)recurringType {

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponentsToAdjustWeekday = [[NSDateComponents alloc] init];
    
    // Adjust the weekday
    
    NSDateComponents *todayDateComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:self.todayDate];
    NSUInteger weekdayValue = [self getWeekdayValueForWeekdayName:weekday];
    NSInteger weekdayDifference = weekdayValue - todayDateComponents.weekday;
    if (weekdayDifference <=0 ) {
        weekdayDifference += 7;
    }
    [dateComponentsToAdjustWeekday setDay:weekdayDifference];
    NSDate *dateWithWeekdayAdjusted = [gregorian dateByAddingComponents:dateComponentsToAdjustWeekday toDate:self.todayDate options:0];
    
    //Adjust the WeekdayOrdinal
    
    NSDateComponents *weekdayAdjustedDateComponents = [gregorian components:(NSMonthCalendarUnit |NSWeekdayOrdinalCalendarUnit) fromDate:dateWithWeekdayAdjusted];
    NSInteger differenceInWeekdayOrdinal = weekdayOrdinal - weekdayAdjustedDateComponents.weekdayOrdinal;
    NSInteger nextWeekdayOrdinalForBiWeekly = weekdayOrdinal + 2;
    NSInteger nextDifferenceInWeekdayOrdinal = nextWeekdayOrdinalForBiWeekly - weekdayAdjustedDateComponents.weekdayOrdinal;
    
    NSString *startDateStr = @"";
    if ((differenceInWeekdayOrdinal == 0) || (([recurringType isEqualToString:@"Biweekly"]) && (nextDifferenceInWeekdayOrdinal == 0))) {
        startDateStr = [self getDateStrFromDate:dateWithWeekdayAdjusted inDateFormat:@"MM/dd/yyyy"];
    } else if (differenceInWeekdayOrdinal > 0) {
        NSDateComponents *dateComponentsToAdjustOrdinal = [[NSDateComponents alloc] init];
        NSInteger daysToAdd = 7 * differenceInWeekdayOrdinal;
        [dateComponentsToAdjustOrdinal setDay:daysToAdd];
        NSDate *startDate = [gregorian dateByAddingComponents:dateComponentsToAdjustOrdinal toDate:dateWithWeekdayAdjusted options:0];
        startDateStr = [self getDateStrFromDate:startDate inDateFormat:@"MM/dd/yyyy"];
    } else if (differenceInWeekdayOrdinal < 0) {
        if (([recurringType isEqualToString:@"Biweekly"]) && (nextDifferenceInWeekdayOrdinal > 0)) {
            NSInteger daysToAdd = 7 * nextDifferenceInWeekdayOrdinal;
            NSDateComponents *dateComponentsToAdjustOrdinal = [[NSDateComponents alloc] init];
            [dateComponentsToAdjustOrdinal setDay:daysToAdd];
            NSDate *startDate = [gregorian dateByAddingComponents:dateComponentsToAdjustOrdinal toDate:dateWithWeekdayAdjusted options:0];
            startDateStr = [self getDateStrFromDate:startDate inDateFormat:@"MM/dd/yyyy"];
        } else {
            // Adjust the Weekdate to increment by one month and get a temp date
            
            NSDateComponents *tempDateComponents = [[NSDateComponents alloc] init];
            [tempDateComponents setMonth:1];
            NSDate *tempDate = [gregorian dateByAddingComponents:tempDateComponents toDate:self.todayDate options:0];
            
            // Extract Year, Month, from above temp date and set the weekday and weekday ordinal to get weekday ordinal adjusted date
            
            tempDateComponents = [gregorian components:(NSYearCalendarUnit| NSMonthCalendarUnit |NSWeekdayOrdinalCalendarUnit) fromDate:tempDate];
            NSDateComponents *dateComponentsToAdjustOrdinal = [[NSDateComponents alloc] init];
            [dateComponentsToAdjustOrdinal setYear:tempDateComponents.year];
            [dateComponentsToAdjustOrdinal setMonth:tempDateComponents.month];
            [dateComponentsToAdjustOrdinal setWeekday:weekdayValue];
            [dateComponentsToAdjustOrdinal setWeekdayOrdinal:weekdayOrdinal];
            
            NSDate *startDate = [gregorian dateFromComponents:dateComponentsToAdjustOrdinal];
            startDateStr = [self getDateStrFromDate:startDate inDateFormat:@"MM/dd/yyyy"];
        }
    }
    /* Flow of code below: Check for WeekOrdinals compared with today's weekordinal
                                                 , if equal then
                                                   if equal + 2 for Biweekly
                                                   if < 
                                                   if >
      within each if check for weekday 
     */
    /*
    NSLog(@" weekdayOrdinal = %d, today weekday ordinal = %d", weekOrdinal, self.todayWeekdayOrdinal);
    if (self.todayWeekdayOrdinal == weekOrdinal) {
        NSLog(@"test");
        if ([self.todayWeekdayName caseInsensitiveCompare:weekday] == NSOrderedSame) {
            dateStr = self.todayDateStr;
        } else if (self.todayWeekdayValue < weekdayValue) {
            NSLog(@"test");
            startDateComponents.weekday = weekdayValue;
            startDateComponents.weekdayOrdinal = weekOrdinal;
            startDateComponents.month = self.todayMonth;
            startDateComponents.year = self.todayYear;
            NSDate *nextDate = [gregorian dateFromComponents:startDateComponents];
            dateStr = [self getDateStrFromDate:nextDate inDateFormat:@"MM/dd/yyyy"];
        } else {
            startDateComponents.weekday = weekdayValue;
            if ([recurringType isEqualToString:@"Biweekly"]) {
                startDateComponents.weekdayOrdinal = weekOrdinal + 2;
            } else {
                startDateComponents.weekdayOrdinal = weekOrdinal;
            }
            if ([recurringType isEqualToString:@"Monthly"]) {
                if (self.todayMonth == kdateComponentValueForDecemberMonth) {// is month of december
                    startDateComponents.month = 1;
                    startDateComponents.year = self.todayYear + 1;
                } else {
                    startDateComponents.month = self.todayMonth + 1;
                    startDateComponents.year = self.todayYear;
                }
            } else {
                startDateComponents.month = self.todayMonth;
                startDateComponents.year = self.todayYear;
            }
            NSDate *nextDate = [gregorian dateFromComponents:startDateComponents];
            dateStr = [self getDateStrFromDate:nextDate inDateFormat:@"MM/dd/yyyy"];
        }
    } else if ((self.todayWeekdayOrdinal == weekOrdinal + 2) && ([recurringType isEqualToString:@"Biweekly"])) {
        
        startDateComponents.weekday = weekdayValue;
        startDateComponents.weekdayOrdinal = weekOrdinal;
        startDateComponents.month = self.todayMonth;
        startDateComponents.year = self.todayYear;
        NSDate *nextDate = [gregorian dateFromComponents:startDateComponents];
        dateStr = [self getDateStrFromDate:nextDate inDateFormat:@"MM/dd/yyyy"];
    } else if (self.todayWeekdayOrdinal < weekOrdinal) {
        startDateComponents.weekday = weekdayValue;
        startDateComponents.weekdayOrdinal = weekOrdinal;
        startDateComponents.month = self.todayMonth;
        startDateComponents.year = self.todayYear;
        NSDate *nextDate = [gregorian dateFromComponents:startDateComponents];
        dateStr = [self getDateStrFromDate:nextDate inDateFormat:@"MM/dd/yyyy"];
    } else if (self.todayWeekdayOrdinal > weekOrdinal) {
        startDateComponents.weekday = weekdayValue;
        startDateComponents.weekdayOrdinal = weekOrdinal;
        if ((([recurringType isEqualToString:@"Biweekly"]) && (self.todayWeekdayOrdinal > weekOrdinal + 2)) || ([recurringType isEqualToString:@"Monthly"])) {
            // increment the month and if it is the last month increment the year also
            if (self.todayMonth == 12) {// is month of december
                NSLog(@"testing the decemeber month");
                startDateComponents.month = 1;
                startDateComponents.year = self.todayYear + 1;
            } else {
                startDateComponents.month = self.todayMonth + 1;
                startDateComponents.year = self.todayYear;
            }
        } else {
            startDateComponents.month = self.todayMonth;
            startDateComponents.year = self.todayYear;
        }
        NSDate *nextDate = [gregorian dateFromComponents:startDateComponents];
        dateStr = [self getDateStrFromDate:nextDate inDateFormat:@"MM/dd/yyyy"];
    }*/
    return startDateStr;
}


//6
-(NSInteger) daysBetweenDate:(NSDate *)firstDate andDate:(NSDate *)secondDate {
    
    
    //NSLog(@"firstDate = %@, @seconddate = %@", firstDate, secondDate);
    NSInteger interval = [[[NSCalendar currentCalendar] components: NSDayCalendarUnit
                                                        fromDate: firstDate
                                                          toDate: secondDate
                                                         options: 0] day];
    return interval;
}

//7 Returns the weekday name for a date

-(NSString *) getWeekdayNameForDate:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEEE";
    NSString *weekDayName = [[formatter stringFromDate:date] capitalizedString];
    return weekDayName;
}

//8 Retuns the day of the month of a date.

-(NSString *) getDayInMonthFromDate:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd";
    NSString *dayInMonthStr = [formatter stringFromDate:date];
    return dayInMonthStr;
}

//9 Returns the day of month with suffix st, nd, rd, th

-(NSString *) getDayInMonthWithSuffixFromDate:(NSDate *)date {
    
    NSString *dayInMonth = [self getDayInMonthFromDate:date];
    
    NSString *suffix_string = @"|st|nd|rd|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|st|nd|rd|th|th|th|th|th|th|th|st";
    NSArray *suffixes = [suffix_string componentsSeparatedByString: @"|"];
    NSString *suffix = [suffixes objectAtIndex:[dayInMonth integerValue] - 1];
    NSString *dayInMonthWithSuffix  = [dayInMonth stringByAppendingString:suffix];
    return dayInMonthWithSuffix;
}

// 10 Returns the time portion of Date

-(NSString *) getTimeFromDate:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"h:mm a";
    NSString *timeStr = [formatter stringFromDate:date];
    return timeStr;
}

// 11 check if date is today / in past / in future

-(NSInteger) checkDateIfTodayOrPastOrFuture:(NSString *)dateString {
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    NSDate *datePassedByCallingFunction = [df dateFromString:dateString];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *todayDateComponents = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:self.todayDate];
    NSDate *todayDate = [calendar dateFromComponents:todayDateComponents];
    NSDateComponents *datePassedByCallingFunctionDateComponents = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:datePassedByCallingFunction];
    NSDate *compareWithDate = [calendar dateFromComponents:datePassedByCallingFunctionDateComponents];

    NSInteger check;
    if ([todayDate compare:compareWithDate] == NSOrderedSame) {
        check = 0;
    } else if ([todayDate compare:compareWithDate] == NSOrderedAscending) {
        check = 1;
    } else if ([todayDate compare:compareWithDate] == NSOrderedDescending) {
        check = -1;
    } else {
        check = 0;
        NSLog(@"error in comparing date");
    }
    return check;
}
@end
