//
//  Event+Create.m
//  LivermoreTemple
//
//  Created by Vidya on 4/30/13.
//  Copyright (c) 2013 Vidya. All rights reserved.
//

#import "SubEvent+create.h"
#import "Event+Create.h"
#import "Temple+Create.h"

@implementation Event (Create)


+ (Event *)createEventWithInfo:(NSDictionary *)eventDictionary inManagedObjectContext:(NSManagedObjectContext *)context {
    
    Event *event = nil;
    
    // Avoid adding duplicates to the Database: Fetch the database for any matching Event
    
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", [eventDictionary objectForKey:@"EVENT_NAME"]];
    
    // Execute the Query
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (! [matches count]) {
        event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
        event.name = [eventDictionary objectForKey:@"EVENT_NAME"];
        event.recurringType = [eventDictionary objectForKey:@"EVENT_RECURRINGTYPE"];
        event.recurringWeekday = [eventDictionary objectForKey:@"EVENT_RECURRINGWEEKDAY"];
        event.recurringMonthDay = [[NSNumber alloc] initWithInt:[[eventDictionary objectForKey:@"EVENT_RECURRINGMONTHDAY"] integerValue]];
        event.startDate = [eventDictionary objectForKey:@"EVENT_STARTDATE"];
        //NSLog(@"Event name = %@, startDate = %@", event.name,event.startDate);
        event.startTime = [eventDictionary objectForKey:@"EVENT_STARTTIME"];
        event.endDate = [eventDictionary objectForKey:@"EVENT_ENDDATE"];
        event.endTime = [eventDictionary objectForKey:@"EVENT_ENDTIME"];
        event.venue = [eventDictionary objectForKey:@"EVENT_VENUE"];
        event.detailsPDFURL = [eventDictionary objectForKey:@"EVENT_DETAILS_PDF_URL"];
        event.image = [eventDictionary objectForKey:@"EVENT_IMAGE"];
/*        NSString *contactName = [eventDictionary objectForKey:@"EVENT_MAINCONTACT"];
        Contact *contact = [Contact findContactWithName:contactName inManagedObjectContext:context];
        if (contact) {
            event.mainContact = contact;
        } else {
            //handle the error
            NSLog(@"Event+create.h: Could not find the Contact");
        }*/
        NSArray *listOfSubEvents = [eventDictionary objectForKey:@"EVENT_SUBEVENTS"];
        for (NSDictionary *subEventInfo in listOfSubEvents) {
            SubEvent *subEvent = [SubEvent createSubEventWithInfo:subEventInfo inManagedObjectContext:context];
            if (subEvent) {
                [event addSubEventsObject:subEvent];
            }
        }
    } 
    return event;
}

@end
