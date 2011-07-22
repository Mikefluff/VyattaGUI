//
//  Test_Activity_Controller.h
//  data_m
//
//  Created by Mike Fluff on 3/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//configuration builder specific
#import "TestConfigurator.h"
#import "DeviceConfigurator.h"



//Core Data management specific
#import "Tests.h"
#import "Device.h"
#import "Reports.h"
#import "Results.h"
#import "Pairs.h"

//Interface specific
#import "Yuba/YBGraphs_fabric.h"

//Controller specific
#import "SSHCore.h"

#import "activeTest.h"

#import "Yuba/graphDataSource.h"

#import "ProgressCell.h"

#import "VariableCellColumn.h"

@interface Test_Activity_Controller : NSObject <EndpointProtocol, GraphsDataSource> {
    
    id delegate;
    
  //  BOOL isConfigured;
    Tests *testToConf;
     
    NSArray *iperfClients;
    IBOutlet NSButton *openTestGraph;
    IBOutlet NSArrayController *testsArrayController;
    
    IBOutlet NSMutableArray *testsArray;
    YBGraphs_fabric *graphs_fabric;
    
    NSMutableDictionary *graphData;
    BOOL isOPEN;
    NSInteger pairs;
    NSMutableArray *testThreads;
//    ProgressCell *progCell;
    BOOL isStarted;
    NSProgressIndicator *progress;
        
    int pairsfinished;
    
    NSManagedObjectContext *managedObjectContext, *_docMoc;
    
    NSNumber *TestIndex;
    
    int reportNum;
    BOOL testRun;
  //  Reports *report;
    
@private

}

@property (nonatomic,retain) NSThread *testThread;
@property (nonatomic,retain) NSProgressIndicator *progress;
@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) NSNumber *TestIndex;
@property (readwrite, assign) BOOL isConfigured;

-(IBAction)openTestGraph:(id)sender;



-(void)startTests;
-(void)stopTests;
-(id)initWithTest:(id)test;
-(void)prepareContent:(id)test;
-(BOOL)configureDevicesForTest;

- (NSMenu*)tableView:(NSTableView*)aTableView menuForRows:(NSIndexSet*)rows;


//GraphsDataSource Protocol Implementation

-(NSArray *)getDataForGraph:(NSInteger)graph;




//EndpointProtocol Implementation

- (void)processActiveResult:(NSArray *)result;
- (void)processFinished;

@end
