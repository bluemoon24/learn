//
//  BBIAccountEditorViewController.m
//  BissoServiceTest
//
//  Created by Sim iPad on 01.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBIAccountEditorViewController.h"


@interface BBIAccountEditorViewController ()

@end


@implementation BBIAccountEditorViewController

@synthesize servicename;
@synthesize url;
@synthesize username;
@synthesize password;
@synthesize bissoAuth;
@synthesize object;

@synthesize masterPopoverController = _masterPopoverController;


- (IBAction) onDismiss: (UIButton *)sender
{
    NSMutableDictionary *obj = [[NSMutableDictionary alloc] initWithCapacity:5];
    [obj setObject:(servicename.text ? servicename.text : @"") forKey: @"service"];
    [obj setObject:(url.text ? url.text : @"") forKey: @"url"];
    [obj setObject:(username.text ? username.text : @"") forKey: @"user"];
    [obj setObject:(password.text ? password.text : @"") forKey: @"pass"];
    [obj setObject:[NSNumber numberWithBool:bissoAuth.on] forKey: @"bissoAuth"];
    
    [self.masterPopoverController addService:obj sender:self];
}

- (IBAction)onEditEnd:(UITextField *)sender
{
    NSLog(@"edit end: sender is %@", sender);
    
}


- (IBAction)closePopup:(id)sender {
    NSLog(@"closePopup");
    
}

- (void) viewWillAppear:(BOOL)animated
{
    BOOL authon;
    NSLog(@"View will appear");

    [[self username] setText:[object valueForKey:@"user"]];
    [[self servicename] setText:[object valueForKey:@"service"]];
    [[self password] setText:[object valueForKey:@"pass"]];
    [[self url] setText:[object valueForKey:@"url"]];
    authon = [[object valueForKey:@"bissoAuth"] boolValue];
    [[self bissoAuth] setOn:authon animated:NO];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - UIPopoverController

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"popoverControllerShouldDismissPopover called.");
    return YES;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"popoverControllerDidDismissPopover called.");

}


#pragma mark - UITextField


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldShouldBeginEditing");
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidEndEditing:");
        NSLog(@"Textfield: %@, %@", username.text, password.text);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn");
    return YES;
}
- (void)viewDidUnload {
    [self setBissoAuth:nil];
    [super viewDidUnload];
}
@end
