//
//  EventDataController.m
//  TempleVersion2
//
//  Created by Vidya on 3/11/13.
//  Copyright (c) 2013 Vidya. All rights reserved.
//

#import "DateCalculator.h"
#import "Event.h"
#import "EventDataController.h"

@interface EventDataController()

@property (nonatomic, strong) DateCalculator *dateCalc;

@property (nonatomic, strong) NSMutableArray *arrayOfEventsWithIncompleteData;

@end

@implementation EventDataController

// to make sure the new array remains mutable
- (void)setMasterListOfEvents:(NSMutableArray *)newList {
    if (_masterListOfEvents != newList) {
        _masterListOfEvents = [newList mutableCopy];
    }
}

- (id)init {
    
    self = [super init];
    if (self)  {
        self.dateCalc = [[DateCalculator alloc] init];
        //[self initializeMasterListOfEvents];
    }
    return self;
}

#pragma public instance methods

- (NSUInteger)countOfList {
    return [self.masterListOfEvents count];
    
}
- (Event *)eventInListAtIndex:(NSUInteger)theIndex {
    return [self.masterListOfEvents objectAtIndex:theIndex];
}

- (void)addEventWithInfo:(NSDictionary *)eventInfo {
    [self.masterListOfEvents addObject:eventInfo];
}

-(NSMutableArray *)loadEventsFromFileURL:(NSString *)eventsFileURL {
    
    NSURL *dataURL = [[NSURL alloc] initWithString:eventsFileURL];
    NSData *data = [NSData dataWithContentsOfURL:dataURL];
    NSString* dataStr = [[NSString alloc] initWithData:data
                                              encoding:NSUTF8StringEncoding];
    
    NSArray *tempArray = [dataStr componentsSeparatedByString:@"\n"];
    NSMutableArray *tempArrayWithoutHeader = [NSMutableArray arrayWithArray:tempArray];
    [tempArrayWithoutHeader removeObjectAtIndex:0]; // remove header row
    return tempArrayWithoutHeader;
}

