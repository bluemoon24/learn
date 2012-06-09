//
//  BBIBWRunQueryDelegate.h
//  BissoServerTest
//
//  Created by Sim iPad on 06.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Qresult.h"

@protocol BBIBWRunQueryDelegate <NSObject>

- (NSDictionary *) getParametersForBWRunQuery;
- (void) serviceDidFinishLoading: result:(Qresult *)qResult;
- (void) serviceDidStartLoading;
@end
