//
//  LTEventCalendarViewController.m
//  LivermoreTemple
//
//  Created by Vidya on 5/14/13.
//  Copyright (c) 2013 Vidya. All rights reserved.
//

#import "LTEventScheduleViewController.h"
#import "UILoadingView.h"
#import "DateCalculator.h"
#import "Temple+Create.h"
#import "TempleDataController.h"
#import "LTDatabaseDocumentHandler.h"
#import "Event.h"
#import "LTEventViewCell.h"
#import "LTEventCalendarViewController.h"

@interface LTEventCalendarViewController ()

@property (nonatomic, strong) DateCalculator *dateCalc;

@property (nonatomic,strong) NSMutableArray *arrayOfTodayEvents;
@property (nonatomic, strong) NSMutableArray *arrayOfUpcomingEvents;
@property (nonatomic, strong) NSMutableArray *arrayOfPastEvents;

@end

@implementation LTEventCalendarViewController

#pragma mark Setter/Getters

-(void)setArrayOfTodayEvents:(NSMutableArray *)arrayOfTodayEvents {
    
    if (_arrayOfTodayEvents != arrayOfTodayEvents) {
        _arrayOfTodayEvents = arrayOfTodayEvents;
        
        [self.eventTableView reloadData];
    }
}

-(void)setArrayOfUpcomingEvents:(NSMutableArray *)arrayOfUpcomingEvents {
    
    if (_arrayOfUpcomingEvents != arrayOfUpcomingEvents) {
        _arrayOfUpcomingEvents = arrayOfUpcomingEvents;
        [self.eventTableView reloadData];
    }
}


#pragma mark Helper methods

-(NSDictionary *)calculateEventStartDateForEvent:(Event *)event  {
     
     NSString *startDateStr = event.startDate;
     NSString *endDateStr = event.endDate;

     if ([event.recurringType isEqualToString:@"Daily"]) {
         startDateStr = self.dateCalc.todayDateStr;
         endDateStr = self.dateCalc.todayDateStr;
     } else if ([event.recurringType isEqualToString:@"Weekly"]) {
         startDateStr = [self.dateCalc getDateForWeekday:event.recurringWeekday];
         endDateStr = startDateStr;
     } else if (([event.recurringType isEqualToString:@"Biweekly"]) || ([event.recurringType isEqualToString:@"Monthly"])) {
         startDateStr = [self.dateCalc getDateForWeekday:event.recurringWeekday forWeekdayOrdinal:[event.recurringMonthDay integerValue] forRecurringType:event.recurringType];
         endDateStr = startDateStr;
     } else if ([event.recurringType isEqualToString:@"Special"]) {
         startDateStr = event.startDate;
         if ([event.endDate isEqualToString:@""]) {
             endDateStr = startDateStr; // if end date of special event is empty assign it the start date of the event
         }
     }
    NSMutableDictionary *dateDictionary = [[NSMutableDictionary alloc] init];
    [dateDictionary setObject:startDateStr forKey:@"STARTDATE_STR"];
    [dateDictionary setObject:endDateStr forKey:@"ENDDATE_STR"];
    return dateDictionary;
}

-(NSArray *) sortArrayOfEventsOnDate:(NSArray *)arrayOfEvents {
    
    NSMutableArray *tempArrayOfEvents = [NSMutableArray arrayWithArray:arrayOfEvents];
    
    @try {
        NSInteger counter = [tempArrayOfEvents count];
        NSDate *compareDate;
        NSInteger index;
        
        for(int i = 0 ; i < counter; i++) {
            index = i;
            compareDate = [[tempArrayOfEvents objectAtIndex:i] objectForKey:@"STARTDATE"];
            NSDate *compareDateSecond;
            
            for(int j = i+1 ; j < counter; j++) {
                compareDateSecond=[[tempArrayOfEvents objectAtIndex:j] objectForKey:@"STARTDATE"];
                NSComparisonResult result = [compareDate compare:compareDateSecond];
                if(result == NSOrderedDescending) {
                    compareDate = compareDateSecond;
                    index=j;
                }
            }
            if(i!=index)
                [tempArrayOfEvents exchangeObjectAtIndex:i withObjectAtIndex:index];
        }
    }
    @catch (NSException * e) {
        NSLog(@"An exception occured while sorting event entries by date");
    }
    @finally {
        return [NSArray arrayWithArray:tempArrayOfEvents];
    }   
}

