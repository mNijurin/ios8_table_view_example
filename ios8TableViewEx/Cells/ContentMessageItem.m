//
// Created by Maxim Nizhurin on 12/8/15.
// Copyright (c) 2015 test. All rights reserved.
//

#import "ContentMessageItem.h"
#import "ContentMessageCell.h"

@implementation ContentMessageItem

//possible values: cell0, cell1, cell2, cell3, cell4
- (NSString *)reuseIdentifier {
    return [NSString stringWithFormat:@"cell%u", self.imagesCount];
}

- (ContentMessageCell *)createCellWithContainerWidth:(CGFloat)containerWidth {
    return [[ContentMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.reuseIdentifier containerWidth:containerWidth imagesCount:(NSUInteger) self.imagesCount];
}

@end