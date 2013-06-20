//
//  Pooja.h
//  LivermoreTemple
//
//  Created by Vidya on 5/14/13.
//  Copyright (c) 2013 Vidya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Temple;

@interface Pooja : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * recurringType;
@property (nonatomic, retain) NSString * recurringWeekday;
@property (nonatomic, retain) NSString * recurringMonthDay;
@property (nonatomic, retain) NSString * startTime;
@property (nonatomic, retain) NSString * endTime;
@property (nonatomic, retain) Temple *performedAtTemple;

@end
