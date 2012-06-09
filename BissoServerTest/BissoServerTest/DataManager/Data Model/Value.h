//
//  Value.h
//  BissoServerTest
//
//  Created by Sim iPad on 09.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface Value : NSManagedObject

@property (nonatomic, retain) NSString * unit;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Item *item;

@end
