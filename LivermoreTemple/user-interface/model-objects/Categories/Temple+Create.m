//
//  Temple+Create.m
//  LivermoreTemple
//
//  Created by Vidya on 4/29/13.
//  Copyright (c) 2013 Vidya. All rights reserved.
//

#import "Event+Create.h"
#import "Temple+Create.h"

@implementation Temple (Create)

+ (Temple *)createTempleWithInfo:(NSDictionary *)templeDictionary inManagedObjectContext:(NSManagedObjectContext *)context {
    
    Temple *temple = nil;
    
    // Avoid adding duplicates to the Database: Fetch the database for any matching temple
    
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Temple"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", [templeDictionary objectForKey:@"TEMPLE_NAME"]];
    
    // Execute the Query
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (! [matches count]) {
        temple = [NSEntityDescription insertNewObjectForEntityForName:@"Temple" inManagedObjectContext:context];
        temple.name = [templeDictionary objectForKey:@"TEMPLE_NAME"];
        temple.country = [templeDictionary objectForKey:@"TEMPLE_COUNTRY"];
        temple.state = [templeDictionary objectForKey:@"TEMPLE_STATE"];
        temple.city = [templeDictionary objectForKey:@"TEMPLE_CITY"];
        temple.street = [templeDictionary objectForKey:@"TEMPLE_STREET"];
        temple.houseNumber = [templeDictionary objectForKey:@"TEMPLE_HOUSENUMBER"];
        temple.zipcode = [templeDictionary objectForKey:@"TEMPLE_ZIPCODE"];
        temple.teleNumber = [templeDictionary objectForKey:@"TEMPLE_TELENUMBER"];
        temple.website = [templeDictionary objectForKey:@"TEMPLE_WEBSITE"];
        temple.latitude = [[NSDecimalNumber alloc] initWithDouble:[[templeDictionary objectForKey:@"TEMPLE_LATITUDE"] doubleValue]];
        temple.longitude = [[NSDecimalNumber alloc] initWithDouble:[[templeDictionary objectForKey:@"TEMPLE_LONGITUDE"] doubleValue]];        temple.dropboxFileURLForEvents = [templeDictionary objectForKey:@"TEMPLE_DROPBOX_URL_EVENTS"];
        temple.dropboxFileURLForContacts = [templeDictionary objectForKey:@"TEMPLE_DROPBOX_URL_CONTACTS"];
        temple.dropboxFileURLForThithiAndDays = [templeDictionary objectForKey:@"TEMPLE_DROPBOX_URL_THITHI_AND_DAYS"];
        temple.dropboxFileURLForPooja = [templeDictionary objectForKey:@"TEMPLE_DROPBOX_URL_POOJAS"];
        
        // Add Relationship attributes
        
        // Create Events objects in database
        
        NSArray *listOfEvents = [templeDictionary objectForKey:@"TEMPLE_MASTER_LIST_OF_EVENTS"];
        for (NSDictionary *eventInfo in listOfEvents) {
            Event * newEvent = [Event createEventWithInfo:eventInfo inManagedObjectContext:context];
            if (newEvent) {
                [temple addEventsObject:newEvent];
            }
        }
    }
    return temple;
}

+ (Temple *)findTempleWithName:(NSString *)templeName inManagedObjectContext:(NSManagedObjectContext *)context {
    
    Temple *temple = nil;
    
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Temple"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", templeName];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        NSLog(@" Error while finding a match for Temple, possible duplicate entry %@", error.description);
    } else if (! [matches count]) {
        NSLog(@" Error: Couldn't find the matching Temple %@", error.description);
    } else {
        temple = [matches lastObject];
    }
    return temple;
}

@end
