//
// Created by Maxim Nizhurin on 12/14/15.
// Copyright (c) 2015 test. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "BaseMessageCell.h"
#import "BaseMessageItem.h"


@implementation BaseMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containerWidth:(CGFloat)containerWidth {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];

        self.containerMinWidth = containerWidth;
    }
    return self;
}

- (void)cellDidLoad {
    [self addSubviews];
    [self setupConstraints];
}

- (void)addSubviews {
    [self.contentView addSubview:self.customContentView];
}

- (void)setupConstraints {
}

- (void)fillWithItem:(BaseMessageItem *)item {
    @throw @"fillWithItem must be overridden";
}


- (CGFloat)heightForWidth:(CGFloat)width {
    @throw @"heightForWidth must be overridden";
}

#pragma mark - getters

- (UIView *)customContentView {
    if (!_customContentView) {
        _customContentView = [UIView new];
        _customContentView.clipsToBounds = YES;
        _customContentView.backgroundColor = [UIColor clearColor];
    }
    return _customContentView;
}

@end