//
//  BBIDataManager.h
//  BissoServerTest
//
//  Created by Sim iPad on 06.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "BBIDataManagerProtocol.h"
#import "BBIAuthenticatorDelegate.h"
#import "BBIBWRunQueryDelegate.h"

#import "Qresult.h"


@interface BBIDataManager : NSObject <BBIDataManagerProtocol,BBIAuthenticatorDelegate, NSURLConnectionDelegate,NSXMLParserDelegate>

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (readonly, strong, nonatomic) Qresult *qResult;

@property (nonatomic, retain) id<BBIBWRunQueryDelegate> delegate;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
