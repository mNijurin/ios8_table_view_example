//
// Created by Maxim Nizhurin on 12/14/15.
// Copyright (c) 2015 test. All rights reserved.
//

#import <libextobjc/EXTScope.h>
#import <Masonry/View+MASAdditions.h>
#import "BaseMessageCell.h"


@implementation BaseMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containerWidth:(CGFloat)containerWidth {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.containerWidth = containerWidth;
    }
    return self;
}

- (void)cellDidLoad {
    [self addSubviews];
    [self setupConstraints];
}

- (void)addSubviews {
    [self.contentView addSubview:self.customContentView];
    [self.customContentView addSubview:self.bubbleBackgroundImageView];
}

- (void)setupConstraints {
    @weakify(self);
    [self.bubbleBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.customContentView);
    }];
}

- (CGFloat)heightForWidth:(CGFloat)width {
    @throw @"must be overriden";
}

#pragma mark - getters

- (UIView *)customContentView {
    if (!_customContentView) {
        _customContentView = [UIView new];
        _customContentView.backgroundColor = [UIColor clearColor];
    }
    return _customContentView;
}

- (UIImageView *)bubbleBackgroundImageView {
    if (!_bubbleBackgroundImageView) {
        _bubbleBackgroundImageView = [UIImageView new];
        UIImage *image = [UIImage imageNamed:@"bubble_hooked_incomming.png"];
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(8.0, 15.0, 15.0, 8.0);
        _bubbleBackgroundImageView.image = [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
    }
    return _bubbleBackgroundImageView;
}

@end