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

NSString *myService = @"FakeBWRunQuery";

- (BBIDemoPortlet *) init
{
    self = [super init];
    dm = [[BBIDataManager alloc]init];
    dm.delegate = self;
    [self refresh];
    return self;
}

- (void) refresh
{
    [dm getData:myService];    
}

- (NSString *)describePortlet
{
    NSString *describe;
    describe = [describe initWithString:[super description]];
    describe = [describe stringByAppendingFormat:@"Service: %@\nqResult:%@", myService, dm.qResult];
    return describe;
}

#pragma mark - BBIBWRunQueryDelegate

- (NSDictionary *) getParametersForBWRunQuery
{
    NSDictionary *params;
    params = [[NSDictionary alloc] 
              initWithObjectsAndKeys: @"S_SOA_DUMPDP21D_Q9102",@"queryName", nil ];
    return params;
}


@end
