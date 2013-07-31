//
//  LTDatabaseDocumentHandler.h
//  LivermoreTemple
//
//  Created by Vidya on 4/29/13.
//  Copyright (c) 2013 Vidya. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^OnDocumentReady) (UIManagedDocument *document);

@interface LTDatabaseDocumentHandler : NSObject

@property (strong, nonatomic) UIManagedDocument *document;

+(LTDatabaseDocumentHandler *)sharedDatabaseDocumentHandler;
-(void) performWithDocument:(OnDocumentReady)onDocumentReady;

@end
