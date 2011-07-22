//
//  testBuilder.h
//  data_m
//
//  Created by Mike Fluff on 5/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface testBuilder : NSObject {
        NSManagedObjectContext *context;
        NSMutableString *config;
        NSInteger tabsNum;
        NSMutableDictionary *dic;
@private
    
}
-(void)runTest;

@property (nonatomic, retain) NSManagedObjectContext *context;
@end
