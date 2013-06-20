//
//  ThithiAndDay.h
//  LivermoreTemple
//
//  Created by Vidya on 5/15/13.
//  Copyright (c) 2013 Vidya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface ThithiAndDay : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * nakshatra;
@property (nonatomic, retain) NSString * rahukalam;
@property (nonatomic, retain) NSString * specialDay;
@property (nonatomic, retain) NSString * thithi;
@property (nonatomic, retain) Event *specialEventCelebrated;

@end
