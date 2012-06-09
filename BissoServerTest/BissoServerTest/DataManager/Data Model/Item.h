//
//  Item.h
//  BissoServerTest
//
//  Created by Sim iPad on 09.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Qresult, Value;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * header;
@property (nonatomic, retain) Qresult *qresult;
@property (nonatomic, retain) NSSet *values;
@end

@interface Item (CoreDataGeneratedAccessors)

- (void)addValuesObject:(Value *)value;
- (void)removeValuesObject:(Value *)value;
- (void)addValues:(NSSet *)values;
- (void)removeValues:(NSSet *)values;

@end
