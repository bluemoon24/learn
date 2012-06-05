//
//  BBIAuthenticatorDelegate.h
//  BissoServerTest
//
//  Created by Sim iPad on 05.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BBIAuthenticatorDelegate <NSObject>

- (void)didReceiveTicket:(NSDictionary *)ticket;

@end
