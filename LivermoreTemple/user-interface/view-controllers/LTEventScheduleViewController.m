//
//  LTEventScheduleViewController.m
//  LivermoreTemple
//
//  Created by Vidya on 5/26/13.
//  Copyright (c) 2013 Vidya. All rights reserved.
//

#import "Event.h"
#import "LTDatabaseDocumentHandler.h"
#import "DateCalculator.h"
#import "SubEvent.h"
#import "LTEventScheduleViewController.h"


@interface LTEventScheduleViewController ()

@property (nonatomic, strong) DateCalculator *dateCalc;
@property (nonatomic, strong) NSMutableArray *arrayOfSubEvents;
@property (nonatomic, strong) NSArray *arrayOfSectionHeader;
@property (nonatomic, strong) NSMutableDictionary *dictionaryOfSubEventsBySections;

@end

@implementation LTEventScheduleViewController

-(NSArray *) sortArrayOfEventsOnDate:(NSArray *)arrayOfEvents {
    
    NSMutableArray *tempArrayOfEvents = [NSMutableArray arrayWithArray:arrayOfEvents];
   // NSLog(@" array before sort %@", tempArrayOfEvents);
    @try {
        NSInteger counter = [tempArrayOfEvents count];
        NSDate *compareDate;
        NSInteger index;
        
        for(int i = 0 ; i < counter; i++) {
            index = i;
            SubEvent *subEvent = [tempArrayOfEvents objectAtIndex:i];
            compareDate = [self.dateCalc getDateFromDateStr:subEvent.startDate dateFormat:@"MM/dd/yyyy" withTimeStr:subEvent.startTime timeFormat:@"HH:mm:ss"];
            NSDate *compareDateSecond;
            
            for(int j = i+1 ; j < counter; j++) {
                SubEvent *nextSubEvent = [tempArrayOfEvents objectAtIndex:j];
                compareDateSecond=[self.dateCalc getDateFromDateStr:nextSubEvent.startDate dateFormat:@"MM/dd/yyyy" withTimeStr:nextSubEvent.startTime timeFormat:@"HH:mm:ss"];
                
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

-(void)setArrayOfSubEvents:(NSMutableArray *)arrayOfSubEvents {
    
    if (_arrayOfSubEvents != arrayOfSubEvents) {
        _arrayOfSubEvents = arrayOfSubEvents;
        [self.eventScheduleTableView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dateCalc = [[DateCalculator alloc] init];
    
    self.eventDetailsLabel.text = self.eventSelected.name;
    self.eventImage.image = [[UIImage alloc] initWithData:self.eventSelected.image];
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:self.eventSelected.subEvents.allObjects];
    NSArray *sortedArray = [self sortArrayOfEventsOnDate:tempArray];
    self.arrayOfSubEvents = [[NSMutableArray alloc] initWithArray:sortedArray];
    //NSLog(@" array of subevents = %@", self.arrayOfSubEvents);
    
    //create sections of subevents based on different dates
    if (self.arrayOfSubEvents != 0 ) {
        
        NSMutableDictionary *tempDictionary = [NSMutableDictionary dictionary];
        for (SubEvent *subEvent in self.arrayOfSubEvents) {
            NSMutableArray *tempArray = [tempDictionary objectForKey:subEvent.startDate];
            if (tempArray == nil) {
                tempArray = [NSMutableArray array];
                [tempDictionary setObject:tempArray forKey:subEvent.startDate];
            }
            [tempArray addObject:subEvent];
        }
        self.arrayOfSectionHeader = [tempDictionary allKeys];
        NSLog(@"array after sorting= %@", self.arrayOfSectionHeader);
        self.dictionaryOfSubEventsBySections = tempDictionary;
    }

}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections. Sections Fixed for "Today Events and Upcoming Events
    if (self.arrayOfSubEvents.count != 0) {
        return [self.dictionaryOfSubEventsBySections count];
    } else {
        return 1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.arrayOfSubEvents.count != 0) {
        NSString *headerKey = [self.arrayOfSectionHeader objectAtIndex:section];
        NSArray *arrayOfSubEvents = [self.dictionaryOfSubEventsBySections objectForKey:headerKey];
        NSInteger count =  arrayOfSubEvents.count;
        return count;
    } else {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    // The header for the section
    if (self.arrayOfSubEvents.count !=0) {
        NSString *header = [self.arrayOfSectionHeader objectAtIndex:section];
        return header;
    } else {
        return @"";
    }
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventScheduleViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"EventScheduleViewCell"];
    }
    if (self.arrayOfSubEvents.count == 0) {
        cell.textLabel.text = @"No Sub Events";
    } else {
        NSString *startDate = [self.arrayOfSectionHeader objectAtIndex:indexPath.section];
        NSArray *subEventsForStartDate = [self.dictionaryOfSubEventsBySections objectForKey:startDate];
        SubEvent *subEvent = [subEventsForStartDate objectAtIndex:indexPath.row];
        cell.textLabel.text = subEvent.name;
        cell.detailTextLabel.text = @"test";
    }
    return cell;
}

@end
