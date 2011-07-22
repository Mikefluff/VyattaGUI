//
//  DeviceConfigurator.h
//  data_m
//
//  Created by Mike Fluff on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Device.h"
#import "Neo_controller.h"
#import "Endpoint_controller.h"

@class Test_Activity_Controller;

@interface DeviceConfigurator : NSObject {
    NSString *testType;
    Endpoint_controller *iperf_client;
    NSInteger links;
    NSInteger pairs;
    NSInteger neocount;
    NSSet *devices;
    Test_Activity_Controller *TAC;
    NSMutableArray *iperfClients;
    NSLock *lock;
    NSInteger threadcount;
@private
   
    
}
- (id)initWithTest:(NSString *)test withIntNum:(NSInteger)lnk withPairsNum:(NSInteger)prs devices:(NSSet *)devs;
-(void)configureDevices;
- (void)threadFinished;

@property (nonatomic, retain) Test_Activity_Controller *TAC;
@property (nonatomic, retain) NSMutableArray *iperfClients;

@end
