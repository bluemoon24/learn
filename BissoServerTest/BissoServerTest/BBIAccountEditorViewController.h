//
//  BBIAccountEditorViewController.h
//  BissoServiceTest
//
//  Created by Sim iPad on 01.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBIMasterViewController.h"

@interface BBIAccountEditorViewController : UIViewController <UIPopoverControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *servicename;
@property (nonatomic, strong) IBOutlet UITextField *url;
@property (nonatomic, strong) IBOutlet UITextField *username;
@property (nonatomic, strong) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UISwitch *bissoAuth;

@property (nonatomic, strong, retain)  NSMutableDictionary *object;

@property (strong, nonatomic) BBIMasterViewController *masterPopoverController;

- (IBAction)onEditEnd:(id)sender;
- (IBAction)closePopup:(id)sender;
- (IBAction) onDismiss:(UIButton *)sender;
@end
