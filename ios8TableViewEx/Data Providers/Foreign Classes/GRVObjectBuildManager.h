//
//  GRVObjectBuildManager.h
//  GroupChat
//
//  Created by kanybek on 10/2/15.
//  Copyright (c) 2015 Grouvi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MTLModel;

@interface GRVObjectBuildManager : NSObject

- (MTLModel *)translateModelFromJSON:(NSDictionary *)JSON
                       withclassName:(Class)modelClass;
- (NSArray *)translateCollectionFromJSON:(NSArray *)JSON
                           withClassName:(Class)modelClass;

@end
