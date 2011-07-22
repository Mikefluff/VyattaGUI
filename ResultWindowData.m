//
//  ResultWindowData.m
//  data_m
//
//  Created by Mike Fluff on 05.04.11.
//  Copyright 2011 Altell ltd. All rights reserved.
//

#import "ResultWindowData.h"

@interface ResultWindowData(Private)

- (void)addNewDataToSelection:(SimpleNodeData *)newChildData;
- (NSImage *)randomIconImage;
- (NSTreeNode *)treeNodeFromDictionary:(NSDictionary *)dictionary;

@end

@implementation ResultWindowData

@synthesize managedObjectContext;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        pairsArray = [[NSArray alloc] init];
        
        graphs_fabric = [[YBGraphs_fabric alloc] initWithWindowNibName:@"GraphicsWindow"];
        
        [graphs_fabric setDelegate:self];
        // graphs_fabric = [[YBGraphs_fabric alloc] init];
       
        graphData = [[NSMutableDictionary alloc] init];
        
      //  NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"InitInfo" ofType: @"dict"]];
        rootTreeNode = [[self treeNodeFromDictionary:nil] retain];
    }
    
    return self;
}

- (void)awakeFromNib {
    // Register to get our custom type, strings, and filenames. Try dragging each into the view!
    [outlineView registerForDraggedTypes:[NSArray arrayWithObjects:SIMPLE_BPOARD_TYPE, NSStringPboardType, NSFilenamesPboardType, nil]];
    [outlineView setDraggingSourceOperationMask:NSDragOperationEvery forLocal:YES];
    [outlineView setDraggingSourceOperationMask:NSDragOperationEvery forLocal:NO];
    [outlineView setAutoresizesOutlineColumn:NO];
}

- (NSArray *)draggedNodes { 
    return draggedNodes; 
}

- (NSArray *)selectedNodes { 
    return [outlineView selectedItems]; 
}

- (BOOL)allowOnDropOnContainer {   
    return (BOOL)[allowOnDropOnContainerCheck state]; 
}

- (BOOL)allowOnDropOnLeaf { 
    return (BOOL)[allowOnDropOnLeafCheck state]; 
}

- (BOOL)allowBetweenDrop { 
    return (BOOL)[allowBetweenDropCheck state]; 
}

- (BOOL)onlyAcceptDropOnRoot { 
    return (BOOL)[onlyAcceptDropOnRoot state]; 
}


// ================================================================
//  NSOutlineView data source methods. (The required ones)
// ================================================================

// The NSOutlineView uses 'nil' to indicate the root item. We return our root tree node for that case.

/*-(void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    id selectedItem = [outlineView itemAtRow:[outlineView selectedRow]];
}*/


- (NSArray *)childrenForItem:(id)item {
    if (item == nil) {
        return [rootTreeNode childNodes];
    } else {
        return [item childNodes];
    }
}

// Required methods. 
- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    // 'item' may potentially be nil for the root item.
    NSArray *children = [self childrenForItem:item];
    // This will return an NSTreeNode with our model object as the representedObject
    return [children objectAtIndex:index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    // 'item' will always be non-nil. It is an NSTreeNode, since those are always the objects we give NSOutlineView. We access our model object from it.
    id nodeData = [item representedObject];
    // We can expand items if the model tells us it is a container
    if ([nodeData isKindOfClass:[Tests class]])
        return YES;
    else return NO;
  //  return nodeData.container;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    // 'item' may potentially be nil for the root item.
    NSArray *children = [self childrenForItem:item];
    return [children count];
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    id objectValue = nil;
    id nodeData = [item representedObject];
    
    // The return value from this method is used to configure the state of the items cell via setObjectValue:
    if ((tableColumn == nil) || [[tableColumn identifier] isEqualToString:COLUMNID_NAME]) {
        {
        if([nodeData isKindOfClass:[Tests class]])
        objectValue = [NSString stringWithFormat:@"%@ %@",[nodeData valueForKey:@"id"],[nodeData valueForKey:@"type"]];
        if([nodeData isKindOfClass:[Reports class]])
            objectValue = [nodeData valueForKey:@"id"];
        }
    } 
  /*  else if ([[tableColumn identifier] isEqualToString:COLUMNID_IS_EXPANDABLE]) {
        // Here, object value will be used to set the state of a check box.
        BOOL isExpandable = nodeData.container && nodeData.expandable;
        objectValue = [NSNumber numberWithBool:isExpandable];
    } else if ([[tableColumn identifier] isEqualToString:COLUMNID_NODE_KIND]) {
        objectValue = (nodeData.container ? @"Test" : @"Result");
    } else if ([[tableColumn identifier] isEqualToString:COLUMID_IS_SELECTABLE]) {
        // Again -- this object value will set the state of the check box.
        objectValue = [NSNumber numberWithBool:nodeData.selectable];
    }*/
    
    return objectValue;
}

