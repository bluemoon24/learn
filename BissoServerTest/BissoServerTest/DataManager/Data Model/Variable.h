//
//  Variable.h
//  BissoServerTest
//
//  Created by Sim iPad on 09.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Qresult;

@interface Variable : NSManagedObject

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) Qresult *qresult;

@end
