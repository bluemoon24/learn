//
//  BBIAppDelegate.h
//  ClassTester
//
//  Created by Sim iPad on 30.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBIBissoAuthenticator.h"

@class KeychainItemWrapper;

@interface BBIAppDelegate : UIResponder <UIApplicationDelegate>
{
    KeychainItemWrapper *passwordItem;
    KeychainItemWrapper *accountItem;
}

@property (nonatomic, retain) KeychainItemWrapper *passwordItem;
@property (nonatomic, retain) KeychainItemWrapper *accountItem;

@property (strong, nonatomic) UIWindow *window;
@property (retain) BBIBissoAuthenticator *bissoAuth;


@end
