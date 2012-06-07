//
//  BBIDetailViewController.m
//  BissoServiceTest
//
//  Created by Sim iPad on 01.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBIDetailViewController.h"
#import "BBIBissoAuthenticator.h"
#import "BBIMasterViewController.h"

@interface BBIDetailViewController ()
- (void)configureView;
@end

@implementation BBIDetailViewController

@synthesize detailItem = _detailItem;
@synthesize webView = _webView;
@synthesize masterPopoverController = _masterPopoverController;

NSString *kPrimaryAuthService = @"PrimaryAuthService";
NSString *primaryAuthService;
NSString *bissoUrlString = @"http://bisso.bms.cnb/authenticate/whoami.php";
NSString *fbissoUrlString = @"http://test.totaltrivial.de/BissoTestServer/authenticate/whoami.php";
NSURLCredential *authCredential;
NSURL *authUrl;

NSURLRequest *_theRequest;

BBIBissoAuthenticator *_bissoAuth;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
// to be fixed        [(UIPopoverController *) self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)setupByPreferences
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
        return;
    }
    
    
     authCredential = [NSURLCredential credentialWithUser:authUser
                                                     password:authPass
                                                  persistence:NSURLCredentialPersistenceForSession];

    authUrl = [NSURL URLWithString:authUrlString];
}

- (void)configureView
{
//    BBIBissoAuthenticator *bisso;
    // Update the user interface for the detail item.

    [self setupByPreferences];
    
    if (self.detailItem) { 
        NSMutableString *urlString = [[_detailItem valueForKey:@"url"] mutableCopy];

       if ([[[self detailItem] valueForKey:@"bissoAuth"] boolValue])
        {
                _bissoAuth = [[BBIBissoAuthenticator alloc] initWithBissoUrlAndCredential:authUrl:authCredential];
                
                [_bissoAuth setDelegate:self];

                [_bissoAuth loadData];
        }
       else {
           _theRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
           
           [self loadData:_theRequest];

       }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    [self configureView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.webView = nil;
    _theRequest = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = (BBIMasterViewController *) popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError");
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSLog(@"shouldStartLoadWithRequest %@", request);

    return YES; //[self loadData:request];
    
}


- (BOOL) loadData: (NSURLRequest *) theRequest
{
    // Create the request.
/*    NSURLRequest *theRequest=[NSURLRequest requestWithURL: request
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
 */ 
    
    // create the connection with the request
    // and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        NSLog(@"Connection succeeded for %@", theRequest.URL); 
        [self.webView loadRequest:theRequest];

        return YES;
    } else {
        NSLog(@"Connection failed.for %@", theRequest.URL); 
        return NO;
    }   
}


- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    NSLog(@"canAuthenticateAgainstProtectionSpace");
    return YES;
}

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSLog(@"didReceiveAuthenticationChallenge");
    
   if ([challenge previousFailureCount] == 0) {
        NSURLCredential *newCredential;
        newCredential = [NSURLCredential credentialWithUser:[_detailItem valueForKey:@"user"]
                                                   password:[_detailItem valueForKey:@"pass"]
                                                persistence:NSURLCredentialPersistenceForSession];
        [[challenge sender] useCredential:newCredential
               forAuthenticationChallenge:challenge];
       [self.webView loadRequest:_theRequest];

    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        NSLog(@"request canceled.");
        // inform the user that the user name and password
        // in the preferences are incorrect
//        [self showPreferencesCredentialsAreIncorrectPanel:self];
    }
}

#pragma mark - BBIAuthenticatorDelegate

- (void)didReceiveTicket:(NSDictionary *)ticket
{
    NSMutableString *urlString = [[_detailItem valueForKey:@"url"] mutableCopy];

    NSURL *url = [NSURL URLWithString:urlString];
    
     [urlString appendString:([url query] ? @"&" : @"?")];
    
     [urlString appendString:@"cwid="];
     [urlString appendString:[ticket objectForKey:@"cwid"]];
     
     [urlString appendString:@"&ticket="];
     [urlString appendString:[ticket objectForKey:@"ticket"]];
     
     [urlString appendString:@"&issuer="];
     [urlString appendString:[ticket objectForKey:@"issuer"]];
     
     [urlString appendString:@"&instanceid="];
     [urlString appendString:[ticket objectForKey:@"instanceID"]];

    _theRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
    [self loadData:_theRequest];


}

@end
