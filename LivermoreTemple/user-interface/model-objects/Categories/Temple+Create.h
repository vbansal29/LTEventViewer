//
//  Temple+Create.h
//  LivermoreTemple
//
//  Created by Vidya on 4/29/13.
//  Copyright (c) 2013 Vidya. All rights reserved.
//

#import "Temple.h"

@interface Temple (Create)

+ (Temple *)createTempleWithInfo:(NSDictionary *)templeDictionary inManagedObjectContext:(NSManagedObjectContext *)context;

+ (Temple *)findTempleWithName:(NSString *)templeName inManagedObjectContext:(NSManagedObjectContext *)context;

@end