// Optional method: needed to allow editing.
- (void)outlineView:(NSOutlineView *)ov setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item  {
    id nodeData = [item representedObject];
    
    // Here, we manipulate the data stored in the node.
/*    if ((tableColumn == nil) || [[tableColumn identifier] isEqualToString:COLUMNID_NAME]) {
        nodeData.name = object;
    } else if ([[tableColumn identifier] isEqualToString:COLUMNID_IS_EXPANDABLE]) {
        nodeData.expandable = [object boolValue];
        if (!nodeData.expandable && [outlineView isItemExpanded:item]) {
            [outlineView collapseItem:item];            
        }
    } else if ([[tableColumn identifier] isEqualToString:COLUMNID_NODE_KIND]) {
        // We don't allow editing of this column, so we should never actually get here.
    } else if ([[tableColumn identifier] isEqualToString:COLUMID_IS_SELECTABLE]) {
        nodeData.selectable = [object boolValue];
    }*/
}

// We can return a different cell for each row, if we want
/*- (NSCell *)outlineView:(NSOutlineView *)ov dataCellForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    // If we return a cell for the 'nil' tableColumn, it will be used as a "full width" cell and span all the columns
 /*   if ([useGroupRowLook state] && (tableColumn == nil)) {
        SimpleNodeData *nodeData = [item representedObject];
        if (nodeData.container) {
            // We want to use the cell for the name column, but we could construct a new cell if we wanted to, or return a different cell for each row.
            return [[outlineView tableColumnWithIdentifier:COLUMNID_NAME] dataCell];
        }
    }
    return [tableColumn dataCell];
}*/

// To get the "group row" look, we implement this method.
- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item {
    id nodeData = [item representedObject];
    if ([nodeData isKindOfClass:[Tests class]])
        return YES;
    else return NO;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldExpandItem:(id)item {
    // Query our model for the answer to this question
   id nodeData = [item representedObject];
    if ([nodeData isKindOfClass:[Tests class]])
        return YES;
    else return NO;
}

/*- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(NSCell *)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item {    
    SimpleNodeData *nodeData = [item representedObject];
    if ((tableColumn == nil) || [[tableColumn identifier] isEqualToString:COLUMNID_NAME]) {
        // Make sure the image and text cell has an image.  If not, lazily fill in a random image
        if (nodeData.image == nil) {
            nodeData.image = [self randomIconImage];
        }
        // We know that the cell at this column is our image and text cell, so grab it
        ImageAndTextCell *imageAndTextCell = (ImageAndTextCell *)cell;
        // Set the image here since the value returned from outlineView:objectValueForTableColumn:... didn't specify the image part...
        [imageAndTextCell setImage:nodeData.image];
    } else if ([[tableColumn identifier] isEqualToString:COLUMNID_IS_EXPANDABLE]) {
        [cell setEnabled:nodeData.container];
        // On Mac OS 10.5 and later, in willDisplayCell: we can dynamically set the contextual menu (right click menu) for a particular cell. If nothing is set, then the contextual menu for the NSOutlineView itself will be used. We will set a different menu for the "Expandable?" column, and leave the default one for everything else.
        [cell setMenu:expandableColumnMenu];
    }
    // For all the other columns, we don't do anything.
}*/

- (BOOL)outlineView:(NSOutlineView *)ov shouldSelectItem:(id)item {
    // Control selection of a particular item. 
    id nodeData = [item representedObject];
    NSLog(@"%@",[nodeData valueForKey:@"id"]);
    if ([nodeData isKindOfClass:[Tests class]])
    {
        return NO;
    }
    else 
    {

        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperationWithBlock:^{
            [self fillPairs:nodeData];
        }];
        
        return YES;
    }
     
}


