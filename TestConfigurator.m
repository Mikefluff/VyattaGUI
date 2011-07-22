//
//  TestConfigurator.m
//  data_m
//
//  Created by Mike Fluff on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestConfigurator.h"
#import "NSStringArgs.h"

@implementation TestConfigurator

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(id)initWithTest:(NSString *)tst links:(NSInteger)lnk pairs:(NSInteger)prs side:(NSString *)sde oktet:(NSInteger)okt type:(NSString *)type
{
    
        
    test = tst;
    links = lnk;
    pairs = prs;
    oktet = okt;
    side = sde;
    config = [[NSMutableString alloc] initWithString:[Interface_configurator configureInterfaces:links pairs:pairs side:side oktet:okt type:type]];
        
   

}

-(NSString *)returnConfig
{
    [config appendString:@"/* Warning: Do not remove the following line. */\n/* === vyatta-config-version: \"cluster@1:firewall@3:webproxy@1:wanloadbalance@2:nat@3:quagga@1:vrrp@1:system@3:ipsec@2:conntrack-sync@1:qos@1:smtpproxy@1:webgui@1\" === */\n"];
    return config;
}

//Router getter
- (id)router
{
  //  return [router valueForKey:@"config"];
}

//Router setter
-(void)setRouter:(id)test
{
    //NSLog(@"testOK");
    //router = [[Router_test alloc] init];
    //[router buildConfig:[[test valueForKey:@"pairs"] intValue]];
}

//Firewall getter
- (id)firewall
{
    //return [firewall valueForKey:@"config"];
}

//Firewall setter
-(void)setFirewall:(id)test
{
  //  firewall = [[Firewall_test alloc] init];
   // [firewall buildConfig:[[test valueForKey:@"pairs"] intValue]];
}
- (id)interfaces
{
    
}
- (void)setInterfaces:(id)test
{
    
}



- (void)dealloc
{
    [super dealloc];
}

@end
