//
//  BBIBWQueryResultParserDelegate.m
//  BissoServerTest
//
//  Created by Sim iPad on 08.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <CoreData/CoreData.h>
#import "BBIBWQueryResultParserDelegate.h"
#import "BBIBWQueryResultFilterParserDelegate.h"

@implementation BBIBWQueryResultParserDelegate
@synthesize managedObjectContext;
@synthesize qResult;

Qresult *newQresult;
Filter *newFilter;
Variable *newVariable;
Item *newItem;
Unit *newUnit;
Value *newValue;

NSString *currentSection;
NSString *currentElement;

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSMutableDictionary *)attributeDict 
{
    
    currentElement = elementName;
    
    if ( [elementName isEqualToString:@"bmsbi:qresult"]) {
        NSLog(@"We saw the bmsbi:qresult element");
        newQresult = [NSEntityDescription
                                        insertNewObjectForEntityForName:@"Qresult"
                                        inManagedObjectContext:self.managedObjectContext];
    }
    else if ( [elementName isEqualToString:@"filterdescrstr"]) {
        newFilter = [NSEntityDescription
                      insertNewObjectForEntityForName:@"Filter"
                      inManagedObjectContext:self.managedObjectContext];
//       [newQresult addFiltersObject:(Filter *)newFilter];
       newQresult.filters =  [newQresult.filters setByAddingObject:newFilter]; 
        currentSection = @"filter";

    }
    else if ( [elementName isEqualToString:@"vardescrstr"]) {
        newVariable = [NSEntityDescription
                     insertNewObjectForEntityForName:@"Variable"
                     inManagedObjectContext:self.managedObjectContext];
//        [newQresult addVariablesObject:(Variable *)newVariable];
        newQresult.variables = [newQresult.variables setByAddingObject:newVariable]; 
        currentSection = @"variable";
        
    }
    else if ( [elementName isEqualToString:@"unit"]) {
        newUnit = [NSEntityDescription
                     insertNewObjectForEntityForName:@"Unit"
                     inManagedObjectContext:self.managedObjectContext];
//        [newQresult addUnitsObject:(Unit *)newUnit];
        newQresult.units = [newQresult.units setByAddingObject:newUnit]; 
        currentSection = @"unit";
    }
    else if ( [elementName isEqualToString:@"item"]) {
        newItem = [NSEntityDescription
                   insertNewObjectForEntityForName:@"Item"
                   inManagedObjectContext:self.managedObjectContext];
//        [newQresult addItemsObject:(Item *)newItem];
        newQresult.items = [newQresult.items setByAddingObject:newItem]; 
        currentSection = @"item";
        
    }

    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    if ([currentSection isEqualToString:@"filter"])
    {
        if ( [currentElement isEqualToString:@"descript"])        
        {
            newFilter.descr = [string copy];
        }
        else if ( [currentElement isEqualToString:@"infoobject"])        
        {
            newFilter.key = [string copy];
        }
        else if ( [currentElement isEqualToString:@"value"])        
        {
            newFilter.value = [string copy];
        }
        else {
            NSLog(@"Unknown filter element: %@", currentElement);
        }
    }
    
    else if ([currentSection isEqualToString:@"variable"])
    {
        if ( [currentElement isEqualToString:@"vnam"])        
        {
            newVariable.key = [string copy];
        }
        else if ( [currentElement isEqualToString:@"vnamdesc"])        
        {
            newVariable.name = [string copy];
        }
        else if ( [currentElement isEqualToString:@"infoobject"])        
        {
                //find filter element and link to it
            // newVariable.filter = ....
        }
        else if ( [currentElement isEqualToString:@"value"])        
        {
            newVariable.value = [string copy];
        }
        else {
            NSLog(@"Unknown variable element: %@", currentElement);
        }
    }
    else if ([currentSection isEqualToString:@"unit"])
    {
        if ( [currentElement isEqualToString:@"dim"])        
        {
            newUnit.dimension = [string copy];
        }
        else if ( [currentElement isEqualToString:@"name"])        
        {
            newUnit.key = [string copy];
        }
        else if ( [currentElement isEqualToString:@"desc"])        
        {
            newUnit.name = [string copy];
        }
        else {
            NSLog(@"Unknown unit element: %@.%@", currentSection, currentElement);
        }
    }
    else if ([currentSection isEqualToString:@"item"])
    {
        if ([currentElement length] > 3 && [[currentElement substringToIndex:3] isEqualToString:@"TXT"])        
        {
            NSLog(@"header element. %@", currentElement);
            newItem.header = [string copy];
        }
        else if ([currentElement length] > 4 && [[currentElement substringToIndex:5] isEqualToString:@"VALUE"]) {
            
            NSLog(@"value element. %@", currentElement);
            newValue = [NSEntityDescription
                              insertNewObjectForEntityForName:@"Value"
                              inManagedObjectContext:self.managedObjectContext];

            newItem.values = [newItem.values setByAddingObject:newValue];

            if (string != nil) 
                newValue.value = [NSNumber numberWithFloat:[string floatValue]];                    }
        
        else if ([currentElement length] == 4 && [[currentElement substringToIndex:1] isEqualToString:@"U"]) {
            NSLog(@"unit element. %@", currentElement);
            newValue.unit = [string copy];
        }
        else {
            NSLog(@"Unknown item element: %@", currentElement);
        }
    }


}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (elementName == currentSection) currentSection = nil;
    
    if ( [elementName isEqualToString:@"bmsbi:qresult"]) {
        NSLog(@"We saw the end of bmsbi:qresult element");
        NSLog(@"Qresult:%@", newQresult);
        qResult = newQresult;
    }
}


@end