//this method fills Pairs Array and prepare Data Store for Pairs Graphs
- (void)fillPairs:(id)nodeData
{
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"id" ascending:YES];
    NSArray* sortDescriptors = [[[NSArray alloc] initWithObjects: sortDescriptor, nil] autorelease];
    pairsArray = [[[nodeData valueForKey:@"Pairs"] allObjects]sortedArrayUsingDescriptors:sortDescriptors];
    [pairs setContent:pairsArray];
    for(int i =0;i<[pairsArray count];i++)
    {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Pair.id = %@",[[pairsArray objectAtIndex:i] valueForKey:@"id"]];
        
        NSArray *resultsArray = [[[NSArray arrayWithArray:[[nodeData valueForKey:@"Results"] allObjects]] filteredArrayUsingPredicate:predicate] sortedArrayUsingDescriptors:sortDescriptors];
        
        
        NSMutableArray *results = [[NSMutableArray alloc] init];
        for(Results *obj in resultsArray)
            [results addObject:[NSString stringWithFormat:@"%d",[[obj valueForKey:@"data"] intValue]]];
        [graphData setValue:results forKey:[NSString stringWithFormat:@"%d",i]];
    }
   
}

- (BOOL)outlineView:(NSOutlineView *)ov shouldTrackCell:(NSCell *)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    // We want to allow tracking for all the button cells, even if we don't allow selecting that particular row. 
    if ([cell isKindOfClass:[NSButtonCell class]]) {
        // We can also take a peek and make sure that the part of the cell clicked is an area that is normally tracked. Otherwise, clicking outside of the checkbox may make it check the checkbox
        NSRect cellFrame = [outlineView frameOfCellAtColumn:[[outlineView tableColumns] indexOfObject:tableColumn] row:[outlineView rowForItem:item]];
        NSUInteger hitTestResult = [cell hitTestForEvent:[NSApp currentEvent] inRect:cellFrame ofView:outlineView];
        if ((hitTestResult & NSCellHitTrackableArea) != 0) {
            return YES;
        } else {
            return NO;
        }
    } else {
        // Only allow tracking on selected rows. This is what NSTableView does by default.
        return [outlineView isRowSelected:[outlineView rowForItem:item]];
    }
}

static NSString *GenerateUniqueFileNameAtPath(NSString *path, NSString *basename, NSString *extension) {
    NSString *filename = [NSString stringWithFormat:@"%@.%@", basename, extension];
    NSString *result = [path stringByAppendingPathComponent:filename];
    NSInteger i = 1;
    while ([[NSFileManager defaultManager] fileExistsAtPath:result]) {
        filename = [NSString stringWithFormat:@"%@ %ld.%@", basename, (long)i, extension];
        result = [path stringByAppendingPathComponent:filename];
        i++;
    }    
    return result;
}

