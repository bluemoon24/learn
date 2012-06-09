//
//  Qresult.h
//  BissoServerTest
//
//  Created by Sim iPad on 09.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Filter, Item, Unit, Variable;

@interface Qresult : NSManagedObject

@property (nonatomic, retain) NSNumber * requestID;
@property (nonatomic, retain) NSString * requestURL;
@property (nonatomic, retain) NSSet *filters;
@property (nonatomic, retain) NSSet *items;
@property (nonatomic, retain) NSSet *units;
@property (nonatomic, retain) NSSet *variables;
@end

@interface Qresult (CoreDataGeneratedAccessors)

- (void)addFiltersObject:(Filter *)value;
- (void)removeFiltersObject:(Filter *)value;
- (void)addFilters:(NSSet *)values;
- (void)removeFilters:(NSSet *)values;

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

- (void)addUnitsObject:(Unit *)value;
- (void)removeUnitsObject:(Unit *)value;
- (void)addUnits:(NSSet *)values;
- (void)removeUnits:(NSSet *)values;

- (void)addVariablesObject:(Variable *)value;
- (void)removeVariablesObject:(Variable *)value;
- (void)addVariables:(NSSet *)values;
- (void)removeVariables:(NSSet *)values;

@end
