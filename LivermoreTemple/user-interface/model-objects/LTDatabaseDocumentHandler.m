//
//  LTDatabaseDocumentHandler.m
//  LivermoreTemple
//
//  Created by Vidya on 4/29/13.
//  Copyright (c) 2013 Vidya. All rights reserved.
//

#import "LTDatabaseDocumentHandler.h"

@interface LTDatabaseDocumentHandler ()

-(void)objectsDidChange:(NSNotification *)notification;
-(void)contextDidSave:(NSNotification *)notification;

@end

@implementation LTDatabaseDocumentHandler

static LTDatabaseDocumentHandler *_sharedInstance;

+ (LTDatabaseDocumentHandler *) sharedDatabaseDocumentHandler {
    
    static dispatch_once_t once;
    dispatch_once(&once , ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

-(id)init {
    
    self = [super init];
    if (self) {
        
        // Check if the sqlite store file exits in documents directory and if yes use it else copy it from app bundle
        
        NSString *fileName = @"ShivaVishnuTempleData.sqlite";
        
        // if file doesn't exist in documents directory then copy from app bundle
        if (![LTDatabaseDocumentHandler getFileExistence:fileName]) {            
            NSError *error;
            NSString *file = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
            if (file)
            {
                if([[NSFileManager defaultManager] copyItemAtPath:file toPath:[LTDatabaseDocumentHandler dataFilePath:fileName] error:&error]){
                    NSLog(@"File successfully copied");
                } else { // if file is not in app bundle
                    [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"error", nil) message: NSLocalizedString(@"failedcopydb", nil)  delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil)  otherButtonTitles:nil] show];
                    NSLog(@"Error description-%@ \n", [error localizedDescription]);
                    NSLog(@"Error reason-%@", [error localizedFailureReason]);
                }
                file = nil;
            } else {
                    NSLog(@"test 44");
            }
        } else {
            NSLog(@"test");
        }
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:fileName];
        self.document =  [[UIManagedDocument alloc] initWithFileURL:url];
        
        //set our document up for automatic migrations
        if (self.document) {
            NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithBool:YES],
                NSMigratePersistentStoresAutomaticallyOption,
                                     [NSNumber numberWithBool:YES],
                NSInferMappingModelAutomaticallyOption, nil];
            
            self.document.persistentStoreOptions = options;
            
            // Register for Notifications
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(objectsDidChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:self.document.managedObjectContext];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidSave:) name:NSManagedObjectContextDidSaveNotification object:self.document.managedObjectContext];
        } else {
            //Todo: Replace it with an alert view to display the user about not being able to load the database and try again and exit from the app
            
            NSLog(@"The UIManaged Document could not be initialized");
            
        }
    }
    
    return self;
}

-(void) performWithDocument:(OnDocumentReady)onDocumentReady {
    
    void (^OnDocumentDidLoad)(BOOL) = ^(BOOL Success) {
        onDocumentReady(self.document);
    };
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.document.fileURL path]]) {
        
        //Todo: Add Initial Data as in temple / Event / Contact / Thithi information
        [self.document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:OnDocumentDidLoad];
        
    } else if (self.document.documentState == UIDocumentStateClosed) {
        [self.document openWithCompletionHandler:OnDocumentDidLoad];
    } else if (self.document.documentState == UIDocumentStateNormal) {
        OnDocumentDidLoad(YES);
    }
}

- (void) objectsDidChange:(NSNotification *)notification {
    
#ifdef DEBUG 
    NSLog(@"NSManagedObjects did change");
#endif
}

- (void) contextDidSave:(NSNotification *)notification {
    
#ifdef DEBUG
    NSLog(@"NSManagedContext did save.");
#endif
}

+ (BOOL) getFileExistence:(NSString *)filename {
    
    BOOL isFileExists = NO;
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [documentPaths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingString:@"/"];
    filePath = [documentsDirectory stringByAppendingString:filename];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSLog(@" filepath = %@", filePath);
    if ([fileManager fileExistsAtPath:filePath]) {
        isFileExists = YES;
    }
    return isFileExists;
}

+ (NSString *)dataFilePath:(NSString *)filename {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
    docDirectory = [docDirectory stringByAppendingString:@"/"];
    docDirectory = [docDirectory stringByAppendingString:filename];
    NSLog(@"doc dir = %@", docDirectory);
    return docDirectory;
}

@end

// Checking for URL of library directory
/*
 // Uncomment this when sqllite file is created using the data model
 
 // Get Path to SQLite Store File
 NSString *sqliteStoreFileName = @"ShivaVishnuTempleData.sqlite";
 NSString *directoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
 NSString *sqliteStoreFilePath = [directoryPath stringByAppendingPathComponent:sqliteStoreFileName];
 
 NSFileManager *fileManager = [NSFileManager defaultManager];
 
 //Check to see if the SQLite Store file exists and if file not found copy the default database from application bundle
 
 if (!([fileManager fileExistsAtPath:sqliteStoreFilePath])) {
 NSString *defaultSqliteStoreFilePath = [[NSBundle mainBundle] pathForResource:@"ShivaVishnuTempleData" ofType:@"sqlite"]; {
 
 if (defaultSqliteStoreFilePath) {
 [fileManager copyItemAtPath:defaultSqliteStoreFilePath toPath:sqliteStoreFilePath error:NULL];
 }
 } */
