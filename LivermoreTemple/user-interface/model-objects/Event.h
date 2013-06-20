//
//  Event.h
//  LivermoreTemple
//
//  Created by Vidya on 5/14/13.
//  Copyright (c) 2013 Vidya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contact, SubEvent, Temple, ThithiAndDay;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * detailsPDFURL;
@property (nonatomic, retain) NSString * endDate;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSNumber * recurringMonthDay;
@property (nonatomic, retain) NSString * recurringType;
@property (nonatomic, retain) NSString * recurringWeekday;
@property (nonatomic, retain) NSString * startDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * venue;
@property (nonatomic, retain) NSString * startTime;
@property (nonatomic, retain) NSString * endTime;
@property (nonatomic, retain) Temple *belongsToTemple;
@property (nonatomic, retain) Contact *mainContact;
@property (nonatomic, retain) ThithiAndDay *specialDay;
@property (nonatomic, retain) NSSet *subEvents;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addSubEventsObject:(SubEvent *)value;
- (void)removeSubEventsObject:(SubEvent *)value;
- (void)addSubEvents:(NSSet *)values;
- (void)removeSubEvents:(NSSet *)values;

@end
