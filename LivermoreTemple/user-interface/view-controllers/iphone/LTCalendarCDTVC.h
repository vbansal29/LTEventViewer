//
//  LTCalendarCDTVC.h
//  LivermoreTemple
//
//  Created by Vidya on 4/30/13.
//  Copyright (c) 2013 Vidya. All rights reserved.
//

//#import

@interface LTCalendarCDTVC : UITableViewController
@property (nonatomic, strong) UIManagedDocument *eventDatabaseDocument;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
