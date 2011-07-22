//
//  Test_Activity_Controller.m
//  data_m
//
//  Created by Mike Fluff on 3/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Test_Activity_Controller.h"
#import "NSTableView+Menu.h"


@implementation Test_Activity_Controller
@synthesize testThread, progress, delegate, TestIndex, isConfigured;


//constructor
- (id)init {
    if ((self = [super init])) {
        
        graphs_fabric = [[YBGraphs_fabric alloc] initWithWindowNibName:@"GraphicsWindow"];
        pairs = [[NSString alloc] init];
        [graphs_fabric setDelegate:self];
       // graphs_fabric = [[YBGraphs_fabric alloc] init];
        testsArray = [[NSMutableArray alloc] init];
       // graphData = [[NSMutableDictionary alloc] init];
        
        progress = [[NSProgressIndicator alloc] init];
        [progress setControlSize:NSSmallControlSize];
        [progress setIndeterminate:NO];
        
        // [progress incrementBy:20];
       /* for(int i=1;i<=50;i++)
        {
            activeTest *data = [[activeTest alloc] init];
            data.tests = [NSString stringWithFormat:@"pair %d",i];
            data.status = @"inactive";
            [testsArray addObject:data];
            
        }*/
            }
    
    return self;
}

- (BOOL)tableView:(NSTableView *)aTableView shouldSelectTableColumn:(NSTableColumn *)aTableColumn
{
    if([[aTableColumn identifier] isEqualToString:@"Status"])
    {
        return NO;
    }
    return YES;
    
}
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    
    
    
}

- (id)tableColumn:(NSTableColumn *)column inTableView:(NSTableView *)tableView dataCellForRow:(int)row;
{
     if(row==[TestIndex longValue] && TestIndex != nil && testRun == YES)
    return [[ProgressCell alloc] initProgressCell:progress];
     else return [[NSTextFieldCell alloc] init];
}


/*- (NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
   // NSLog(@"%@",[tableColumn identifier]);
  //  NSLog(@"%d",[testThread isExecuting]);
 //   NSLog(@"%ld",row);
    if([[tableColumn identifier] isEqualToString:@"Status"] && row==[TestIndex longValue] && TestIndex != nil)
    {
     
        if([testThread isExecuting] == YES)
        {
               
           // if([[tableColumn dataCell] isKindOfClass:[NSTextFieldCell class]])
            {
             //   [[tableColumn dataCell] removeFromSuperview];
        //        NSLog(@"%d",[[tableColumn dataCell] isKindOfClass:[ProgressCell class]]); 
             //   ImageAndTextCell *imageAndTextCell = (ImageAndTextCell *)cell;
                [tableColumn setDataCell:[[ProgressCell alloc] initProgressCell:progress]];
        //         NSLog(@"%d",[[tableColumn dataCell] isKindOfClass:[ProgressCell class]]);
                 //  [[tableColumn dataCell] setProgress:progress];
               // [[tableColumn dataCell] release];
            }  
               
                
        
        
        } 
        else 
        {
            
          //  if([[tableColumn dataCell] isKindOfClass:[ProgressCell class]])
           // {
               // NSLog(@"%ld",[TestIndex longValue]);
                [progress removeFromSuperview];
               
          //  }
            [tableColumn setDataCell:[[NSTextFieldCell alloc] init]];
            [[tableColumn dataCell] setPlaceholderString:@"stopped"];
        }
    }
  //  NSLog(@"%d - %d", row,[[tableColumn dataCell] isKindOfClass:[ProgressCell class]]);
        return [tableColumn dataCell];

               
}


/*- (void)tableView:(NSTableView *)aTableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
	
/*	if ([aCell isKindOfClass:[BDDiscreteProgressCell class]])
	{
		[aCell setProgress:[obj discreteProgress]];
		[aTableView addSubview:[obj discreteProgress]];
	}
	if ([[aTableColumn identifier] isEqualToString:@"Status"])
         {
    if ([aCell isKindOfClass:[BDContinuousProgressCell class]])
	{
		NSLog(@"%d",rowIndex);
        if(rowIndex == 1)
        {
        //NSProgressIndicator *progress = [[NSProgressIndicator alloc] init];
        [aCell setProgress:progress];
	//	[aTableView addSubview:progress];
        }
	}
         }
}*/



