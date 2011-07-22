//
//  Interface_configurator.m
//  data_m
//
//  Created by Mike Fluff on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Interface_configurator.h"


@implementation Interface_configurator

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+(NSString *)configureInterfaces:(NSInteger)links pairs:(NSInteger)pairs side:(NSString *)side oktet:(NSInteger)okt type:(NSString *)type
{
    int count;
    count = pairs/links;
    int k=0;
    NSMutableString *conf = [NSMutableString stringWithString:@"interfaces {\n"];
    NSArray *iplist = [[NSArray alloc] init];
    if([type isEqualToString:@"Endpoint"])
    {
       iplist = [self ipList:pairs side:side oktet:okt];
    }
    else
    {
        NSMutableArray *iplists = [[NSMutableArray alloc] init];
        [iplists addObjectsFromArray:[self ipList:pairs side:@"Right" oktet:okt]];
        [iplists addObjectsFromArray:[self ipList:pairs side:@"Left" oktet:okt+10]];
        iplist = iplists;
        links = links*2;
    } 
    if(count == 1)
    {
        for(int i=1;i<=links;i++)
        {
            conf = [conf stringByAppendingFormat:@"ethernet eth%d {\naddress %@/24\n}\n",i,[iplist objectAtIndex:i]];
        }
    }
    else
    {
    for(int i=1;i<=links;i++)
        {
            conf =  [conf stringByAppendingFormat:@"ethernet eth%d {\n",i];
            for(int j=0; j<count; j++)
            {
               conf = [conf stringByAppendingFormat:@"vif %d {\naddress %@/24\n", j, [iplist objectAtIndex:k++]];
               conf = [conf stringByAppendingString:@"}\n"];
            }
            conf =[conf stringByAppendingString:@"}\n"];
        }
        
    }
    conf = [conf stringByAppendingString:@"}\n"];
    
   NSLog(@"%@",conf); 
    return conf;
}

+(NSString *)configureRoutes:(NSInteger)pairs to:(NSInteger)to via:(NSInteger)via side:(NSString *)side
{
    NSArray *to_iplist = [self ipList:pairs side:side oktet:to];
    NSArray *via_iplist = [self ipList:pairs side:side oktet:via];
    NSMutableString *conf = [NSMutableString stringWithString:@"protocols {\nstatic {\n"]; 
    for(int i=0;i<pairs;i++)
    {
        conf = [conf stringByAppendingFormat:@"route %@ {\n\tnext-hop %@{\n}\n}\n",[to_iplist objectAtIndex:i],[via_iplist objectAtIndex:i]];
    }
    conf = [conf stringByAppendingFormat:@"}\n}\n"];
  //  NSLog(@"%@",conf);
    return conf;            
    
}


- (void)dealloc
{
    [super dealloc];
}

@end
