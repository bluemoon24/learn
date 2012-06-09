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

@synthesize ticket = _ticket;

NSString *kPrimaryAuthService = @"PrimaryAuthService";
NSString *primaryAuthService;
NSString *bissoUrlString = @"http://bisso.bms.cnb/authenticate/whoami.php";
NSString *fbissoUrlString = @"http://test.totaltrivial.de/BissoTestServer/authenticate/whoami.php";

NSURLCredential *authCredential;
NSURL *authUrl;


- (id) initWithDelegateAndLoad:(id) del
{
    if ( self = [super init] ) 
    {
        self.delegate = del;
    }
    if ([self setupByPreferences]) {
        [self loadData];
        return self;
    }
    else return nil;
    
}


- (BOOL)setupByPreferences
{
    NSString *testValue = [[NSUserDefaults standardUserDefaults] stringForKey:kPrimaryAuthService];
	if (testValue == nil)
	{
		// no default values have been set, create them here based on what's in our Settings bundle info
		//
		NSString *pathStr = [[NSBundle mainBundle] bundlePath];
		NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
		NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
        
		NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
		NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
        
		NSDictionary *prefItem;
		for (prefItem in prefSpecifierArray)
		{
			NSString *keyValueStr = [prefItem objectForKey:@"Key"];
			id defaultValue = [prefItem objectForKey:@"DefaultValue"];
			
			if ([keyValueStr isEqualToString:kPrimaryAuthService])
			{
				primaryAuthService = defaultValue;
			}
		}
        
		// since no default values have been set (i.e. no preferences file created), create it here		
        /*		NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
         firstNameDefault, kFirstNameKey,
         lastNameDefault, kLastNameKey,
         nameColorDefault, kNameColorKey,
         backgroundColorDefault, kBackgroundColorKey,
         nil];
         
         [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
         [[NSUserDefaults standardUserDefaults] synchronize];
         */
	}
	
	// we're ready to go, so lastly set the key preference values
	primaryAuthService = [[NSUserDefaults standardUserDefaults] stringForKey:kPrimaryAuthService];
    
    NSString *authUrlString;
    
    NSString *authUser;
    NSString *authPass; //  This is a hack. We should move to secure keychain storage.
    
    if ([primaryAuthService isEqualToString:@"bisso"])
    {
        authUrlString = [[NSUserDefaults standardUserDefaults] stringForKey:@"bissoUrl"];
        if (!authUrlString) authUrlString = bissoUrlString;
        authUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"bissoUser"];
        authPass = [[NSUserDefaults standardUserDefaults] stringForKey:@"bissoPass"];
    }
    else if ([primaryAuthService isEqualToString:@"fbisso"]) {
        authUrlString = [[NSUserDefaults standardUserDefaults] stringForKey:@"fakeBissoUrl"];
        if (!authUrlString) authUrlString = fbissoUrlString; 
        authUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"fakeBissoUser"];
        authPass = [[NSUserDefaults standardUserDefaults] stringForKey:@"fakeBissoPass"];
    }
    else {
        NSLog(@"Unknown service %@:", primaryAuthService);
        return false;
    }
    
    
    authCredential = [NSURLCredential credentialWithUser:authUser
                                                password:authPass
                                             persistence:NSURLCredentialPersistenceForSession];
    
    authUrl = [NSURL URLWithString:authUrlString];
        
    return true;    
}

- (void) loadData
{
    // Create the request.
    
    NSURLRequest *theRequest= [[NSURLRequest alloc] initWithURL:authUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];

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
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:authUrl];
        
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
       [[challenge sender] useCredential:authCredential
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