-(void)populateTableViewArrayFor:(NSString *)typeOfEvents intoDocument:(UIManagedDocument *)document
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray *matches = [self.eventDatabaseDocument.managedObjectContext executeFetchRequest:request error:&error];
    NSMutableArray *localArrayOfPastEvents = [[NSMutableArray alloc] init];
    NSMutableArray *localArrayOfTodayEvents = [[NSMutableArray alloc] init];
    NSMutableArray *localArrayOfUpcomingEvents = [[NSMutableArray alloc] init];
    for (Event *event in matches) {
        NSMutableDictionary *eventDictionary = [[NSMutableDictionary alloc] init];
        NSDictionary *stringDateDictonary = [self calculateEventStartDateForEvent:event];
        
        //Calculate NSDates from strings
        
        NSDate *startDate = [self.dateCalc getDateFromDateStr:[stringDateDictonary objectForKey:@"STARTDATE_STR"] dateFormat:@"MM/dd/yyyy" withTimeStr:event.startTime timeFormat:@"HH:mm:ss"];
       // NSLog(@"startDate = %@",startDate);
        NSDate *endDate = [self.dateCalc getDateFromDateStr:[stringDateDictonary objectForKey:@"ENDDATE_STR"] dateFormat:@"MM/dd/yyyy" withTimeStr:event.endTime timeFormat:@"HH:mm:ss"];
        
        // Add dictionary to parent event dictionary
        
        [eventDictionary setObject:event forKey:@"EVENT"];
        [eventDictionary setObject:[stringDateDictonary objectForKey:@"STARTDATE_STR"] forKey:@"STARTDATE_STR"];
        [eventDictionary setObject:[stringDateDictonary objectForKey:@"ENDDATE_STR"] forKey:@"ENDDATE_STR"];
        [eventDictionary setObject:startDate forKey:@"STARTDATE"];
        [eventDictionary setObject:endDate forKey:@"ENDDATE"];

       // Separate the events  based on their dates in to today/ upcoming / past

        NSInteger startDateCheck = [self.dateCalc checkDateIfTodayOrPastOrFuture:[stringDateDictonary objectForKey:@"STARTDATE_STR"]];
        NSInteger endDateCheck  = [self.dateCalc checkDateIfTodayOrPastOrFuture:[stringDateDictonary objectForKey:@"ENDDATE_STR"]];
        
        if ((startDateCheck == 0) || ((startDateCheck) < 0 && (endDateCheck > 0))){
            [localArrayOfTodayEvents addObject:eventDictionary];
        } else if (startDateCheck > 0) {
            [localArrayOfUpcomingEvents addObject:eventDictionary];
        } else {
            [localArrayOfPastEvents addObject:eventDictionary];
        }
    }
    
    // Sort Array on Dates

    NSArray *sortedArray;
    
    sortedArray = [self sortArrayOfEventsOnDate:localArrayOfTodayEvents];
    self.arrayOfTodayEvents = [[NSMutableArray alloc] initWithArray:sortedArray];
    
    sortedArray = [self sortArrayOfEventsOnDate:localArrayOfUpcomingEvents];
    self.arrayOfUpcomingEvents = [[NSMutableArray alloc] initWithArray:sortedArray];
    
    self.arrayOfPastEvents = [[NSMutableArray alloc] initWithArray:localArrayOfPastEvents];
}


