//
//  Endpoint_controller.h
//  data_m
//
//  Created by Mike Fluff on 17.02.11.
//  Copyright 2011 Altell ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Device_Controller.h"
#import "YBGraphView.h"

@protocol EndpointProtocol
- (void)processActiveResult:(NSArray *)result;
- (void)processFinished;
@end


@interface Endpoint_controller : Device_Controller {
	
    
	NSMutableArray *args;
	BOOL isStarted;
}


@property (nonatomic, readonly) BOOL isStarted;

-(void)startEndpointPerfServer;
-(void)startEndpointPerfClient:(NSNumber *)pairs;
-processFinished:(id)sender;

- (void)processActiveResult:(NSString *)result;



@end


