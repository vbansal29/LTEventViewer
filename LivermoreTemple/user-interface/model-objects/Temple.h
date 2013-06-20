//
//  Temple.h
//  LivermoreTemple
//
//  Created by Vidya on 5/13/13.
//  Copyright (c) 2013 Vidya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contact, Event, Pooja;

@interface Temple : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * dropboxFileURLForContacts;
@property (nonatomic, retain) NSString * dropboxFileURLForEvents;
@property (nonatomic, retain) NSString * dropboxFileURLForThithiAndDays;
@property (nonatomic, retain) NSString * houseNumber;
@property (nonatomic, retain) NSData * imageURL;
@property (nonatomic, retain) NSDecimalNumber * latitude;
@property (nonatomic, retain) NSDecimalNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * teleNumber;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSString * zipcode;
@property (nonatomic, retain) NSString * dropboxFileURLForPooja;
@property (nonatomic, retain) NSSet *contacts;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) NSSet *poojas;
@end

@interface Temple (CoreDataGeneratedAccessors)

- (void)addContactsObject:(Contact *)value;
- (void)removeContactsObject:(Contact *)value;
- (void)addContacts:(NSSet *)values;
- (void)removeContacts:(NSSet *)values;

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

- (void)addPoojasObject:(Pooja *)value;
- (void)removePoojasObject:(Pooja *)value;
- (void)addPoojas:(NSSet *)values;
- (void)removePoojas:(NSSet *)values;

@end
