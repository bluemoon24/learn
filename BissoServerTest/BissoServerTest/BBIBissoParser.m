//
//  BBIBissoParser.m
//  ClassTester
//
//  Created by Sim iPad on 30.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBIBissoParser.h"

@implementation BBIBissoParser


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict 
{
    
    if ( [elementName isEqualToString:@"termin"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dataLoaded" object:attributeDict];
    }
    
}

@end
