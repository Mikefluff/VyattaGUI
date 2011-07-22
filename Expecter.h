//
//  Expecter.h
//  data_m
//
//  Created by Mike Fluff on 09.02.11.
//  Copyright 2011 Altell ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "expect.h"
#import "NSStringArgs.h"

FILE *fp;
@interface Expecter : NSObject {
		char *hostname;
		int port;
		char *username;
		char *password;
		char *key;
		char *keypub;
		int	fd;
		
	}
	
-(int) initWithHost:(char *)host port:(int) p user:(char *)user password:(char *)pass;
-(int) execCommand: (NSString *)commandline;
-(int) execParamCommand: (NSString *)commandline parameter:(id)param;
-(int) closeSession;
	
	
@end
