//
//  BBIPortlet.h
//  BissoServerTest
//
//  Created by Sim iPad on 09.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBIPortletDelegate.h"

@class Qresult;

@interface BBIPortlet : NSObject

@property (nonatomic, retain) id<BBIPortletDelegate> delegate;

- (BBIPortlet *) init;
- (NSString *) describePortlet;
- (void) serviceDidFinishLoading: (NSString *)service result:(Qresult *)qResult;
- (void) serviceDidStartLoading: (NSString *)service;
- (void) serviceWillStartLoadingFromSource:(NSString *)service;


@end
