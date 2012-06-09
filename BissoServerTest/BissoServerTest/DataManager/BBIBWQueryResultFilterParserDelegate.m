//
//  BBIBWQueryResultFilterParserDelegate.m
//  BissoServerTest
//
//  Created by Sim iPad on 08.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "BBIBWQueryResultFilterParserDelegate.h"

Filter *newFilter;

@implementation BBIBWQueryResultFilterParserDelegate
@synthesize parentDelegate;
@synthesize filter;

NSString *currentElement;

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSMutableDictionary *)attributeDict 
{
    currentElement = [elementName copy];
    
    if ( [currentElement isEqualToString:@"filterdescrstr"]) {
//        filter.descr = [filter.descr initWithString:string];
    }

    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    if ( [currentElement isEqualToString:@"descript"]) {
        filter.descr = [filter.descr initWithString:string];
    }
    else if ( [currentElement isEqualToString:@"infoobject"]) {
        filter.key = [filter.key initWithString:string];
    }
    else if ( [currentElement isEqualToString:@"value"]) {
        filter.value = [filter.value initWithString:string];
    }
    else if ([currentElement isEqualToString:@"fieldname"]) {
        NSLog(@"fieldname element.");
    }
    else if ([[currentElement substringToIndex:5] isEqualToString:@"VALUE"]) {
        NSLog(@"value element. %@", currentElement);
    }
    else if ([currentElement length] == 4 && [[currentElement substringToIndex:5] isEqualToString:@"U"]) {
        NSLog(@"unit element. %@", currentElement);
    }
    else {
        NSLog(@"BBIBWQueryResultFilterParserDelegate: unexpected element: %@", currentElement);
    }
    
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ( [elementName isEqualToString:@"filterdescrstr"]) {
        [parser setDelegate: parentDelegate];
    }
}
@end
