//
//  BBIBissoAuthenticator.h
//  ClassTester
//
//  Created by Sim iPad on 30.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBIAuthenticatorDelegate.h"

@interface BBIBissoAuthenticator : NSObject  <NSXMLParserDelegate>

@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) NSDictionary *ticket;

- (id) initWithDelegateAndLoad:(id)delegate;

- (void) loadData;

@end
