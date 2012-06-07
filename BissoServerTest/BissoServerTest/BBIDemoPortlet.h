//
//  BBIDemoPortlet.h
//  BissoServerTest
//
//  Created by Sim iPad on 06.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBIBWRunQueryDelegate.h"

@interface BBIDemoPortlet : NSObject <BBIBWRunQueryDelegate>

- (NSDictionary *) getParametersForBWRunQuery;

@end
