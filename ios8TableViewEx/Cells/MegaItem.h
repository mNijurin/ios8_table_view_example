//
// Created by Maxim Nizhurin on 12/8/15.
// Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MegaCell;


@interface MegaItem : NSObject

@property (nonatomic, strong) NSString *reuseIdentifier;

@property (nonatomic, assign) NSInteger imagesCount;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSArray *urls;

+ (instancetype)itemWithImagesCount:(int)imagesCount index:(NSInteger)index;

- (MegaCell *)createCellWithContainerWidth:(CGFloat)containerWidth;

@end