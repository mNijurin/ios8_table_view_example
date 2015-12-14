//
// Created by Maxim Nizhurin on 12/8/15.
// Copyright (c) 2015 test. All rights reserved.
//

#import "MegaItem.h"
#import "MegaCell.h"


@implementation MegaItem

+ (instancetype)itemWithImagesCount:(int)imagesCount index:(NSInteger)index {
    MegaItem *item = [MegaItem new];

    NSMutableArray *mutableUrls = [NSMutableArray new];
    NSString *url = @"https://placeimg.com/480/320/people/";
    for (int i = 0; i < imagesCount; i++) {
        [mutableUrls addObject:[NSString stringWithFormat:@"%@%@", url, @(index * 10 + i)]];
    }
    item.urls = mutableUrls;

    item.imagesCount = imagesCount;
    if (imagesCount == 0) {
        item.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
    } else if (imagesCount == 1) {
        item.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";
    } else if (imagesCount == 2) {
        item.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco";
    } else if (imagesCount == 3) {
        item.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad";
    } else if (imagesCount == 4) {
        item.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi";
    }
    return item;
}

- (NSString *)reuseIdentifier {
    return [NSString stringWithFormat:@"cell%u", self.imagesCount];
}

- (MegaCell *)createCell {
    return [MegaCell cellWithImagesCount:(NSUInteger) self.imagesCount];
}

@end