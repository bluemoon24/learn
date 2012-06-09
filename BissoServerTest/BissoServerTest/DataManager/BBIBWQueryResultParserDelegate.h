//
//  BBIBWQueryResultParserDelegate.h
//  BissoServerTest
//
//  Created by Sim iPad on 08.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Data Model/Qresult.h"
#import "Data Model/Filter.h"
#import "Data Model/Variable.h"
#import "Data Model/Item.h"
#import "Data Model/Unit.h"
#import "Data Model/Value.h"

@interface BBIBWQueryResultParserDelegate : NSObject <NSXMLParserDelegate>
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) Qresult *qResult;


@end