-(id)initWithTest:(id)test {
        
//lets check if we run the same test again
    if([test objectAtIndex:0] != testToConf)
    {
    isConfigured = NO;
    testToConf = [test objectAtIndex:0];
    
    
    
    NSSet *pairss = [testToConf valueForKey:@"Pairs"];
    pairs = [pairss count];
    
    for(Pairs *obj in pairss)
        if([obj.enabled intValue] == YES)
            [testsArray addObject:obj];
    
//[self prepareContent:test];
    NSSet *devices = [testToConf valueForKey:@"Devices"];
    DeviceConfigurator *dc = [[DeviceConfigurator alloc] initWithTest:[testToConf valueForKey:@"Type"] withIntNum:[[testToConf valueForKey:@"Links"] intValue] withPairsNum:pairs devices:devices];
    dc.TAC = self;
    [dc configureDevices];
    iperfClients = [[NSArray alloc] initWithArray:dc.iperfClients];
    }
    
    
 
}



-(void)startTests
{
    
    
 // NSLog(@"%d",[TestIndex intValue]);
    graphData = [[NSMutableDictionary alloc] init];
 //   graph_test *test = [[graph_test alloc] init];
    
 //   usleep(1000);
//    [test setController:self];
 //   [test generateTraffic];
 //   NSLog(@"%d",[[testToConf valueForKey:@"Pairs"] intValue]);
    reportNum = [[testToConf valueForKey:@"children"] count];
    
    for(Endpoint_controller *ep in iperfClients)
    {
        ep.TAC = self;
        [ep startEndpointPerfClient:[NSNumber numberWithInt:[testsArray count]]];
        
    }
    testRun = YES;
    /*  if([testThread isExecuting] == NO)
    {
    testThread = [[NSThread alloc] initWithTarget:test selector:@selector(generateTraffic:) object:[NSNumber numberWithInt:pairs]];
    [testThread start];
       
    }
    else
    {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setAlertStyle:NSInformationalAlertStyle];
        [alert setMessageText:@"Test already started"];
        [alert setAlertStyle:NSWarningAlertStyle]; 
        [alert runModal];
    }*/
    
    
    
    
    pairsfinished = 0;
    
    
    
    
}


//this method stop tests
-(void)stopTests
{
    

    if([testThread isExecuting] == YES)
    {
    [testThread cancel];
        
    [[delegate toolbar] validateVisibleItems];
  
   /* for(id obj in testsArray)
    {
        [obj setValue:@"canceled" forKey:@"status"];
    }
    }*/
    }
    else
    {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setAlertStyle:NSInformationalAlertStyle];
        [alert setMessageText:@"Test is not started"];
        [alert setAlertStyle:NSWarningAlertStyle]; 
        [alert runModal];
    }
    
    
}

//this method opens graphs in tabwindow
-(IBAction)openTestGraph:(id)sender
{
        
    
    [graphs_fabric showWindow:self];
	[graphs_fabric openGraphs:[testsArrayController selectionIndexes]];

}



//this method is callback result parser

