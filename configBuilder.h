//
//  configBuilder.h
//  data_m
//
//  Created by Mike Fluff on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface configBuilder : NSObject {
    NSDictionary *config;
    
@private
    
}

@property (nonatomic,retain) NSDictionary *config;

+ (NSArray *) ipList:(NSInteger)number side:(NSString *)side oktet:(NSInteger)okt;
+ (NSString *)buildStrWithFormat:(NSString *)format fromArray:(NSArray *)array;


@end
