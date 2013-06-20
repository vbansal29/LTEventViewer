//
//  ContactResponsibility.h
//  LivermoreTemple
//
//  Created by Vidya on 5/14/13.
//  Copyright (c) 2013 Vidya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contact;

@interface ContactResponsibility : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Contact *belongsToContact;

@end
