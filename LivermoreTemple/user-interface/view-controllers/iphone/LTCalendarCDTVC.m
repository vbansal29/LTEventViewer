//
//  LTCalendarCDTVC.m
//  LivermoreTemple
//
//  Created by Vidya on 4/30/13.
//  Copyright (c) 2013 Vidya. All rights reserved.
//

#import "LTDatabaseDocumentHandler.h" // Gives shared instance of UIManagedDocument
#import "Event.h"
#import "LTEventViewCell.h"
#import "LTCalendarCDTVC.h"

@interface LTCalendarCDTVC ()


@end

@implementation LTCalendarCDTVC

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext) {
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES]];
        
        //Get Start Date and EndDate for TOday and compare it to NSDate from CoreData
        // Get 12 am of today's morning
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit |NSMonthCalendarUnit |NSDayCalendarUnit) fromDate:[NSDate date]];
        NSDate *firstDate = [calendar dateFromComponents:dateComponents];
        // Get 12 am tonight
        dateComponents.day = dateComponents.day + 1;
        NSDate *secondDate = [calendar dateFromComponents:dateComponents];
    
        NSPredicate *firstPredicate = [NSPredicate predicateWithFormat:@"startDate > %@", firstDate];
        NSPredicate *secondPredicate = [NSPredicate predicateWithFormat:@"startDate < %@", secondDate];
        NSArray *predicateArray = [NSArray arrayWithObjects:firstPredicate, secondPredicate,nil];
        NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicateArray];        
        [request setPredicate:compoundPredicate];        
       // self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    } else {
       // self.fetchedResultsController = nil;
    }
}


-(id) initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (!self.eventDatabaseDocument) {
        
        [[LTDatabaseDocumentHandler sharedDatabaseDocumentHandler] performWithDocument:^(UIManagedDocument *document) {
            self.eventDatabaseDocument = document;    
        }];
        
  
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        NSString *CellIdentifier = @"EventViewCell";
        LTEventViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
      //  Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
        //Todo: Set Image properly and also decide what to display in detail text
        //cell.eventImage.image = event.image;
      //  cell.eventTitle.text = event.title;
      //  cell.eventDetails.text = event.venue;
    
        return cell;
}

@end
