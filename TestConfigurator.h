//
//  TestConfigurator.h
//  data_m
//
//  Created by Mike Fluff on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tests.h"
#import "Router_test.h"
#import "Firewall_test.h"
#import "Interface_configurator.h"



@interface TestConfigurator : NSObject {
    
    IBOutlet id delegate;
    NSMutableString *config;
    NSString *test;
    NSInteger links;
    NSInteger pairs;
    NSInteger oktet;
    NSString *side;
    
    
      
@private
    
}


-(id)initWithTest:(NSString *)tst links:(NSInteger)lnk pairs:(NSInteger)prs side:(NSString *)sde oktet:(NSInteger)okt;
-(NSString *)returnConfig;

@end
