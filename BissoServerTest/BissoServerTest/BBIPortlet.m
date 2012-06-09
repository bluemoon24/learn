//
//  BBIPortlet.m
//  BissoServerTest
//
//  Created by Sim iPad on 09.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBIPortlet.h"
#import "Qresult.h"

@implementation BBIPortlet

@synthesize delegate;

- (BBIPortlet *) init
{
    self = [super init];
    return self;
}

- (NSString *)describePortlet
{
    return [super description];
}

- (void) serviceDidFinishLoading: (NSString *)service result:(Qresult *)qResult
{
    if (delegate) [delegate portletDidFinishLoading:self];
}

- (void) serviceDidStartLoading: (NSString *)service
{
    if (delegate) [delegate portletDidStartLoading:self];   
}
- (void) serviceWillStartLoadingFromSource:(NSString *)service
{
}

@end
