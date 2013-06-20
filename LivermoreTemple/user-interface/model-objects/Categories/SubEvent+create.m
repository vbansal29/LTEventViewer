//
//  SubEvent+create.m
//  LivermoreTemple
//
//  Created by Vidya on 5/16/13.
//  Copyright (c) 2013 Vidya. All rights reserved.
//

#import "SubEvent+create.h"

@implementation SubEvent (create)

+ (SubEvent *)createSubEventWithInfo:(NSDictionary *)subEventDictionary inManagedObjectContext:(NSManagedObjectContext *)context {
    
    SubEvent *subEvent = nil;
    
    // Avoid adding duplicates to the Database: Fetch the database for any matching subEvent
    
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"SubEvent"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"name = %@", [subEventDictionary objectForKey:@"SUBEVENT_NAME"]];
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"startDate = %@", [subEventDictionary objectForKey:@"SUBEVENT_STARTDATE"]];
    NSPredicate *andPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:predicate1, predicate2, nil]];
    request.predicate = andPredicate;
    // Execute the Query
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (![matches count]) {
        subEvent = [NSEntityDescription insertNewObjectForEntityForName:@"SubEvent" inManagedObjectContext:context];
        subEvent.name = [subEventDictionary objectForKey:@"SUBEVENT_NAME"];
        subEvent.startDate = [subEventDictionary objectForKey:@"SUBEVENT_STARTDATE"];
        subEvent.startTime = [subEventDictionary objectForKey:@"SUBEVENT_STARTTIME"];
        subEvent.endDate = [subEventDictionary objectForKey:@"SUBEVENT_ENDDATE"];
        subEvent.endTime = [subEventDictionary objectForKey:@"SUBEVENT_ENDTIME"];
    }
    return subEvent;
}



+ (SubEvent *)findSubEventWithName:(NSString *)subEventName inManagedObjectContext:(NSManagedObjectContext *)context {
    
    SubEvent *subEvent = nil;
    
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"SubEvent"];
    // request.sortDescriptors = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", subEventName];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        NSLog(@" Error while finding a match for Temple, possible duplicate entry %@", error.description);
    } else if (! [matches count]) {
        NSLog(@" Error: Couldn't find the matching Temple %@", error.description);
    } else {
        subEvent = [matches lastObject];
    }
    return subEvent;
}

@end
