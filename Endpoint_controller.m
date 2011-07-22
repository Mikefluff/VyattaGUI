//
//  Endpoint_controller.m
//  data_m
//
//  Created by Mike Fluff on 17.02.11.
//  Copyright 2011 Altell ltd. All rights reserved.
//

#import "Endpoint_controller.h"
#import "NSStringArgs.h"
#import "configBuilder.h"
#import "DeviceConfigurator.h"

@implementation Endpoint_controller

@synthesize isStarted;









-(void)startEndpointPerfServer
{
	NSAutoreleasePool * pool;
    pool = [[NSAutoreleasePool alloc] init];
    while(true)
    {
    if([lock tryLock])
    {
        
        [iface startProcess:@"iperf"];
        isStarted = YES;
        [delegate threadFinished];
        [lock unlock];
        break;
    }
    }
    [pool drain];
    
}

-(void)startEndpointPerfClient:(NSNumber *)pairs;
{
    
    NSArray *PairsIps = [configBuilder ipList:[pairs intValue] side:@"Right" oktet:10];
    NSMutableString *action = [[NSMutableString alloc] init];
        
    for(NSString *ip in PairsIps)
    {
        [action appendFormat:@"iperf -c %@ -t 100 -i 1 -y C& ",ip];
    }
    
    while(true)
    {
       if([TAC isConfigured])
       {
           self.delegate = TAC;
           [iface setDelegate:self];
           NSLog(@"%@",action);
           [iface setAction:action];
           [iface runAction];
           break;
       }
        
    
	}	
		
	
}
- (void)processActiveResult:(NSString *)result
{ 
  //  NSLog(@"%@",result);
    NSArray *results = [result componentsSeparatedByString:@","];
    [delegate processActiveResult:results];
}


- (void)processFinished:(id)sender;
{
	NSArray *result = [sender csvRows]; 
	NSMutableArray *perf = [[NSMutableArray alloc] initWithCapacity:([result count] - 1)];
	NSInteger i=1;
	int median;
	for (NSArray *arr in result)
	{
		if (i < [result count])
		{
		[perf addObject:[NSNumber numberWithInt:[[arr objectAtIndex:8] intValue]]];
			i++;
		}
	else {
		median = [[arr objectAtIndex:8] intValue];
	}
		
	}
	int min = [[perf valueForKeyPath:@"@min.intValue"] intValue];
	int max = [[perf valueForKeyPath:@"@max.intValue"] intValue];
	NSLog(@"%d %d %d", min, median, max);
		
}





@end
