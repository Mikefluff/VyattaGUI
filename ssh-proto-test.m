//
//  ssh-proto-test.m
//  data_m
//
//  Created by Mike Fluff on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ssh-proto-test.h"
#import "NSStringArgs.h"


int ind = 0;
int graphs = 0;

@implementation ssh_proto_test

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        data = [[NSMutableArray alloc] init];
        [self openTestGraph:self];
        indexer = [[NSMutableArray alloc] init];
        for(int i=0;i<=100;i++)
        [indexer addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    return self;
}
- (void)runTest
{
   // for(int ind=0;ind<1;ind++)
   // {
    ssh *myssh = [[[ssh alloc] init] retain];
    
    // get the libssh2 version
    [myssh libssh2ver];
    NSInteger err = [myssh initWithHost: "192.168.253.1"
                                   port: 22
                                   user: "mikefluff"
                               password: "qwe123"];
	NSArray *arg = [NSArray arrayWithObjects:self,@"iperf -c 127.0.0.1 -t 50 -i 1 -y C & iperf -c 192.168.0.2 -t 50 -i 1 -y C &",[NSNumber numberWithInt:ind],nil];
    
   /* NSInteger err = [myssh initWithHost: "192.168.253.130"
                                   port: 22
                                   user: "vyatta"
                               password: "vyatta"];
	NSArray *arg = [NSArray arrayWithObjects:self,@"iperf -c 127.0.0.1 -t 50 -i 1 -y C & iperf -c 192.168.0.2 -t 50 -i 1 -y C &",[NSNumber numberWithInt:ind],nil];*/
	// log in to server using public key
	
    //		id obj = [ssh new];
    for (int i=0;i<2;i++)
    {
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:@"0", nil];
    
    [data addObject:arr];
    }
    graphs = [data count];
    [graphview draw];
    
    if(err==0)
    {
    NSThread *thr = [[NSThread alloc] initWithTarget:myssh selector:@selector(execWithController:) object:arg];
    
	[thr start];
        
    }
   // }
 //   ind++;
//    [NSThread detachNewThreadSelector:@selector(execWithController:) toTarget:myssh withObject:arg];
  //  NSLog(@"%d",err);
    
    
    
}

- (void)processActiveResult:(NSArray *)result
{
    //NSArray *results = [result csvRows];
    NSArray *results = [[result objectAtIndex:0] componentsSeparatedByString:@","];
    
        
     NSLog(@"%@",[results objectAtIndex:3]);
    
    NSScanner* scan = [NSScanner scannerWithString:[results objectAtIndex:8]]; 
    long long val;
    [scan scanLongLong:&val];
    int res = val/(1024*1024);
    NSLog(@"%d",res);
    
    if([[results objectAtIndex:3] isEqualToString:@"127.0.0.1"])
    {
    
    if([data objectAtIndex:0])
    [[data objectAtIndex:0] addObject:[NSString stringWithFormat:@"%d",res]];
    }
    else 
    {
        if([data objectAtIndex:1])
            [[data objectAtIndex:1] addObject:[NSString stringWithFormat:@"%d",res]]; 
    }
    [graphview draw];
    
    
}
- (void)processResult:(NSString *)result
{
    NSLog(@"%@",result);
    NSLog(@"\n");
    NSLog(@"test");
}


- (NSInteger)numberOfGraphsInGraphView:(YBGraphView *)graph {
    
	return graphs;
    
}

- (NSArray *)graphView:(YBGraphView *)graph valuesForGraph:(NSInteger)index {
	
    //	NSString *returnString = [NSString stringWithFormat:@"%d", data];
	
    //	self.list1 = [[NSArray alloc] initWithObjects:@"10",returnString,@"30",@"4",@"5",nil];
	
    //	data = data + 5;
	
    //list1 = [NSArray arrayWithArray:data];
    // return data;
	//NSArray *arr = [[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
    
    return [data objectAtIndex:index];
}

- (NSArray *)seriesForGraphView:(YBGraphView *)graph {
    
    //self.list2 = [[NSArray alloc] initWithObjects:@"1s",@"2s",@"3s",@"4s",@"5s",nil];
	
    //	list2 = [NSArray arrayWithArray:count];
    // return list2;
  //  NSArray *arr = [[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
	
    return indexer;
	
	
}

-(IBAction)openTestGraph:(id)sender
{
    
    NSRect frame = NSMakeRect(300, 400, 400, 200);
    NSWindow* window  = [[NSWindow alloc] initWithContentRect:frame
                                                    styleMask:NSTitledWindowMask |NSClosableWindowMask
                                                      backing:NSBackingStoreBuffered
                                                        defer:NO];
    [window makeKeyAndOrderFront:NSApp];
    graphview = [[YBGraphView alloc] init];
    [graphview setDelegate:self];
    [graphview setDataSource:self];
    
    //   [view addSubview:graphview];
    [graphview draw];
    [window setContentView:graphview];
    
}




- (void)dealloc
{
  //  [super dealloc];
}

@end
