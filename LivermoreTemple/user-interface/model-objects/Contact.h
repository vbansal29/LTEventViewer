//
//  Contact.h
//  LivermoreTemple
//
//  Created by Vidya on 5/13/13.
//  Copyright (c) 2013 Vidya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ContactResponsibility, Event, Temple;

@interface Contact : NSManagedObject

@property (nonatomic, retain) NSString * emailAddress;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * responsibility;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) Temple *belongsToTemple;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) NSSet *responsibilities;
@end

@interface Contact (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

- (void)addResponsibilitiesObject:(ContactResponsibility *)value;
- (void)removeResponsibilitiesObject:(ContactResponsibility *)value;
- (void)addResponsibilities:(NSSet *)values;
- (void)removeResponsibilities:(NSSet *)values;

@end
