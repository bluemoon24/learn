//
//  BBIBWQueryResultFilterParserDelegate.h
//  BissoServerTest
//
//  Created by Sim iPad on 08.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Data Model/Filter.h"

@interface BBIBWQueryResultFilterParserDelegate : NSObject

@property (nonatomic, retain) id parentDelegate;
@property (nonatomic, retain) Filter *filter;

@end
