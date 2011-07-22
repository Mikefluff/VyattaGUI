//
//  ResultWindowData.h
//  data_m
//
//  Created by Mike Fluff on 05.04.11.
//  Copyright 2011 Altell ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleNodeData.h"
#import "ImageAndTextCell.h"
#import "NSOutlineView_Extensions.h"
#import "Tests.h"
#import "Reports.h"
#import "Pairs.h"
#import "Yuba/YBGraphs_fabric.h"
#import "Yuba/graphDataSource.h"

#define SIMPLE_BPOARD_TYPE           @"MyCustomOutlineViewPboardType"
#define COLUMNID_IS_EXPANDABLE       @"IsExpandableColumn"
#define COLUMNID_NAME                @"NameColumn"
#define COLUMNID_NODE_KIND           @"NodeKindColumn"
#define COLUMID_IS_SELECTABLE        @"IsSelectableColumn"

#define NAME_KEY                     @"Name"
#define CHILDREN_KEY                 @"Children"


@interface ResultWindowData : NSObject <GraphsDataSource> {
@private
    NSTreeNode *rootTreeNode;
    NSArray *draggedNodes;
    NSMutableArray *iconImages;
    
    IBOutlet NSOutlineView *outlineView;
    IBOutlet NSButton *allowOnDropOnContainerCheck;
    IBOutlet NSButton *allowOnDropOnLeafCheck;
    IBOutlet NSButton *allowBetweenDropCheck;
    IBOutlet NSButton *allowButtonCellsToChangeSelection;
    IBOutlet NSButton *onlyAcceptDropOnRoot;
    IBOutlet NSButton *useGroupRowLook;
    IBOutlet NSFormCell *selectionOutput;
    // Contextual menus (aka: right click menus) for the NSOutlineView
    IBOutlet NSMenu *outlineViewContextMenu;
    IBOutlet NSMenu *expandableColumnMenu; 
    
    IBOutlet NSArrayController *pairs;
    
    IBOutlet NSTableView *pairsTable;
    
    NSArray *pairsArray;
    
    NSManagedObjectContext *managedObjectContext, *_docMoc;
    
 //   Reports *currentReport;
    
    YBGraphs_fabric *graphs_fabric;
    NSMutableDictionary *graphData;
    
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (IBAction)openTestGraph:(id)sender;


//GraphsDataSource Protocol Implementation

-(NSArray *)getDataForGraph:(NSInteger)graph;

@end