- (void)processActiveResult:(NSArray *)results
{
    
    //parsing performance result
    NSScanner* scan = [NSScanner scannerWithString:[results objectAtIndex:8]]; 
    long long val;
    [scan scanLongLong:&val];
    int res = val/(1024*1024);

//pushing result to coresponing member of graphData
    NSString *index = [[[results objectAtIndex:3] componentsSeparatedByString:@"."]objectAtIndex:2];
    //NSLog(@"%@",index);
    NSString *resu = [[NSString alloc] initWithFormat:@"%d",res];
    if([graphData objectForKey:index] != nil)
        [[graphData objectForKey:index] addObject:resu];
    else [graphData setValue:[NSMutableArray arrayWithObject:resu] forKey:index];

    
    //here we reload Graphics sometimes
    if(([index intValue]+1) == pairs)
        [graphs_fabric reloadGraphs];
    [progress setDoubleValue:[[[[results objectAtIndex:6] componentsSeparatedByString:@"-"] objectAtIndex:1] doubleValue]];
//check if pair is finished
    if([[[[results objectAtIndex:6] componentsSeparatedByString:@"-"] objectAtIndex:1] isEqualToString:@"100.0"])
    {
        
        pairsfinished++;
        
//here we check that all pairs are finished and starting cleanup
        if((pairsfinished+1) == pairs)
        { 
            
            testRun = NO;
            int answer = NSRunAlertPanel(@"Process Finished",@"Save results?",
                                         @"Save",@"Cancel", nil);
            if(answer == NSAlertDefaultReturn)
                
            {
                NSOperationQueue *queue = [[NSOperationQueue alloc] init];
                [queue addOperationWithBlock:^{
                    [self storeResults];
                }];
                
            }
            [[delegate toolbar] validateVisibleItems];
            
        }
    }


}

-(void)storeResults
{
    [[delegate testsTable] setHidden:YES];
    Reports *report = [NSEntityDescription insertNewObjectForEntityForName:@"Reports" inManagedObjectContext:[self managedObjectContext]];
    report.parent = testToConf;
    report.Pairs = [NSSet setWithArray:testsArray];
    
    
    for(int i=0;i<[testsArray count];i++)
    {
       // NSMutableSet *dataSet = [[NSMutableSet alloc] init];
        NSString *index = [NSString stringWithFormat:@"%d",i];
        NSArray *dataArray = [graphData objectForKey:index];
        for(int j=0;j<[dataArray count];j++)
        {
            Results *result = [NSEntityDescription insertNewObjectForEntityForName:@"Results" inManagedObjectContext:[self managedObjectContext]];
            result.id = [NSNumber numberWithInt:j];
        //    NSLog(@"%d",[[dataArray objectAtIndex:j] intValue]);
            result.data = [NSNumber numberWithInt:[[dataArray objectAtIndex:j] intValue]];
            result.Report = report;
            result.Pair = [testsArray objectAtIndex:i];
            // [dataSet addObject:result];
         
        }
       
       // [[testsArray objectAtIndex:i] setValue:dataSet forKey:@"Results"];
        [[self managedObjectContext] processPendingChanges];
        

    }
   
    NSLog(@"results stored");
    report.parent = testToConf;
    report.date = [NSDate date];
    [[delegate testsTable] setHidden:NO];
    NSLog(@"%@",[NSString stringWithFormat:@"report #%d",(reportNum+1)]);
    report.id = [NSString stringWithFormat:@"report #%d",(reportNum+1)];
    
    //  NSLog(@"%@",[test valueForKey:@"id"]);
    
    [[self managedObjectContext] processPendingChanges];
    
}

//graphDataSource protocol method
-(NSArray *)getDataForGraph:(NSInteger)graph
{
    return [graphData objectForKey:[NSString stringWithFormat:@"%d",graph]];
}


//this method used to build menu in pairs Table
- (NSMenu*)tableView:(NSTableView*)aTableView menuForRows:(NSIndexSet*)rows
{
    NSMenu *listOfCalendars = [[NSMenu alloc] initWithTitle:@""];
	NSMenuItem *currentItem = [[NSMenuItem alloc] initWithTitle:@"Show" action:@selector(openTestGraph:) keyEquivalent:@""];
	[currentItem setTarget:self];
    [listOfCalendars addItem:currentItem];	
    
    return listOfCalendars;
}

- (NSManagedObjectContext *)managedObjectContext
{
	if (managedObjectContext == nil)
    {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        managedObjectContext =  [[NSApp delegate] managedObjectContext];
    }
    return managedObjectContext;
}


//destructor
- (void)dealloc {
    // Clean-up code here.
    
    [super dealloc];
}

@end
