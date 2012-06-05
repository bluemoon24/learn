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
@property (nonatomic, retain) NSURL *bissoServer;
@property (nonatomic, retain) NSURLCredential *bissoCredential;
@property (nonatomic, retain) NSDictionary *ticket;

- (id) initWithBissoUrl: (NSURL *)url;
- (id) initWithBissoUrlAndCredential: (NSURL *)url :(NSURLCredential *)credential;
- (void) loadData;

@end
