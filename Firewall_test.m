//
//  Firewall_test.m
//  data_m
//
//  Created by Mike Fluff on 16.02.11.
//  Copyright 2011 Altell ltd. All rights reserved.
//

#import "Firewall_test.h"


@implementation Firewall_test


+(NSString *)buildConfig:(NSInteger)num
{
    NSString *pre = [[NSString alloc] initWithString:@"firewall {\nall-ping enable\nbroadcast-ping disable\nconntrack-expect-table-size 4096\nconntrack-hash-size 4096\nconntrack-table-size 32768\nconntrack-tcp-loose enable\nip-src-route disable\nipv6-receive-redirects disable\nipv6-src-route disable\nl7-numpackets 10\nlog-martians enable\nname test {\ndefault-action accept\n"];
	NSString *body = [[NSString alloc] initWithString:@"rule !num {\naction drop\ndestination {\naddress 1.1.1.1\n}\nsource {\naddress !ip\n}\n}\n"];
	NSString *post = [[NSString alloc] initWithString:@"}\nreceive-redirects disable\nsend-redirects enable\nsource-validation disable\nsyn-cookies enable\n}\n"];
	NSArray *iplist = [self ipList:num side:@"left" oktet:10];
	body = [self buildStrWithFormat:body fromArray:iplist];
	
	NSMutableString *string = [[NSMutableString alloc] init];
	NSArray *config = [[NSArray alloc] initWithObjects:pre,body,post,nil];
	for (NSString *str in config)
	{
		string = [string stringByAppendingString:str];
	}
    return string;
}






@end
