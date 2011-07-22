//
//  pinger.h
//  data_m
//
//  Created by Mike Fluff on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "SimplePing.h"

#include <sys/socket.h>
#include <netdb.h>

#pragma mark * Utilities

static NSString * DisplayAddressForAddress(NSData * address)
// Returns a dotted decimal string for the specified address (a (struct sockaddr) 
// within the address NSData).
{
    int         err;
    NSString *  result;
    char        hostStr[NI_MAXHOST];
    
    result = nil;
    
    if (address != nil) {
        err = getnameinfo([address bytes], (socklen_t) [address length], hostStr, sizeof(hostStr), NULL, 0, NI_NUMERICHOST);
        if (err == 0) {
            result = [NSString stringWithCString:hostStr encoding:NSASCIIStringEncoding];
            assert(result != nil);
        }
    }
    
    return result;
}
@protocol pingerProto
- (void)pingOK;
- (void)pingNotOK;
@end

@interface pinger : NSObject <SimplePingDelegate> {
    SimplePing *    _pinger;
    NSTimer *       _sendTimer;
    BOOL            _done;
	id <pingerProto>control;
	NSString *		host;
	
@private
    
}
- (void)runWithHostName:(NSString *)hostName;
- (id)initWithController:(id <pingerProto>)cont host:(NSString *)hostname;
- (void)runPing;

@property (nonatomic, retain, readwrite) SimplePing *   pinger;
@property (nonatomic, retain, readwrite) NSTimer *      sendTimer;
@end
