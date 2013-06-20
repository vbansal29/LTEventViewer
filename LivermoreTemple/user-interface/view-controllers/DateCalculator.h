//
//  DateCalculator.h
//  TempleVersion2
//
//  Created by Vidya on 3/28/13.
//  Copyright (c) 2013 Vidya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateCalculator : NSObject

@property (nonatomic, strong) NSDate    *todayDate;
@property (nonatomic, strong) NSString  *todayDateStr;
@property (nonatomic, assign) NSUInteger todayYear;
@property (nonatomic, assign) NSUInteger todayMonth;
@property (nonatomic, assign) NSUInteger todayWeek;
@property (nonatomic, assign) NSUInteger todayWeekdayOrdinal;
@property (nonatomic, assign) NSUInteger todayWeekdayValue;
@property (nonatomic, assign) NSString  *todayWeekdayName;
@property (nonatomic, assign) NSUInteger todayDay;

-(NSString *)getDateStrFromDate:(NSDate *)date inDateFormat:(NSString *)dateFormat;

-(NSDate *) getDateFromDateStr:(NSString *)dateStr dateFormat:(NSString *)dateFormatStr withTimeStr:(NSString *)timeStr timeFormat:(NSString *)timeFormatStr ;

-(NSUInteger) getWeekdayValueForWeekdayName:(NSString * )weekdayName;
-(NSString *) getDateForWeekday:(NSString *)weekday;
-(NSString *) getDateForWeekday:(NSString *)weekday forWeekdayOrdinal:(NSUInteger)weekdayOrdinal forRecurringType:(NSString *)recurringType;

-(NSInteger) daysBetweenDate:(NSDate *)firstDate andDate:(NSDate *)secondDate;
-(NSInteger) checkDateIfTodayOrPastOrFuture:(NSString *)dateString;

-(NSString *) getWeekdayNameForDate:(NSDate *)date;
-(NSString *) getDayInMonthFromDate:(NSDate *)date;
-(NSString *) getDayInMonthWithSuffixFromDate:(NSDate *)date;
-(NSString *) getTimeFromDate:(NSDate *)date;



//Date Compare Functions


/*
-(NSDate *) getDateFromDateComponentsWithYear:(NSUInteger)year withMonth:(NSUInteger)month withWeekday:(NSUInteger)weekday withWeekdayOrdinal:(NSUInteger)weekdayOrdinal;

-(NSUInteger) getWeekdayValueForWeekdayName:(NSString *)weekdayName;
-(NSUInteger) getNextMonth:(NSUInteger)currentMonth;
-(NSString *) getNextMonthName:(NSUInteger)currentMonth;
*/

@end
