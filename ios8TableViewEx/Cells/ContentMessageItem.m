//
// Created by Maxim Nizhurin on 12/8/15.
// Copyright (c) 2015 test. All rights reserved.
//

#import "ContentMessageItem.h"
#import "ContentMessageCell.h"
#import "SPLMMessage.h"


@implementation ContentMessageItem

- (NSString *)reuseIdentifier {
    return [NSString stringWithFormat:@"cell%u", self.imagesCount];
}

- (ContentMessageCell *)createCellWithContainerWidth:(CGFloat)containerWidth {
    return [[ContentMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.reuseIdentifier containerWidth:containerWidth imagesCount:(NSUInteger) self.imagesCount];
}

@end