-(void)fetchDropboxDataIntoDocument:(UIManagedDocument *)document {
    
    //[self.view addSubview:[[UILoadingView alloc] initWithFrame:self.view.bounds]];
    dispatch_queue_t fetchEventQ = dispatch_queue_create("Dropbox Fetcher", NULL);
    dispatch_async(fetchEventQ, ^{
        TempleDataController *livermoreTemple = [[TempleDataController alloc] init];
        NSDictionary *templeInfo  =[livermoreTemple getTempleInfo];
        [document.managedObjectContext performBlock:^{
           [Temple createTempleWithInfo:templeInfo inManagedObjectContext:document.managedObjectContext];
            [self populateTableViewArrayFor:@"Today" intoDocument:self.eventDatabaseDocument];
            [self populateTableViewArrayFor:@"Upcoming" intoDocument:self.eventDatabaseDocument];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self.view.subviews lastObject] removeFromSuperview];
        });
    });
}


-(id) initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];

    //Initialize Date Calculator Helper class
    
    self.dateCalc = [[DateCalculator alloc] init];
    
    if (!self.eventDatabaseDocument) {
        [[LTDatabaseDocumentHandler sharedDatabaseDocumentHandler] performWithDocument:^(UIManagedDocument *document) {
            self.eventDatabaseDocument = document;
            [self.view addSubview:[[UILoadingView alloc] initWithFrame:self.view.bounds]];
            [self fetchDropboxDataIntoDocument:self.eventDatabaseDocument];
        }];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections. Sections Fixed for "Today Events and Upcoming Events
    return 2;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    // The header for the section
    if (section == 0) {
        NSString *header = @"Today's ";
        header = [header stringByAppendingString:@" Events"];
        return header;
    } else {
        NSString *header = @"Upcoming Events";
        return header;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the Today Event and Upcoming Event section.
    if (section == 0) {
        if (self.arrayOfTodayEvents.count != 0) {
            return self.arrayOfTodayEvents.count;
        } else {
            return 1;
        }
    } else {
        if (self.arrayOfUpcomingEvents.count != 0) {
            return [self.arrayOfUpcomingEvents count];
        } else {
            return 1;
        }
    }
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"EventViewCell"];
    }
    if (indexPath.section == 0) {
        if (self.arrayOfTodayEvents.count == 0) {
            cell.textLabel.text = @"No Events Today";
        } else {
            NSDictionary *eventDictionary = [self.arrayOfTodayEvents objectAtIndex:indexPath.row];
            Event *event = [eventDictionary objectForKey:@"EVENT"];
            cell.textLabel.text = event.name;
            NSString *str = [self.dateCalc getDateStrFromDate:[eventDictionary objectForKey:@"STARTDATE"] inDateFormat:@"MM/dd/yyyy h:mm a"]; 
            cell.detailTextLabel.text = str ;
            cell.imageView.image = [[UIImage alloc] initWithData:event.image];
        }
    } else {
        if (self.arrayOfUpcomingEvents.count == 0) {
            cell.textLabel.text = @"No Upcoming Events";
        } else {
            NSDictionary *eventDictionary = [self.arrayOfUpcomingEvents objectAtIndex:indexPath.row];
            Event *event = [eventDictionary objectForKey:@"EVENT"];
            cell.textLabel.text = event.name;
            NSString *str = [self.dateCalc getDateStrFromDate:[eventDictionary objectForKey:@"STARTDATE"] inDateFormat:@"MM/dd/yyyy h:mm a"]; 
            cell.detailTextLabel.text = str;
            cell.imageView.image = [[UIImage alloc] initWithData:event.image];
        }
    }
    return cell;
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ShowEventSchedule"]) {
        LTEventScheduleViewController *eventScheduleVC = [segue destinationViewController];
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.eventTableView indexPathForCell:cell];
        if (indexPath.section == 0) {
            NSDictionary *eventDictionary = [self.arrayOfTodayEvents objectAtIndex:indexPath.row];
            eventScheduleVC.eventSelected = [eventDictionary objectForKey:@"EVENT"];
        } else {
            NSDictionary *eventDictionary = [self.arrayOfUpcomingEvents objectAtIndex:indexPath.row];
            eventScheduleVC.eventSelected = [eventDictionary objectForKey:@"EVENT"];
        }
    }
}

@end
