//
// Created by Maxim Nizhurin on 12/8/15.
// Copyright (c) 2015 test. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MegaCell;


@interface MegaItem : NSObject

@property (nonatomic, strong) NSString *reuseIdentifier;

@property (nonatomic, assign) NSInteger imagesCount;
@property (nonatomic, strong) NSAttributedString *attributedText;
@property (nonatomic, strong) NSArray *urls;

+ (instancetype)itemWithImagesCount:(int)imagesCount index:(NSInteger)index;

- (MegaCell *)createCell;

@end