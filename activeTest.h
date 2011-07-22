//
//  activeTest.h
//  data_m
//
//  Created by Mike Fluff on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface activeTest : NSObject {
    NSString *tests;
    NSString *status;
@private
    
}

@property(nonatomic,retain) NSString *tests;
@property(nonatomic,retain) NSString *status;

@end