// We promised the files, so now lets make good on that promise!
- (NSArray *)outlineView:(NSOutlineView *)outlineView namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropDestination forDraggedItems:(NSArray *)items {
    NSMutableArray *result = nil;
    
    for (NSInteger i = 0; i < [items count]; i++) {
        NSString *filepath  = GenerateUniqueFileNameAtPath([dropDestination path], @"PromiseTestFile", @"txt");
        // We write out the tree node's description
        NSTreeNode *treeNode = [items objectAtIndex:i];
        NSString *itemString = [treeNode description];
        NSError *error = nil;
        if (![itemString writeToURL:[NSURL fileURLWithPath:filepath] atomically:NO encoding:NSUTF8StringEncoding error:&error]) {
            [NSApp presentError:error];
            
        }
    }
    return result;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView writeItems:(NSArray *)items toPasteboard:(NSPasteboard *)pboard {
    draggedNodes = items; // Don't retain since this is just holding temporaral drag information, and it is only used during a drag!  We could put this in the pboard actually.
    
    // Provide data for our custom type, and simple NSStrings.
    [pboard declareTypes:[NSArray arrayWithObjects:SIMPLE_BPOARD_TYPE, NSStringPboardType, NSFilesPromisePboardType, nil] owner:self];
    
    // the actual data doesn't matter since SIMPLE_BPOARD_TYPE drags aren't recognized by anyone but us!.
    [pboard setData:[NSData data] forType:SIMPLE_BPOARD_TYPE]; 
    
    // Put string data on the pboard... notice you can drag into TextEdit!
    [pboard setString:[draggedNodes description] forType:NSStringPboardType];
    
    // Put the promised type we handle on the pasteboard.
    [pboard setPropertyList:[NSArray arrayWithObjects:@"txt", nil] forType:NSFilesPromisePboardType];
    
    return YES;
}

- (BOOL)treeNode:(NSTreeNode *)treeNode isDescendantOfNode:(NSTreeNode *)parentNode {
    while (treeNode != nil) {
        if (treeNode == parentNode) {
            return YES;
        }
        treeNode = [treeNode parentNode];
    }
    return NO;
}

- (NSDragOperation)outlineView:(NSOutlineView *)ov validateDrop:(id <NSDraggingInfo>)info proposedItem:(id)item proposedChildIndex:(NSInteger)childIndex {
    // To make it easier to see exactly what is called, uncomment the following line:
    //    NSLog(@"outlineView:validateDrop:proposedItem:%@ proposedChildIndex:%ld", item, (long)childIndex);
    
    // This method validates whether or not the proposal is a valid one.
    // We start out by assuming that we will do a "generic" drag operation, which means we are accepting the drop. If we return NSDragOperationNone, then we are not accepting the drop.
    NSDragOperation result = NSDragOperationGeneric;
    
    if ([self onlyAcceptDropOnRoot]) {
        // We are going to accept the drop, but we want to retarget the drop item to be "on" the entire outlineView
        [outlineView setDropItem:nil dropChildIndex:NSOutlineViewDropOnItemIndex];
    } else {
        // Check to see what we are proposed to be dropping on
        NSTreeNode *targetNode = item;
        // A target of "nil" means we are on the main root tree
        if (targetNode == nil) {
            targetNode = rootTreeNode;
        }
        SimpleNodeData *nodeData = [targetNode representedObject];
        if (nodeData.container) {
            // See if we allow dropping "on" or "between"
            if (childIndex == NSOutlineViewDropOnItemIndex) {
                if (![self allowOnDropOnContainer]) {
                    // Refuse to drop on a container if we are not allowing that
                    result = NSDragOperationNone;
                }
            } else {
                if (![self allowBetweenDrop]) {
                    // Refuse to drop between an item if we are not allowing that
                    result = NSDragOperationNone;
                }
            }
        } else {
            // The target node is not a container, but a leaf. See if we allow dropping on a leaf. If we don't, refuse the drop (we may get called again with a between)
            if (childIndex == NSOutlineViewDropOnItemIndex && ![self allowOnDropOnLeaf]) {
                result = NSDragOperationNone;
            }
        }
        
        // If we are allowing the drop, we see if we are draggng from ourselves and dropping into a descendent, which wouldn't be allowed...
        if (result != NSDragOperationNone) {
            if ([info draggingSource] == outlineView) {
                // Yup, the drag is originating from ourselves. See if the appropriate drag information is available on the pasteboard
                if (targetNode != rootTreeNode && [[info draggingPasteboard] availableTypeFromArray:[NSArray arrayWithObject:SIMPLE_BPOARD_TYPE]] != nil) {
                    for (NSTreeNode *draggedNode in draggedNodes) {
                        if ([self treeNode:targetNode isDescendantOfNode:draggedNode]) {
                            // Yup, it is, refuse it.
                            result = NSDragOperationNone;
                            break;
                        }
                    }
                }
            }
        }
    }
    // To see what we decide to return, uncomment this line
    //    NSLog(result == NSDragOperationNone ? @" - Refusing drop" : @" + Accepting drop");
    
    return result;    
}

- (BOOL)outlineView:(NSOutlineView *)ov acceptDrop:(id <NSDraggingInfo>)info item:(id)item childIndex:(NSInteger)childIndex {
    NSArray *oldSelectedNodes = [self selectedNodes];
    
    NSTreeNode *targetNode = item;
    // A target of "nil" means we are on the main root tree
    if (targetNode == nil) {
        targetNode = rootTreeNode;
    }
    SimpleNodeData *nodeData = [targetNode representedObject];
    
    // Determine the parent to insert into and the child index to insert at.
    if (!nodeData.container) {
        // If our target is a leaf, and we are dropping on it
        if (childIndex == NSOutlineViewDropOnItemIndex) {
            // If we are dropping on a leaf, we will have to turn it into a container node
            nodeData.container = YES;
            nodeData.expandable = YES;
            childIndex = 0;
        } else {
            // We will be dropping on the item's parent at the target index of this child, plus one
            NSTreeNode *oldTargetNode = targetNode;
            targetNode = [targetNode parentNode];
            childIndex = [[targetNode childNodes] indexOfObject:oldTargetNode] + 1;
        }
    } else {            
        if (childIndex == NSOutlineViewDropOnItemIndex) {
            // Insert it at the start, if we were dropping on it
            childIndex = 0;
        }
    }
    
    NSArray *currentDraggedNodes = nil;
    // If the source was ourselves, we use our dragged nodes.
    if ([info draggingSource] == outlineView && [[info draggingPasteboard] availableTypeFromArray:[NSArray arrayWithObject:SIMPLE_BPOARD_TYPE]] != nil) {
        // Yup, the drag is originating from ourselves. See if the appropriate drag information is available on the pasteboard
        currentDraggedNodes = draggedNodes;
    } else {
        // We create a new model item for the dropped data, and wrap it in an NSTreeNode
        NSString *string = [[info draggingPasteboard] stringForType:NSStringPboardType];
        if (string == nil) {
            // Try the filename -- it is an array of filenames, so we just grab one.
            NSString *filename = [[[info draggingPasteboard] propertyListForType:NSFilenamesPboardType] lastObject];
            string = [filename lastPathComponent];
        }
        if (string == nil) {
            string = @"Unknown data dragged";
        }
        SimpleNodeData *newNodeData = [SimpleNodeData nodeDataWithName:string];
        NSTreeNode *treeNode = [NSTreeNode treeNodeWithRepresentedObject:newNodeData];
        newNodeData.container = NO;
        // Finally, add it to the array of dragged items to insert
        currentDraggedNodes = [NSArray arrayWithObject:treeNode];
    }
    
    NSMutableArray *childNodeArray = [targetNode mutableChildNodes];
    // Go ahead and move things. 
    for (NSTreeNode *treeNode in currentDraggedNodes) {
        // Remove the node from its old location
        NSInteger oldIndex = [childNodeArray indexOfObject:treeNode];
        NSInteger newIndex = childIndex;
        if (oldIndex != NSNotFound) {
            [childNodeArray removeObjectAtIndex:oldIndex];
            if (childIndex > oldIndex) {
                newIndex--; // account for the remove
            }
        } else {
            // Remove it from the old parent
            [[[treeNode parentNode] mutableChildNodes] removeObject:treeNode];
        }
        [childNodeArray insertObject:treeNode atIndex:newIndex];
        newIndex++;
    }
    
    [outlineView reloadData];
    // Make sure the target is expanded
    [outlineView expandItem:targetNode];
    // Reselect old items.
    [outlineView setSelectedItems:oldSelectedNodes];
    
    // Return YES to indicate we were successful with the drop. Otherwise, it would slide back the drag image.
    return YES;
}

// On Mac OS 10.5 and above, NSTableView and NSOutlineView have better contextual menu support. We now see a highlighted item for what was clicked on, and can access that item to do particular things (such as dynamically change the menu, as we do here!). Each of the contextual menus in the nib file have the delegate set to be the AppController instance. In menuNeedsUpdate, we dynamically update the menus based on the currently clicked upon row/column pair.
- (void)menuNeedsUpdate:(NSMenu *)menu {
    NSInteger clickedRow = [outlineView clickedRow];
    id item = nil;
    SimpleNodeData *nodeData = nil;
    BOOL clickedOnMultipleItems = NO;
    
    if (clickedRow != -1) {
        // If we clicked on a selected row, then we want to consider all rows in the selection. Otherwise, we only consider the clicked on row.
        item = [outlineView itemAtRow:clickedRow];
        nodeData = [item representedObject];
        clickedOnMultipleItems = [outlineView isRowSelected:clickedRow] && ([outlineView numberOfSelectedRows] > 1);
    }
    
    if (menu == outlineViewContextMenu) {
        NSMenuItem *menuItem = [menu itemAtIndex:0];
        if (nodeData != nil) {
            if (clickedOnMultipleItems) {
                // We could walk through the selection and note what was clicked on at this point
                [menuItem setTitle:[NSString stringWithFormat:@"You clicked on %ld items!", (long)[outlineView numberOfSelectedRows]]];
            } else {
                [menuItem setTitle:[NSString stringWithFormat:@"You clicked on: '%@'", nodeData.name]];
            }
            [menuItem setEnabled:YES];
        } else {
            [menuItem setTitle:@"You didn't click on any rows..."];
            [menuItem setEnabled:NO];
        }
        
    } else if (menu == expandableColumnMenu) {
        NSMenuItem *menuItem = [menu itemAtIndex:0];
        if (!clickedOnMultipleItems && (nodeData != nil)) {
            // The item will be enabled only if it is a group
            [menuItem setEnabled:nodeData.container];
            // Check it if it is expandable
            [menuItem setState:nodeData.expandable ? 1 : 0];
        } else {
            [menuItem setEnabled:NO];
        }
    }
}

- (IBAction)expandableMenuItemAction:(id)sender {
    // The tag of the clicked row contains the item that was clicked on
    NSInteger clickedRow = [outlineView clickedRow];
    NSTreeNode *treeNode = [outlineView itemAtRow:clickedRow];
    SimpleNodeData *nodeData = [treeNode representedObject];
    // Flip the expandable state,
    nodeData.expandable = !nodeData.expandable;
    // Refresh that row (since its state has changed)
    [outlineView setNeedsDisplayInRect:[outlineView rectOfRow:clickedRow]];
    // And collopse it if we can no longer expand it 
    if (!nodeData.expandable && [outlineView isItemExpanded:treeNode]) {
        [outlineView collapseItem:treeNode];
    }
}

- (IBAction)useGroupGrowLook:(id)sender {
    // We simply need to redraw things.
    [outlineView setNeedsDisplay:YES];
}

- (IBAction)openTestGraph:(id)sender {
    id obj = [pairsArray objectAtIndex:[pairsTable selectedRow]];
    
    
    [graphs_fabric showWindow:self];
	[graphs_fabric openGraphs:[pairsTable selectedRowIndexes]];
    [graphs_fabric reloadGraphs];
    
}
@end

@implementation ResultWindowData(Private)

- (void)addNewDataToSelection:(SimpleNodeData *)newChildData {
    NSArray *selectedNodes = [self selectedNodes];
    NSTreeNode *selectedNode;
    // We are inserting as a child of the last selected node. If there are none selected, insert it as a child of the treeData itself
    if ([selectedNodes count] > 0) {
        selectedNode = [selectedNodes lastObject];
    } else {
        selectedNode = rootTreeNode;
    }
    
    // If the selected node is a container, use its parent. We access the underlying model object to find this out.
    // In addition, keep track of where we want the child.
    NSInteger childIndex;
    NSTreeNode *parentNode;
    
    SimpleNodeData *nodeData = [selectedNode representedObject];
    if (nodeData.container) {
        // Since it was already a container, we insert it as the first child
        childIndex = 0;
        parentNode = selectedNode;
    } else {
        // The selected node is not a container, so we use its parent, and insert after the selected node
        parentNode = [selectedNode parentNode]; 
        childIndex = [[parentNode childNodes] indexOfObject:selectedNode ] + 1; // + 1 means to insert after it.
    }
    
    // Now, create a tree node for the data and insert it as a child
    NSTreeNode *childTreeNode = [NSTreeNode treeNodeWithRepresentedObject:newChildData];
    [[parentNode mutableChildNodes] insertObject:childTreeNode atIndex:childIndex];
    // Then, reload things and attempt to select the new child tree node and start editing the text.
    [outlineView reloadData];
    // Make sure it is expanded
    [outlineView expandItem:[childTreeNode parentNode]];
    NSInteger newRow = [outlineView rowForItem:childTreeNode];
    if (newRow >= 0) {
        [outlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:newRow] byExtendingSelection:NO];
        NSInteger column = 0;
        // With "full width" cells, there is no column
        if (newChildData.container && [useGroupRowLook state]) {
            column = -1;
        }
        [outlineView editColumn:column row:newRow withEvent:nil select:YES];
    }
}

