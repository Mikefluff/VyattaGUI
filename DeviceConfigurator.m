//
//  DeviceConfigurator.m
//  data_m
//
//  Created by Mike Fluff on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DeviceConfigurator.h"
#import "Device.h"
#import "Test_Activity_Controller.h"

@implementation DeviceConfigurator

@synthesize TAC;
@synthesize iperfClients;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
    }
    
    return self;
}
- (id)initWithTest:(NSString *)test withIntNum:(NSInteger)lnk withPairsNum:(NSInteger)prs devices:(NSSet *)devs
{
    self = [super init];
    if (self) {
        testType = [[NSString alloc] initWithString:test];
        links = lnk;
        pairs = prs;
        neocount = 1;
        devices = devs;
        iperfClients = [[NSMutableArray alloc] init];
        lock = [[NSLock alloc] init];
        threadcount = 0;
    }

return self;
}


-(id)neo
{
    
}

-(void)setNeo:(Device *)dev
{
    Neo_controller *neo = [[Neo_controller alloc] initWithIp:[dev valueForKey:@"manageip"]];
    
    [neo configureDeviceForTest:testType withIntNum:links withPairsNum:pairs side:nil okt:(10*neocount) type:@"Neo"];
    neocount++;
    
}

-(id)endpoint
{

}


//this method used to configure devices from devSet
-(void)configureDevices
{
    for (Device *dev in devices)
    {
       // NSLog(@"%@",[dev valueForKey:@"type"]);
        [self setValue:dev forKey:[dev valueForKey:@"type"]];  
                
    }
}


-(void)setEndpoint:(Device *)dev
{
    Endpoint_controller *endpoint = [[Endpoint_controller alloc] init];
    [endpoint setDelegate:self];
    [endpoint initWithIp:[dev valueForKey:@"manageip"] login:[dev valueForKey:@"login"] password:[dev valueForKey:@"password"]];
    
    endpoint.lock = lock;
    if([dev.isServer intValue] == YES)
    {
        [endpoint configureDeviceForTest:testType withIntNum:links withPairsNum:pairs side:@"Right" okt:10*([devices count]-1) type:@"Endpoint"]; 
     //   [lock lock];
        [NSThread detachNewThreadSelector:@selector(processConfig) toTarget:endpoint withObject:nil];
        
     //   [lock unlock];
     //   [lock lock];
        [NSThread detachNewThreadSelector:@selector(startEndpointPerfServer) toTarget:endpoint withObject:nil];
        threadcount++;
     //   [lock unlock];
   //     [endpoint processConfig];
        
    }
    else
    {
        [endpoint configureDeviceForTest:testType withIntNum:links withPairsNum:pairs side:@"Left" okt:10 type:@"Endpoint"];
      //  [lock lock];
        [NSThread detachNewThreadSelector:@selector(processConfig) toTarget:endpoint withObject:nil];
        threadcount++;
      //  [lock unlock];
   //     [endpoint processConfig];
        [iperfClients addObject:endpoint];
    }

}

- (void)threadFinished
{
    threadcount--;
    if(threadcount == 0)
        TAC.isConfigured = YES;
}

- (void)dealloc
{
    [super dealloc];
}

@end
