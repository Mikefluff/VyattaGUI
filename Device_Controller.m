//
//  Device_Controller.m
//  data_m
//
//  Created by Mike Fluff on 3/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Device_Controller.h"

#import "DeviceConfigurator.h"
#import "Test_Activity_Controller.h"

@implementation Device_Controller
@synthesize isConfigured;
@synthesize lock;
@synthesize delegate;
@synthesize TAC;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        NSLock *lock = [[NSLock alloc] init];
    }
    
    return self;
}

-(id)initWithIp:(NSString *)ipaddr login:(NSString *)log password:(NSString *)pass
{
	self = [super init];
    if (self) {
        iface = [[basher alloc] init];
        ip = ipaddr;
        login = log;
        password = pass;
        isAvailable = NO;
        png = [[pinger alloc] initWithController:self host:ip];
        tc = [[TestConfigurator alloc] init];
        config_hash = [[NSString alloc] initWithString:[NSString MyStringWithRandomUppercaseLetter:8]];
        
	}
    return self;
	
}

//this method uses to load pre-copied config on device
-(void)loadconfig
{
	NSArray *arguments = [[NSArray alloc] initWithObjects:config_hash,nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSObject *action = [defaults objectForKey:@"loadconfig"];
	[iface setAction:action];
    [iface initWithController:self addr:ip login:login password:password type:@"expect"];
    [iface startArgProcess:arguments];
    isConfigured = YES;
}

//this method moves config to device
-(BOOL)moveConfigToDevice
{
    NSString *file = [[NSString alloc] init];
    
    
    [iface initWithController:self addr:ip login:login password:password type:@"ssh"];
    [iface copyFile:[self saveStringConfigToFile:[tc returnConfig] withName:config_hash] toDestinition:[NSString stringWithFormat:@"/opt/vyatta/etc/config/%@", config_hash]];
   
    return YES;
}

//this method gets string config, save it in temporary file and return path to it
-(NSString *)saveStringConfigToFile:(NSString *)config withName:(NSString *)name
{
    NSURL *storeUrl = [NSURL fileURLWithPath:[@"/tmp/neo/" stringByAppendingPathComponent:name]];
    [config writeToURL:storeUrl atomically:YES encoding:NSASCIIStringEncoding error:NULL];
    return [storeUrl relativePath];
}


//this method is moving config to device and loading it
-(void)processConfig
{
    
    NSAutoreleasePool * pool;
    pool = [[NSAutoreleasePool alloc] init]; 
    
    while(true)
    {
    if([lock tryLock])
    {
        
    [self moveConfigToDevice];
        
    
        [lock unlock];
        
        break;
    }
    }
    [self loadconfig];
    
    [pool drain];
    [delegate threadFinished];
}


-(void)configureDeviceForTest:(NSString *)testType withIntNum:(NSInteger)links withPairsNum:(NSInteger)pairs side:(NSString *)side okt:(NSInteger)okt type:(NSString *)type
{
    [tc initWithTest:testType links:links pairs:pairs side:side oktet:okt type:type];
    
    
    
}





- (void)dealloc
{
    [super dealloc];
}

@end
