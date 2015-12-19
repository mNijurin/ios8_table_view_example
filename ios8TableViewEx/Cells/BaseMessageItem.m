//
// Created by Maxim Nizhurin on 12/19/15.
// Copyright (c) 2015 test. All rights reserved.
//

#import "BaseMessageItem.h"
#import "SPLMMessage.h"
#import "BaseMessageCell.h"


@implementation BaseMessageItem

- (NSString *)reuseIdentifier {
    @throw @"reuseIdentifier must be overridden";
}

- (BaseMessageCell *)createCellWithContainerWidth:(CGFloat)containerWidth {
    @throw @"createCellWithContainerWidth must be overridden";
}

@end