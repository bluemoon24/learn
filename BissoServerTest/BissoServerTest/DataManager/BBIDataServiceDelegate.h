//
//  BBIDataServiceDelegate.h
//  BissoServerTest
//
//  Created by Sim iPad on 06.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BBIDataServiceDelegate <NSObject>

- (void) getData :(id)requestDescriptor;

@end
