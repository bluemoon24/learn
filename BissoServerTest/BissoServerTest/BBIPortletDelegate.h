//
//  BBIPortletDelegate.h
//  BissoServerTest
//
//  Created by Sim iPad on 09.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BBIPortlet;

@protocol BBIPortletDelegate <NSObject>

- (void) portletDidStartLoading:(BBIPortlet *)portlet;
- (void) portletDidFinishLoading:(BBIPortlet *)portlet;

@end
