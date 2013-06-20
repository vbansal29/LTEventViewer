//
//  LTEventScheduleViewController.h
//  LivermoreTemple
//
//  Created by Vidya on 5/26/13.
//  Copyright (c) 2013 Vidya. All rights reserved.
//

#import "LTCoreViewController.h"

@class Event;

@interface LTEventScheduleViewController : LTCoreViewController <UITableViewDataSource, UITableViewDelegate >

@property (nonatomic, strong) Event *eventSelected;

@property (weak, nonatomic) IBOutlet UITableView *eventScheduleTableView;
@property (weak, nonatomic) IBOutlet UILabel *eventDetailsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *eventImage;

@end
