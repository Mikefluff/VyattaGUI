//
//  configBuilder.m
//  data_m
//
//  Created by Mike Fluff on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "configBuilder.h"


@implementation configBuilder

@synthesize config;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

//this method generate ip-list for testing purposes
+ (NSArray *) ipList:(NSInteger)number side:(NSString *)side oktet:(NSInteger)okt
{
    NSInteger c;
    if ([side isEqualToString:@"Left"])
    {
        c = 1;
    }
    
    else 
    {
        c = 2;
    }
    NSInteger a = 1;
    NSInteger b = 0;
    NSMutableArray *iplist = [[NSMutableArray alloc] initWithCapacity:number];
    for (int i=1; i <= number; i++)
    {
        
        NSString *ip = [[NSString alloc] initWithFormat:@"%d.%d.%d.%d",okt,a,b++,c];
        if(b == 254)
        {
            b = 1;
            a++;
        }
        [iplist addObject:ip];
    }
    return iplist;
}

//this method build config from prototype template
+ (NSString *)buildStrWithFormat:(NSString *)format fromArray:(NSArray *)array
{
    NSMutableString *str = [[NSMutableString alloc] init];
    NSInteger i = 1;
    for (NSString *ip in array)
    {
        NSString *form = [format stringByReplacingOccurrencesOfString:@"!num" withString:[NSString stringWithFormat:@"%d",i++]];
        str = [str stringByAppendingString:[form stringByReplacingOccurrencesOfString:@"!ip" withString:ip]];
    }
    return str;
}




- (void)dealloc
{
    [super dealloc];
}

@end
