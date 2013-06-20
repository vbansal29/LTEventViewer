//
//  EventDataController.h
//  TempleVersion2
//
//  Created by Vidya on 3/11/13.
//  Copyright (c) 2013 Vidya. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Event;

@interface EventDataController : NSObject


@property (nonatomic, strong) NSMutableArray *masterListOfEvents;


-(NSMutableArray *)loadEventsFromFileURL:(NSURL *)eventsFileURL;
-(void)initializeMasterListOfEventsFrom:(NSArray *)csvArrayOfEvents;

- (NSUInteger)countOfList;
- (Event *)eventInListAtIndex:(NSUInteger)theIndex;
- (void)addEventWithInfo:(NSDictionary *)eventInfo;

@end
