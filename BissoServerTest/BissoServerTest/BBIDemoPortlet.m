//
//  BBIDemoPortlet.m
//  BissoServerTest
//
//  Created by Sim iPad on 06.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBIDemoPortlet.h"
#import "DataManager/BBIDataManager.h"

@implementation BBIDemoPortlet

BBIDataManager *dm;

- (BBIDemoPortlet *) init
{
    self = [super init];
    dm = [[BBIDataManager alloc]init];
    dm.delegate = self;
    [dm getData:@"FakeBWRunQuery"];
    return self;
}

- (NSDictionary *) getParametersForBWRunQuery
{
NSDictionary *params;
    params = [[NSDictionary alloc] initWithObjectsAndKeys:
     @"S_SOA_DUMPDP21D_Q9102", @"queryName"
    , nil ];
return params;
}

@end
