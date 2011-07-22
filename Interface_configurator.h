//
//  Interface_configurator.h
//  data_m
//
//  Created by Mike Fluff on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "configBuilder.h"


@interface Interface_configurator : configBuilder {
    
@private
    
}

+(NSString *)configureInterfaces:(NSInteger)links pairs:(NSInteger)pairs side:(NSString *)side oktet:(NSInteger)okt type:(NSString *)type;
+(NSString *)configureRoutes:(NSInteger)pairs to:(NSInteger)to via:(NSInteger)via side:(NSString *)side;

@end
