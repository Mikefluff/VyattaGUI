//
//  pinger.m
//  data_m
//
//  Created by Mike Fluff on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "pinger.h"


@implementation pinger

- (void)dealloc
{
    [self->_pinger stop];
    [self->_pinger release];
    [self->_sendTimer invalidate];
    [self->_sendTimer release];
    [super dealloc];
}

@synthesize pinger    = _pinger;
@synthesize sendTimer = _sendTimer;

- (NSString *)_shortErrorFromError:(NSError *)error
// Given an NSError, returns a short error string that we can print, handling 
// some special cases along the way.
{
    NSString *      result;
    NSNumber *      failureNum;
    int             failure;
    const char *    failureStr;
    
    assert(error != nil);
    
    result = nil;
    
    // Handle DNS errors as a special case.
    
    if ( [[error domain] isEqual:(NSString *)kCFErrorDomainCFNetwork] && ([error code] == kCFHostErrorUnknown) ) {
        failureNum = [[error userInfo] objectForKey:(id)kCFGetAddrInfoFailureKey];
        if ( [failureNum isKindOfClass:[NSNumber class]] ) {
            failure = [failureNum intValue];
            if (failure != 0) {
                failureStr = gai_strerror(failure);
                if (failureStr != NULL) {
                    result = [NSString stringWithUTF8String:failureStr];
                    assert(result != nil);
                }
            }
        }
    }
    
    // Otherwise try various properties of the error object.
    
    if (result == nil) {
        result = [error localizedFailureReason];
    }
    if (result == nil) {
        result = [error localizedDescription];
    }
    if (result == nil) {
        result = [error description];
    }
    assert(result != nil);
    return result;
}

- (void)runWithHostName:(NSString *)hostName
// The Objective-C 'main' for this program.  It creates a SimplePing object 
// and runs the runloop sending pings and printing the results.
{
    assert(self.pinger == nil);
    
    self.pinger = [SimplePing simplePingWithHostName:hostName];
    assert(self.pinger != nil);
    
    self.pinger.delegate = self;
    [self.pinger start];
    
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    } while (self.pinger != nil);
}

- (void)sendPing
// Called to send a ping, both directly (as soon as the SimplePing object starts up) 
// and via a timer (to continue sending pings periodically).
{
    assert(self.pinger != nil);
    [self.pinger sendPingWithData:nil];
}

- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address
// A SimplePing delegate callback method.  We respond to the startup by sending a 
// ping immediately and starting a timer to continue sending them every second.
{
#pragma unused(pinger)
    assert(pinger == self.pinger);
    assert(address != nil);
    
    NSLog(@"pinging %@", DisplayAddressForAddress(address));
    
    // Send the first ping straight away.
    
    [self sendPing];
    
    // And start a timer to send the subsequent pings.
    
    assert(self.sendTimer == nil);
    self.sendTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendPing) userInfo:nil repeats:YES];
}

- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error
// A SimplePing delegate callback method.  We shut down our timer and the 
// SimplePing object itself, which causes the runloop code to exit.
{
#pragma unused(pinger)
    assert(pinger == self.pinger);
#pragma unused(error)
    NSLog(@"failed: %@", [self _shortErrorFromError:error]);
    
    [self.sendTimer invalidate];
    self.sendTimer = nil;
    
    // No need to call -stop.  The pinger will stop itself in this case.
    // We do however want to nil out pinger so that the runloop stops.
    
    self.pinger = nil;
}

- (void)simplePing:(SimplePing *)pinger didSendPacket:(NSData *)packet
// A SimplePing delegate callback method.  We just log the send.
{
/*#pragma unused(pinger)
    assert(pinger == self.pinger);
#pragma unused(packet)
    NSLog(@"#%u sent", (unsigned int) OSSwapBigToHostInt16(((const ICMPHeader *) [packet bytes])->sequenceNumber) );*/
	[control pingNotOK];
}

- (void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet error:(NSError *)error
// A SimplePing delegate callback method.  We just log the failure.
{
#pragma unused(pinger)
    assert(pinger == self.pinger);
#pragma unused(packet)
#pragma unused(error)
    NSLog(@"#%u send failed: %@", (unsigned int) OSSwapBigToHostInt16(((const ICMPHeader *) [packet bytes])->sequenceNumber), [self _shortErrorFromError:error]);
}

- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet
// A SimplePing delegate callback method.  We just log the reception of a ping response.
{
/*#pragma unused(pinger)
    assert(pinger == self.pinger);
#pragma unused(packet)
    NSLog(@"#%u received", (unsigned int) OSSwapBigToHostInt16([SimplePing icmpInPacket:packet]->sequenceNumber) );*/
	[control pingOK];
}

- (void)simplePing:(SimplePing *)pinger didReceiveUnexpectedPacket:(NSData *)packet
// A SimplePing delegate callback method.  We just log the receive.
{
    const ICMPHeader *  icmpPtr;
    
#pragma unused(pinger)
    assert(pinger == self.pinger);
#pragma unused(packet)
    
    icmpPtr = [SimplePing icmpInPacket:packet];
    if (icmpPtr != NULL) {
        NSLog(@"#%u unexpected ICMP type=%u, code=%u, identifier=%u", (unsigned int) OSSwapBigToHostInt16(icmpPtr->sequenceNumber), (unsigned int) icmpPtr->type, (unsigned int) icmpPtr->code, (unsigned int) OSSwapBigToHostInt16(icmpPtr->identifier) );
    } else {
        NSLog(@"unexpected packet size=%zu", (size_t) [packet length]);
    }
}

- (void)runPing
{
#pragma unused(argc)
#pragma unused(argv)
   NSAutoreleasePool * pool;
   // pinger *              mainObj;
//	[control self];
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
    
    if (host != nil) {
     //   mainObj = [[[pinger alloc] init] autorelease];
       // assert(mainObj != nil);
        [self runWithHostName:host];
       // [mainObj runWithHostName:host];
    } else {
        
        fprintf(stderr, "usage: %s host\n", getprogname());
    }
    
    [pool drain];
}

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    
    return self;
}
- (id)initWithController:(id <pingerProto>)cont host:(NSString *)hostname
{
	control = cont;
	host = hostname;
	return self;
}


@end
