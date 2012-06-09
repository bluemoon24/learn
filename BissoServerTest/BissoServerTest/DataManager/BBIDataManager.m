//
//  BBIDataManager.m
//  BissoServerTest
//
//  Created by Sim iPad on 06.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBIDataManager.h"
#import "BBIBissoAuthenticator.h"
#import "BBIBWQueryResultParserDelegate.h"
#import "BBIBWRunQueryDelegate.h"

#import "Qresult.h"


@implementation BBIDataManager

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

@synthesize qResult;
@synthesize delegate;

NSMutableString *urlString;
NSBlockOperation *theQueue;
NSMutableData *receivedData;

- (BBIDataManager *) init
{
    self = [super init];
    return self;
}

- (void) getData: (NSString *) serviceId
{
//    by-sap-b73.bayer-ag.com:8080/rest(bD1lbiZjPTIwMA==)/runquery/default.bsp?issuer=kerberos&instanceid=0&version=2.00&query2run=S_SOA_DUMPDP21D_Q9102&ticket=&cwid=
    
    if ([serviceId isEqualToString:@"BWRunQuery"])
    {
    urlString = [@"http://by-sap-b73.bayer-ag.com:8080/rest(bD1lbiZjPTIwMA==)/runquery/default.bsp" mutableCopy];
    }
    else if ([serviceId isEqualToString:@"FakeBWRunQuery"])
    {
        
        urlString = [@"http://test.totaltrivial.de/BissoTestServer/service1.php" mutableCopy];
    }
    else {
        
        NSLog(@"Unknown serviceId %@:", serviceId);
        return;
    }
    
    NSDictionary *requestParameters;

    if (delegate) {
        requestParameters = [delegate getParametersForBWRunQuery];
        
        if (![[BBIBissoAuthenticator alloc]initWithDelegateAndLoad:self])
            NSLog(@"Can't get Bisso configuration");
        
        NSEnumerator *enumerator = [requestParameters keyEnumerator];
        id key;

        NSURL *url = [NSURL URLWithString:urlString];
        
        [urlString appendString:([url query] ? @"&" : @"?")];

        while ((key = [enumerator nextObject])) {
            [urlString appendString:(NSString *)key];
            [urlString appendString:@"="];
            [urlString appendString:[requestParameters objectForKey:key]];
        }
    }
}

#pragma mark - BBIAuthenticatorDelegate

- (void)didReceiveTicket:(NSDictionary *)ticket
{

    [urlString appendString:([[NSURL URLWithString:urlString] query] ? @"&" : @"?")];
    
    [urlString appendString:@"cwid="];
    [urlString appendString:[ticket objectForKey:@"cwid"]];
    
    [urlString appendString:@"&ticket="];
    [urlString appendString:[ticket objectForKey:@"ticket"]];
    
    [urlString appendString:@"&issuer="];
    [urlString appendString:[ticket objectForKey:@"issuer"]];
    
    [urlString appendString:@"&instanceid="];
    [urlString appendString:[ticket objectForKey:@"instanceID"]];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Qresult" inManagedObjectContext:self.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(requestURL like[c] %@)",
                              urlString];

    [request setPredicate:predicate];

    [request setEntity:entity];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if (mutableFetchResults == nil) {
        NSLog(@"Error in persistent store handling");
        
    } 
    
    else if (mutableFetchResults.count <= 0) {
        
        NSLog(@"No Qresult in cache. Getting data from service");

        if (!theQueue) theQueue = [[NSBlockOperation alloc] init];
        
        BOOL success;
        NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];
        
        // todo: select parser delegate depending on service
        BBIBWQueryResultParserDelegate *bwpd = [[BBIBWQueryResultParserDelegate alloc] init];
        [bwpd setManagedObjectContext:self.managedObjectContext];
        [parser setDelegate:bwpd];
        success = [parser parse];
        if (success) {
            qResult = bwpd.qResult;
            qResult.requestURL = urlString;
            [self saveContext];
        }
        
        NSLog(@"DataManager:Parser done.");    

    }
    else {
        qResult = [mutableFetchResults objectAtIndex:0];
        NSLog(@"Qresult requestURL %@", qResult.requestURL);
        Item *item = [qResult.items anyObject];
        NSLog(@"Any Item' header: %@", item.header);
        Value *value = [item.values anyObject];
        NSLog(@"Any Value's value, unit %@ %@", value.value, value.unit);
        
//        [self deleteObjectFromContext:qResult];

    }
    
        
/*
    NSURLRequest *theRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        receivedData = [NSMutableData data];
    } else {
        // Inform the user that the connection failed.
        NSLog(@"DataManager: Can't establish connection to service. URL: %@", urlString);
    }
 */   
}


#pragma mark - NSURLConnection

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    NSLog(@"DataManager: canAuthenticateAgainstProtectionSpace");
    return NO; //we can switch to BW authentication here, in case bisso fails.
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

- (void) deleteObjectFromContext:(NSManagedObject *)object
{
    [self.managedObjectContext deleteObject:object];
    [self saveContext];

}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PortletEngine" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PortletEngine.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
