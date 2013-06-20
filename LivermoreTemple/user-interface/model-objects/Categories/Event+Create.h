//
//  Event+Create.h
//  LivermoreTemple
//
//  Created by Vidya on 4/30/13.
//  Copyright (c) 2013 Vidya. All rights reserved.
//

#import "Event.h"

@interface Event (Create)

+ (Event *)createEventWithInfo:(NSDictionary *)eventDictionary inManagedObjectContext:(NSManagedObjectContext *)context;

@end
