//
//  Firewall_controller.h
//  data_m
//
//  Created by Mike Fluff on 6/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Firewall_controller : NSObject <NSTableViewDelegate, NSTableViewDataSource> {
    IBOutlet NSTableView *fw_table;
@private
    
}

@end
