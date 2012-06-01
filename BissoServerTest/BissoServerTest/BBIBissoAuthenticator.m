//
//  BBIBissoAuthenticator.m
//  ClassTester
//
//  Created by Sim iPad on 30.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBIBissoAuthenticator.h"
#import "BBIBissoParser.h"

@implementation BBIBissoAuthenticator
@synthesize bissoServer = _bissoServer;
@synthesize bissoCredential = _bissoCredential;

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
    NSURLRequest *theRequest=[NSURLRequest  requestWithURL: [self bissoServer]
                                              cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                          timeoutInterval:60.0];
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


- (BOOL) parseURL:(NSString *)url
{    
    BOOL success;
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    
    BBIBissoParser *bissoParser = [[BBIBissoParser alloc] init];
    
    [parser setDelegate:bissoParser];
    success = [parser parse];
    return success;
    
}

#pragma mark - Bisso Connection

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
        [self loadData];
        
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

@end
