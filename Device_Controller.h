//
//  Device_Controller.h
//  data_m
//
//  Created by Mike Fluff on 3/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestConfigurator.h"
#import "basher.h"
#import "pinger.h"

@class Test_Activity_Controller;
@class DeviceConfigurator;

@protocol DeviceControllerProtocol

- (void)processFinished:(id)sender;

@end

@interface Device_Controller : NSObject <basherProto, pingerProto> {
    basher *iface;
    TestConfigurator *tc;
	BOOL isAvailable;
	NSString *ip;
	pinger *png;
	NSThread *pingThread;
    NSString *config_hash;
    
    BOOL isConfigured;
    NSString *login;
    NSString *password;
    NSLock *lock;
    
    id delegate;
    
    Test_Activity_Controller *TAC;
    
@private
    
}

@property (nonatomic, retain) Test_Activity_Controller *TAC;
@property (nonatomic, retain) id delegate;
@property (nonatomic, readonly) BOOL isConfigured;
@property (nonatomic, retain) NSLock *lock;

-(id)initWithIp:(NSString *)ipaddr login:(NSString *)log password:(NSString *)pass;
-(void)startConnectionType:(NSString *)typ;
-(void)setint:(NSString *)name addr:(NSString *)ip;
-(void)loadconfig:(NSString *)name;

-(BOOL)checkAvaliability;
-(void)pingDevice;

-(void)configureDeviceForTest:(NSString *)testType withIntNum:(NSInteger)links withPairsNum:(NSInteger)pairs side:(NSString *)side okt:(NSInteger)okt type:(NSString *)type;

-(void)processConfig;

//pingerProto

-(void)pingOK;
-(void)pingNotOK;


@end