- (NSImage *)randomIconImage {
    // The first time through, we create a random array of images to use for the items.
    if (iconImages == nil) {
        iconImages = [[NSMutableArray alloc] init]; // This is properly released in -dealloc
        // There is a set of images with the format "Image<number>.tiff" in the Resources directory. We go through and add them to the array until we are out of images.
        NSInteger i = 1;
        while (1) {
            // The typcast to a long and the use of %ld allows this application to easily be compiled as 32-bit or 64-bit
            NSString *imageName = [NSString stringWithFormat:@"Image%ld.tiff", (long)i];
            NSImage *image = [NSImage imageNamed:imageName];
            if (image != nil) {
                // Add the image to our array and loop to the next one
                [iconImages addObject:image];
                i++;
            } else {
                // If the result is nil, then there are no more images
                break;
            }            
        }
    }
    
    // We systematically iterate through the image array and return a result. Keep track of where we are in the array with a static variable.
    static NSInteger imageNum = 0;
    NSImage *result = [iconImages objectAtIndex:imageNum];
    imageNum++;
    // Once we are at the end of the array, start over
    if (imageNum == [iconImages count]) {
        imageNum = 0;
    }
    return result;
}


- (NSTreeNode *)treeNodeFromDictionary:(NSDictionary *)dictionary {
    // We will use the built-in NSTreeNode with a representedObject that is our model object - the SimpleNodeData object.
    // First, create our model object.
    
    NSTreeNode *result;
    NSString *nodeName = @"reports";
    SimpleNodeData *nodeData = [SimpleNodeData nodeDataWithName:nodeName];
    result = [NSTreeNode treeNodeWithRepresentedObject:nodeData];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tests" inManagedObjectContext:[self managedObjectContext]];
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:entity];
	
	NSError *error = nil;
	
	NSArray *array = [[NSArray alloc] init];
	array = [[self managedObjectContext] executeFetchRequest:request error:&error];
    NSTreeNode *TreeNode;
    for(id obj in array)
    {
    //    NSString *nodeName = [obj valueForKey:@"id"];
   // NSString *nodeName = [dictionary objectForKey:NAME_KEY];
    //    SimpleNodeData *nodeData = [SimpleNodeData nodeDataWithName:nodeName];
    // The image for the nodeData is lazily filled in, for performance.
    
    // Create a NSTreeNode to wrap our model object. It will hold a cache of things such as the children.
       // NSTreeNode *TreeNode;
       
        TreeNode = [NSTreeNode treeNodeWithRepresentedObject:obj];
    
    // Walk the dictionary and create NSTreeNodes for each child.
    NSSet *children = [obj valueForKey:@"children"];
        
        //NSArray *children = [dictionary objectForKey:CHILDREN_KEY];
    
    for (id item in children) {
        // A particular item can be another dictionary (ie: a container for more children), or a simple string
        NSTreeNode *childTreeNode;
        
     //   if ([item isKindOfClass:[NSDictionary class]]) {
            // Recursively create the child tree node and add it as a child of this tree node
       //     childTreeNode = [self treeNodeFromDictionary:item];
     //   } else {
            // It is a regular leaf item with just the name
        //   NSString *nodeName = [item valueForKey:@"id"];
         //   SimpleNodeData *childNodeData = [[SimpleNodeData alloc] initWithName:nodeName];
          //  childNodeData.container = NO;
            childTreeNode = [NSTreeNode treeNodeWithRepresentedObject:item];
//            [childNodeData release];
       // }
        // Now add the child to this parent tree node
        [[TreeNode mutableChildNodes] addObject:childTreeNode];
    }
        [[result mutableChildNodes] addObject:TreeNode];
    }
    return result;
    
}

//graphDataSource protocol method
-(NSArray *)getDataForGraph:(NSInteger)graph
{
    return [graphData objectForKey:[NSString stringWithFormat:@"%d",graph]];
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

- (void)dealloc
{
    [super dealloc];
}

@end
