//
//  BBIDemoPortlet.h
//  BissoServerTest
//
//  Created by Sim iPad on 06.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBIBWRunQueryDelegate.h"
#import "BBIPortlet.h"

@interface BBIDemoPortlet : BBIPortlet <BBIBWRunQueryDelegate>

- (NSString *) describePortlet;
- (NSDictionary *) getParametersForBWRunQuery;
- (void) refresh;
- (BBIDemoPortlet *) init;
@end
