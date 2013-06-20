//
//  LTEventCalendarViewController.h
//  LivermoreTemple
//
//  Created by Vidya on 5/14/13.
//  Copyright (c) 2013 Vidya. All rights reserved.
//

#import "LTCoreViewController.h"

@interface LTEventCalendarViewController : LTCoreViewController <UITableViewDataSource, UITableViewDelegate >

@property (nonatomic, strong) UIManagedDocument *eventDatabaseDocument;

@property (weak, nonatomic) IBOutlet UITableView *eventTableView;

@end
