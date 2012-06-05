//
//  BBIBissoAuthenticator.m
//  ClassTester
//
//  Created by Sim iPad on 30.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBIBissoAuthenticator.h"

@implementation BBIBissoAuthenticator

@synthesize delegate;
@synthesize bissoServer = _bissoServer;
@synthesize bissoCredential = _bissoCredential;

@synthesize ticket = _ticket;

- (id) initWithBissoUrl:(NSURL *)url
{
    if ( self = [super init] ) 
    {
        self.bissoServer = url;
    }
    return self;
}

- (id) initWithBissoUrlAndCredential:(NSURL *)url :(NSURLCredential *)credential
{
    self = [self initWithBissoUrl:url];
    self.bissoCredential = credential;
    return self;
}

- (void) loadData
{
    // Create the request.
    
    NSURLRequest *theRequest= [[NSURLRequest alloc] initWithURL:[self bissoServer] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];

    // create the connection with the request
    // and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        NSLog(@"bisso:Connection succeeded.");    
    } else {
        NSLog(@"bisso:Connection failed.");    
    }   
}


- (BOOL) parse
{    
    BOOL success;
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:[self bissoServer]];
        
    [parser setDelegate:self];
    success = [parser parse];
    
    NSLog(@"bisso:Parser done.");    

    return success;
    
}

#pragma mark - NSURLConnection

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    NSLog(@"bisso:canAuthenticateAgainstProtectionSpace");
    return YES;
}

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSLog(@"bisso:didReceiveAuthenticationChallenge");
    
    if ([challenge previousFailureCount] == 0) {
       [[challenge sender] useCredential:self.bissoCredential
               forAuthenticationChallenge:challenge];
//        [self loadData];
        if (![self parse]) NSLog(@"Parser error");
        
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        NSLog(@"bisso:request canceled.");
        // inform the user that the user name and password
        // in the preferences are incorrect
        //        [self showPreferencesCredentialsAreIncorrectPanel:self];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    NSLog(@"bisso:Received response with statusCode: %u", [response statusCode]);

    if ([response statusCode] == 401)
    {
        // get authentication
        NSDictionary *headers = [response allHeaderFields];
        NSString *authType = [headers valueForKey:@"Www-Authenticate"];
        NSLog(@"bisso:Received challenge with authType: %@", authType);

    }
}

#pragma mark - NSXMLParser


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSMutableDictionary *)attributeDict 
{
    
    if ( [elementName isEqualToString:@"bisso:auth"]) {
        _ticket = [[NSMutableDictionary alloc] initWithDictionary:attributeDict copyItems:YES];        
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [_ticket setValue:string forKey:@"ticket"];
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ( [elementName isEqualToString:@"bisso:auth"]) {
    if (delegate) [delegate didReceiveTicket:_ticket];
    }
}

@end
