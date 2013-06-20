//
//  SubEvent+create.h
//  LivermoreTemple
//
//  Created by Vidya on 5/16/13.
//  Copyright (c) 2013 Vidya. All rights reserved.
//

#import "SubEvent.h"

@interface SubEvent (create)

+ (SubEvent *)createSubEventWithInfo:(NSDictionary *)subEventDictionary inManagedObjectContext:(NSManagedObjectContext *)context;

+ (SubEvent *)findSubEventWithName:(NSString *)subEventName inManagedObjectContext:(NSManagedObjectContext *)context;

@end
