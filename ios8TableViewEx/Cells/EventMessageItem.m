//
// Created by Maxim Nizhurin on 12/19/15.
// Copyright (c) 2015 test. All rights reserved.
//

#import "EventMessageItem.h"
#import "EventMessageCell.h"


@implementation EventMessageItem

- (NSString *)reuseIdentifier {
    return @"event_cell";
}

- (BaseMessageCell *)createCellWithContainerWidth:(CGFloat)containerWidth {
    return [[EventMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.reuseIdentifier containerWidth:containerWidth];
}


@end