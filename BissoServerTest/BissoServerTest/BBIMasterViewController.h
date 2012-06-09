//
//  BBIMasterViewController.h
//  ClassTester
//
//  Created by Sim iPad on 30.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBIPortletDelegate.h"

@class BBIDetailViewController;
@class BBIAccountEditorViewController;

@interface BBIMasterViewController : UITableViewController <BBIPortletDelegate>

@property (strong, nonatomic) BBIDetailViewController *detailViewController;
@property (strong, nonatomic) BBIAccountEditorViewController *accountEditorPopup;

- (IBAction)addService:(NSMutableDictionary *) obj sender:(id)sender;
- (IBAction)clearSelection:(id)sender;
- (IBAction)doSomething:(id)sender;

- (NSDictionary *) serviceForName: (NSString *)serviceName;

@end