-(void)initializeMasterListOfEventsFrom:(NSArray *)csvArrayOfEvents {
    
    // Loads the data from downloaded file
    
    NSUInteger countOfEvents = [csvArrayOfEvents count];
    self.masterListOfEvents = [NSMutableArray arrayWithCapacity:countOfEvents];
    int eventIndex = 0;
    NSString *previousEventTitle = @"";
    while (eventIndex < countOfEvents) {
 
        //Verify Event read from file has all required data for it to be displayed to the user
        
        BOOL isValidEvent = [self verifyIfEventDataFromFileIsValid:[csvArrayOfEvents objectAtIndex:eventIndex]];
        
        // Continue to process if Event is Valid
        
        if (isValidEvent) {
            
            NSArray *arrayOfEventDetails = [[csvArrayOfEvents objectAtIndex:eventIndex]componentsSeparatedByString:@","];
            NSMutableDictionary *eventInfo = [[NSMutableDictionary alloc] init];
            [eventInfo setObject:[arrayOfEventDetails[0] capitalizedString] forKey:@"EVENT_NAME"];
  
            [eventInfo setObject:[arrayOfEventDetails[2] capitalizedString] forKey:@"EVENT_RECURRINGTYPE"];
            [eventInfo setObject:[arrayOfEventDetails[3] capitalizedString] forKey:@"EVENT_RECURRINGWEEKDAY"];
            [eventInfo setObject:arrayOfEventDetails[4] forKey:@"EVENT_RECURRINGMONTHDAY"];
            [eventInfo setObject:arrayOfEventDetails[5] forKey:@"EVENT_STARTDATE"];
            [eventInfo setObject:arrayOfEventDetails[6] forKey:@"EVENT_STARTTIME"];
            [eventInfo setObject:arrayOfEventDetails[7] forKey:@"EVENT_ENDDATE"];
            [eventInfo setObject:arrayOfEventDetails[8] forKey:@"EVENT_ENDTIME"];
            [eventInfo setObject:[arrayOfEventDetails[9] capitalizedString] forKey:@"EVENT_VENUE"];
            [eventInfo setObject:[arrayOfEventDetails[10] capitalizedString] forKey:@"EVENT_MAINCONTACT"];
            [eventInfo setObject:arrayOfEventDetails[11] forKey:@"EVENT_DETAILS_PDF_URL"];
  
            //copy the event image from web address and save it as binary data in core data
            
            NSData *eventImageData = [[NSData alloc] init];
            if ([arrayOfEventDetails[12] isEqualToString:@""]) {
                NSString *path = [[NSBundle mainBundle] pathForResource:@"temple" ofType:@".gif"];
                eventImageData = [NSData dataWithContentsOfFile:path];
            } else {
                NSString *path =  arrayOfEventDetails[12];
                NSURL *dataURL = [[NSURL alloc] initWithString:path];
                eventImageData = [NSData dataWithContentsOfURL:dataURL];
            }
            [eventInfo setObject:eventImageData forKey:@"EVENT_IMAGE"];
            
            // Add it Master List of Events
            
            [self addEventWithInfo:eventInfo];

            //if it is not last event check for sub Events and store in schedule array of Main Event
            previousEventTitle = [eventInfo objectForKey:@"EVENT_NAME"];
            if (!(countOfEvents == eventIndex + 1)) {
                NSArray *arrayOfNextEventDetails = [[csvArrayOfEvents objectAtIndex:eventIndex + 1] componentsSeparatedByString:@","];
                NSString *nextEventTitle = arrayOfNextEventDetails[0];
                NSMutableArray *tempArrayOfSubEvents = [[NSMutableArray alloc] init];
                while ([nextEventTitle caseInsensitiveCompare:previousEventTitle] == NSOrderedSame)
                {
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                    [dict setObject:arrayOfNextEventDetails[1] forKey:@"SUBEVENT_NAME"];
                    if ([arrayOfNextEventDetails[5] isEqualToString:@""]) {
                        [dict setObject:[eventInfo objectForKey:@"EVENT_STARTDATE"] forKey:@"SUBEVENT_STARTDATE"];
                    } else {
                        [dict setObject:arrayOfNextEventDetails[5] forKey:@"SUBEVENT_STARTDATE"];
                    }
                    [dict setObject:arrayOfNextEventDetails[6] forKey:@"SUBEVENT_STARTTIME"];
                    if ([arrayOfNextEventDetails[7] isEqualToString:@""]) {
                        [dict setObject:[eventInfo objectForKey:@"EVENT_ENDDATE"] forKey:@"SUBEVENT_ENDDATE"];
                    } else {
                        [dict setObject:arrayOfNextEventDetails[7] forKey:@"SUBEVENT_ENDDATE"];
                    }
                    [dict setObject:arrayOfNextEventDetails[8] forKey:@"SUBEVENT_ENDTIME"];

                    [tempArrayOfSubEvents addObject:dict];
                    eventIndex++;
                    arrayOfNextEventDetails = [[csvArrayOfEvents objectAtIndex:eventIndex + 1] componentsSeparatedByString:@","];
                    nextEventTitle = arrayOfNextEventDetails[0];
                }
                [eventInfo setObject:[tempArrayOfSubEvents copy] forKey:@"EVENT_SUBEVENTS"];
            }
         } else  {
            //Logging events from File with Incomplete Data
            [self.arrayOfEventsWithIncompleteData addObject:[csvArrayOfEvents objectAtIndex:eventIndex]];
        }
        eventIndex++;
    }
}

-(BOOL) verifyIfEventDataFromFileIsValid:(NSString *) eventStr{
    
    BOOL isValidEvent = YES;
    NSArray *arrayOfDetails = [eventStr componentsSeparatedByString:@","];
    if ([arrayOfDetails[0] isEqualToString:@""]) {
        isValidEvent = NO;
    } else if (([arrayOfDetails[2] caseInsensitiveCompare:@"Daily"] == NSOrderedSame) && ([arrayOfDetails[6] isEqualToString:@""])) {
        isValidEvent = NO;
    } else if (([arrayOfDetails[2] caseInsensitiveCompare:@"Weekly"] == NSOrderedSame) && ([arrayOfDetails[3] isEqualToString:@""]) && ([arrayOfDetails[6] isEqualToString:@""])) {
        isValidEvent = NO;
    } else if (([arrayOfDetails[2] caseInsensitiveCompare:@"BiWeekly"] == NSOrderedSame) && ([arrayOfDetails[3] isEqualToString:@""]) && ([arrayOfDetails[4] isEqualToString:@""]) && ([arrayOfDetails[6] isEqualToString:@""])) {
        isValidEvent = NO;
    } else if (([arrayOfDetails[2] caseInsensitiveCompare:@"Monthly"] == NSOrderedSame) && ([arrayOfDetails[3] isEqualToString:@""]) && ([arrayOfDetails[4] isEqualToString:@""]) && ([arrayOfDetails[6] isEqualToString:@""])) {
        isValidEvent = NO;
    } else if (([arrayOfDetails[2] caseInsensitiveCompare:@"Special"] == NSOrderedSame) && ([arrayOfDetails[5] isEqualToString:@""])) {
        isValidEvent = NO;
    }
    return isValidEvent;
}


@end
