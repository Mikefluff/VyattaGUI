//
//  YBGraphs_fabric.h
//  data_m
//
//  Created by Mike Fluff on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBGraphView.h"
#import "graphDataSource.h"
#import "PSMTabStyle.h"
#import "PSMTabBarControl.h"




@class PSMTabBarControl;
@interface YBGraphs_fabric : NSWindowController {
    IBOutlet id delegate;
    
    
    IBOutlet    NSTabView           *tabView;
    IBOutlet    NSTextField         *tabField;
    IBOutlet    NSDrawer            *drawer;
    
    IBOutlet    PSMTabBarControl    *tabBar;
    
    IBOutlet    NSButton            *isProcessingButton;
    IBOutlet    NSButton            *isEditedButton;
    IBOutlet    NSTextField         *objectCounterField;
    IBOutlet    NSPopUpButton       *iconButton;
	
	IBOutlet	NSPopUpButton		*popUp_style;
	IBOutlet	NSPopUpButton		*popUp_orientation;
	IBOutlet	NSPopUpButton		*popUp_tearOff;
	IBOutlet	NSButton			*button_canCloseOnlyTab;
	IBOutlet	NSButton			*button_disableTabClosing;
	IBOutlet	NSButton			*button_hideForSingleTab;
	IBOutlet	NSButton			*button_showAddTab;
	IBOutlet	NSButton			*button_useOverflow;
	IBOutlet	NSButton			*button_automaticallyAnimate;
	IBOutlet	NSButton			*button_allowScrubbing;
	IBOutlet	NSButton			*button_sizeToFit;
	IBOutlet	NSTextField			*textField_minWidth;
	IBOutlet	NSTextField			*textField_maxWidth;
	IBOutlet	NSTextField			*textField_optimumWidth;
    
    NSMutableArray *graphArray;
    
    
@private
    
}

@property (nonatomic, retain) id delegate;



-(void)openGraphs:(NSIndexSet *)numbers;
-(void)reloadGraphs;





@end
