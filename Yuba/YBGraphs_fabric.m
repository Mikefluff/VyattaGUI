//
//  YBGraphs_fabric.m
//  data_m
//
//  Created by Mike Fluff on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YBGraphs_fabric.h"
#import "FakeModel.h"

@implementation YBGraphs_fabric
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
         
       
    }
    
    return self;
}

- (void)awakeFromNib
{
	
    
    // hook up add tab button
    [[tabBar addTabButton] setTarget:self];
    [[tabBar addTabButton] setAction:@selector(addNewTab:)];
    
    // remove any tabs present in the nib
    NSArray *existingItems = [tabView tabViewItems];
    NSEnumerator *e = [existingItems objectEnumerator];
    NSTabViewItem *item;
    while (item = [e nextObject]) {
        [tabView removeTabViewItem:item];
    }
	
//	[self performSelector:@selector(configureTabBarInitially)
//			   withObject:nil
//			   afterDelay:0];
	
    graphArray = [[NSMutableArray alloc] init];
    // open drawer
    //[drawer toggle:self];
}



-(void)reloadGraphs
{
    for(YBGraphView *graphview in graphArray)
    {
        [graphview draw];
    }
}

-(void)openGraphs:(NSIndexSet *)numbers
{
        
        int count = [[tabView tabViewItems] count];
        [self addNewTab:[numbers count]];
        NSRect tabViewBounds = [[[tabView tabViewItemAtIndex:count] view] bounds];
        
        YBGraphView *graphview = [[YBGraphView alloc] initWithFrame:tabViewBounds];
        
        graphDataSource *grDS = [[graphDataSource alloc] init];
        [grDS initWithId:numbers];
        [grDS setDataSource:delegate];
    
        [graphview setDelegate:self];
        [graphview setDataSource:grDS];
        
        [[tabView tabViewItemAtIndex:count] setView:graphview];
        [graphArray addObject:graphview];
        
    
    
    
	
	
	
 /*   NSRect frame = NSMakeRect(300, 400, 400, 200);
    NSWindow* window  = [[NSWindow alloc] initWithContentRect:frame
                                                    styleMask:NSTitledWindowMask |NSClosableWindowMask
                                                      backing:NSBackingStoreBuffered
                                                        defer:NO];
    [window makeKeyAndOrderFront:NSApp];
    NSView *view = [[NSView alloc] init];
    
    YBGraphView *graphview = [[YBGraphView alloc] init];
    [view addSubview:graphview];
    [graphview setDelegate:dataSource];
    [graphview setDataSource:dataSource];
    
    //   [view addSubview:graphview];
    [graphview draw];
    [window setContentView:view];*/
    
}
- (void)addNewTab:(id)number
{
    FakeModel *newModel = [[FakeModel alloc] init];
    NSTabViewItem *newItem = [[[NSTabViewItem alloc] initWithIdentifier:newModel] autorelease];
    [newItem setLabel:[NSString stringWithFormat:@"Graph for %d pairs",number]];
    [tabView addTabViewItem:newItem];
    [tabView selectTabViewItem:newItem]; // this is optional, but expected behavior
    [newModel release];
}





- (void)dealloc
{
    [super dealloc];
}

@end
