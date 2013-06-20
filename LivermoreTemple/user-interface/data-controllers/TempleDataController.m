//
//  TempleDataController.m
//  TempleDataLoader
//
//  Created by Vidya on 5/8/13.
//  Copyright (c) 2013 Vidya. All rights reserved.
//

//#import "PoojaDataController.h"
//#import "ContactDataController.h"
#import "EventDataController.h"
#import "Temple.h"
#import "TempleDataController.h"

@interface TempleDataController ()

@property (nonatomic, strong) NSDictionary *livermoreTempleInfo;

@end

@implementation TempleDataController

- (id)init {
    
    self = [super init];
    if (self)  {
        [self initializeTemple];
    }
    return self;
}

-(void) initializeTemple {
    
    // Read Datafile from Dropbox
    NSURL *dataURL = [[NSURL alloc] initWithString:@"https://dl.dropboxusercontent.com/u/144305842/ShivaVishnuTempleData%2520-%2520TempleInfo.csv"];
    NSData *data = [NSData dataWithContentsOfURL:dataURL];
    NSString* templeDataStr = [[NSString alloc] initWithData:data
                                              encoding:NSUTF8StringEncoding];
    
    NSArray *templeArray = [templeDataStr componentsSeparatedByString:@"\n"];
    NSMutableArray *templeArrayWithoutHeader = [NSMutableArray arrayWithArray:templeArray];
    [templeArrayWithoutHeader removeObjectAtIndex:0]; // remove header row
    // Store Data Temple Dictionary Info passed on to Temple+Create category
    NSArray *arrayOfTempleDetails = [[templeArrayWithoutHeader objectAtIndex:0]componentsSeparatedByString:@","];
    NSMutableDictionary *templeInfo = [[NSMutableDictionary alloc] init];
    [templeInfo setObject:[arrayOfTempleDetails[0] capitalizedString] forKey:@"TEMPLE_NAME"];
    [templeInfo setObject:arrayOfTempleDetails[1] forKey:@"TEMPLE_PHONE_NUMBER"];
    [templeInfo setObject:[arrayOfTempleDetails[2] capitalizedString] forKey:@"TEMPLE_COUNTRY"];
    [templeInfo setObject:[arrayOfTempleDetails[3] capitalizedString] forKey:@"TEMPLE_STATE"];
    [templeInfo setObject:[arrayOfTempleDetails[4] capitalizedString] forKey:@"TEMPLE_CITY"];
    [templeInfo setObject:[arrayOfTempleDetails[5] capitalizedString] forKey:@"TEMPLE_STREET"];
    [templeInfo setObject:arrayOfTempleDetails[6]  forKey:@"TEMPLE_HOUSE_NUMBER"];
    [templeInfo setObject:arrayOfTempleDetails[7] forKey:@"TEMPLE_ZIPCODE"];
    [templeInfo setObject:arrayOfTempleDetails[8] forKey:@"TEMPLE_WEBSITE"];
    [templeInfo setObject:arrayOfTempleDetails[9] forKey:@"TEMPLE_LATITUDE"];
    [templeInfo setObject:arrayOfTempleDetails[10] forKey:@"TEMPLE_LONGITUDE"];
   
    //Load Events from URL into array
    
    [templeInfo setObject:arrayOfTempleDetails[11] forKey:@"TEMPLE_DROPBOX_URL_EVENT"];
    EventDataController *eventDC = [[EventDataController alloc] init];
    NSArray *csvArrayOfEvents = [eventDC loadEventsFromFileURL:arrayOfTempleDetails[11]];
    [eventDC initializeMasterListOfEventsFrom:csvArrayOfEvents];
    [templeInfo setObject:eventDC.masterListOfEvents forKey:@"TEMPLE_MASTER_LIST_OF_EVENTS"];
     /*
    //Load Contacts from URL into array
    
    [templeInfo setObject:arrayOfTempleDetails[12] forKey:@"TEMPLE_DROPBOX_URL_CONTACT"];
    ContactDataController *contactDC = [[ContactDataController alloc] init];
    NSArray *csvArrayOfContacts = [contactDC loadContactsFromFileURL:arrayOfTempleDetails[12]];
    [contactDC initializeMasterListOfContactsFrom:csvArrayOfContacts];
    [templeInfo setObject:contactDC.masterListOfContacts forKey:@"TEMPLE_MASTER_LIST_OF_CONTACTS"];
    
    // Load Thithi and Days from URL into array
    
    [templeInfo setObject:arrayOfTempleDetails[13] forKey:@"TEMPLE_DROPBOX_URL_THITHI_AND_DAYS"];

    //Load Poojas from URL into array
    
    [templeInfo setObject:arrayOfTempleDetails[14] forKey:@"TEMPLE_DROPBOX_URL_POOJAS"];
    PoojaDataController *poojaDC = [[PoojaDataController alloc] init];
    NSArray *csvArrayOfPoojas = [poojaDC loadPoojasFromFileURL:arrayOfTempleDetails[14]];
    [poojaDC initializeMasterListOfPoojasFrom:csvArrayOfPoojas];
    [templeInfo setObject:poojaDC.masterListOfPoojas forKey:@"TEMPLE_MASTER_LIST_OF_POOJAS"];
    
    //copy the temple image from app bundle and save it as binary data in core data
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"temple" ofType:@".gif"];
    NSData *templeImageData = [NSData dataWithContentsOfFile:path];
    [templeInfo setObject:templeImageData forKey:@"TEMPLE_IMAGE"];
    
    // Copy the Temple Info Dictionary to temple dictionary
    */
    self.livermoreTempleInfo = templeInfo;
}

- (NSDictionary *)getTempleInfo {
    
    return self.livermoreTempleInfo;
}

@end
