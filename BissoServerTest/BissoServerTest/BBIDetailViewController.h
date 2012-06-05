//
//  BBIDetailViewController.h
//  ClassTester
//
//  Created by Sim iPad on 30.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBIMasterViewController.h"
#import "BBIAuthenticatorDelegate.h"

@interface BBIDetailViewController : UIViewController <UISplitViewControllerDelegate, UIWebViewDelegate, BBIAuthenticatorDelegate>

@property (strong, nonatomic) NSMutableDictionary *detailItem;

@property (strong, nonatomic) BBIMasterViewController *masterPopoverController;
@property (strong, nonatomic) IBOutlet UIWebView *webView;


@end
