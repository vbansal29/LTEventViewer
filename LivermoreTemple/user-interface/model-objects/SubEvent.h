//
//  SubEvent.h
//  LivermoreTemple
//
//  Created by Vidya on 5/14/13.
//  Copyright (c) 2013 Vidya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface SubEvent : NSManagedObject

@property (nonatomic, retain) NSString * endDate;
@property (nonatomic, retain) NSString * startDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * startTime;
@property (nonatomic, retain) NSString * endTime;
@property (nonatomic, retain) Event *mainEvent;

@end
