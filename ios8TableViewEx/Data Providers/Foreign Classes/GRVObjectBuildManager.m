//
//  GRVObjectBuildManager.m
//  GroupChat
//
//  Created by kanybek on 10/2/15.
//  Copyright (c) 2015 Grouvi. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import <libextobjc/EXTScope.h>
#import "MTLJSONAdapter.h"
#import "GRVObjectBuildManager.h"
#import "AppDelegate.h"

@implementation GRVObjectBuildManager

- (MTLModel *)translateModelFromJSON:(NSDictionary *)JSON
                       withclassName:(Class)modelClass
{
    NSError *error = nil;
    id model = [MTLJSONAdapter modelOfClass:modelClass
                         fromJSONDictionary:JSON
                                      error:&error];
    if (!error) {
        return model;
    } else {
        DLog(@"translateModelFromJSON ERROR = %@",error);
        return nil;
    }
}

- (NSArray *)translateCollectionFromJSON:(NSArray *)JSON
                           withClassName:(Class)modelClass {
    if ([JSON isKindOfClass:[NSArray class]]) {
        NSValueTransformer *valueTransformer = [MTLJSONAdapter arrayTransformerWithModelClass:modelClass];
        NSArray *collection = [valueTransformer transformedValue:JSON];
        return collection;
    }
    return nil;
}


@end
