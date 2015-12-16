//
//  MegaCell.m
//  test
//
//  Created by Maxim Nizhurin on 11/28/15.
//  Copyright © 2015 test. All rights reserved.
//

#import "MegaCell.h"
#import "EXTScope.h"
#import "View+MASAdditions.h"
#import "MegaItem.h"
#import "UIImageView+WebCache.h"

@interface MegaCell ()

@property (nonatomic, assign) NSUInteger imagesCount;
@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong) UIImageView *firstImageView;
@property (nonatomic, strong) UIImageView *secondImageView;
@property (nonatomic, strong) UIImageView *thirdImageView;
@property (nonatomic, strong) UIImageView *fourthImageView;

@property (nonatomic, strong) UILabel *megaTextLabel;

@end

@implementation MegaCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containerWidth:(CGFloat)containerWidth imagesCount:(NSUInteger)imagesCount {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier containerWidth:containerWidth];
    if (self) {
        self.imageViews = [NSMutableArray new];
        self.imagesCount = imagesCount;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark  - ui

- (void)addSubviews {
    [super addSubviews];
    if (self.imagesCount > 0) {
        [self.customContentView addSubview:self.firstImageView];
        [self.imageViews addObject:self.firstImageView];
    }
    if (self.imagesCount > 1) {
        [self.customContentView addSubview:self.secondImageView];
        [self.imageViews addObject:self.secondImageView];
    }
    if (self.imagesCount > 2) {
        [self.customContentView addSubview:self.thirdImageView];
        [self.imageViews addObject:self.thirdImageView];
    }
    if (self.imagesCount > 3) {
        [self.customContentView addSubview:self.fourthImageView];
        [self.imageViews addObject:self.fourthImageView];
    }
    [self.customContentView addSubview:self.megaTextLabel];
}

- (void)setupConstraints {
    [super setupConstraints];
    @weakify(self);
    [self.megaTextLabel setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
    [self.megaTextLabel setContentHuggingPriority:10 forAxis:UILayoutConstraintAxisHorizontal];
    if (self.imagesCount == 0) {
        [self.customContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(5);
            make.bottom.equalTo(self.contentView).offset(-5);
            make.width.lessThanOrEqualTo(self.contentView).multipliedBy(percentTakenByContent);
        }];
        [self.megaTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.customContentView).offset(14);
            make.top.equalTo(self.customContentView).offset(8);
            make.trailing.bottom.equalTo(self.customContentView).offset(-8);
        }];
    }
    if (self.imagesCount > 0) {
        [self.customContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(5);
            make.bottom.equalTo(self.contentView).offset(-5);
            make.width.mas_equalTo(self.containerWidth * percentTakenByContent);
        }];
        [self.megaTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.customContentView).offset(14);
            make.trailing.bottom.equalTo(self.customContentView).offset(-8);
        }];
    }
    if (self.imagesCount == 1) {
        [self.firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.customContentView).offset(14);
            make.top.equalTo(self.customContentView).offset(8);
            make.trailing.equalTo(self.customContentView).offset(-8);
            make.bottom.equalTo(self.megaTextLabel.mas_top).offset(-8);
            make.height.equalTo(self.firstImageView.mas_width).dividedBy(squareImageWHRatio);
        }];
    }
    if (self.imagesCount == 2) {
        [self.firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.customContentView).offset(14);
            make.top.equalTo(self.customContentView).offset(8);
            make.trailing.equalTo(self.secondImageView.mas_leading).offset(-8);
            make.bottom.equalTo(self.megaTextLabel.mas_top).offset(-8);
            make.height.equalTo(self.firstImageView.mas_width).dividedBy(squareImageWHRatio);
            make.width.equalTo(self.secondImageView);
        }];
        [self.secondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.customContentView).offset(8);
            make.trailing.equalTo(self.customContentView).offset(-8);
            make.bottom.equalTo(self.megaTextLabel.mas_top).offset(-8);
            make.height.equalTo(self.secondImageView.mas_width).dividedBy(squareImageWHRatio);
        }];
    }
    if (self.imagesCount == 3) {
        [self.firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.customContentView).offset(14);
            make.top.equalTo(self.customContentView).offset(8);
            make.trailing.equalTo(self.secondImageView.mas_leading).offset(-8);
            make.height.equalTo(self.firstImageView.mas_width).dividedBy(squareImageWHRatio);
            make.width.equalTo(self.secondImageView);
        }];
        [self.secondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.customContentView).offset(8);
            make.trailing.equalTo(self.customContentView).offset(-8);
            make.height.equalTo(self.secondImageView.mas_width).dividedBy(squareImageWHRatio);
        }];
        [self.thirdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.customContentView).offset(14);
            make.top.equalTo(self.firstImageView.mas_bottom).offset(8);
            make.trailing.equalTo(self.customContentView).offset(-8);
            make.bottom.equalTo(self.megaTextLabel.mas_top).offset(-8);
            make.height.equalTo(self.thirdImageView.mas_width).dividedBy(rectangleImageWHRatio);
        }];
    }
    if (self.imagesCount == 4) {
        [self.firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.customContentView).offset(14);
            make.top.equalTo(self.customContentView).offset(8);
            make.trailing.equalTo(self.secondImageView.mas_leading).offset(-8);
            make.height.equalTo(self.firstImageView.mas_width).dividedBy(squareImageWHRatio);
            make.width.equalTo(self.secondImageView);
        }];
        [self.secondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.customContentView).offset(8);
            make.trailing.equalTo(self.customContentView).offset(-8);
            make.height.equalTo(self.secondImageView.mas_width).dividedBy(squareImageWHRatio);
        }];
        [self.thirdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.firstImageView.mas_bottom).offset(8);
            make.leading.trailing.equalTo(self.firstImageView);
            make.height.equalTo(self.firstImageView);
            make.bottom.equalTo(self.megaTextLabel.mas_top).offset(-8);
        }];
        [self.fourthImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.secondImageView.mas_bottom).offset(8);
            make.leading.trailing.equalTo(self.secondImageView);
            make.height.equalTo(self.secondImageView);
            make.bottom.equalTo(self.megaTextLabel.mas_top).offset(-8);
        }];
    }
}

#pragma mark - life cycle

- (void)fillWithItem:(MegaItem *)item {
    for (int i = 0; i < self.imageViews.count; i++) {
        UIImageView *imageView = self.imageViews[(NSUInteger) i];
        [imageView sd_setImageWithURL:item.urls[(NSUInteger) i]];
    }
    self.megaTextLabel.text = item.text;

    if (self.megaTextLabel.text.length == 0) {
        [self.megaTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(0);
        }];
    } else {
        [self.megaTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(-8);
        }];
    }
}

- (CGFloat)heightForWidth:(CGFloat)width {
    if (self.imagesCount == 0) {
        self.megaTextLabel.preferredMaxLayoutWidth = width * percentTakenByContent - 14 - 8;
    } else if (self.imagesCount > 0) {
        self.megaTextLabel.preferredMaxLayoutWidth = self.containerWidth * percentTakenByContent - 14 - 8;
    }
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

#pragma mark - getters

- (UIImageView *)firstImageView {
    if (!_firstImageView) {
        _firstImageView = [UIImageView new];
        _firstImageView.contentMode = UIViewContentModeScaleAspectFill;
        _firstImageView.clipsToBounds = YES;
        _firstImageView.layer.cornerRadius = 3;
    }
    return _firstImageView;
}

- (UIImageView *)secondImageView {
    if (!_secondImageView) {
        _secondImageView = [UIImageView new];
        _secondImageView.contentMode = UIViewContentModeScaleAspectFill;
        _secondImageView.clipsToBounds = YES;
        _secondImageView.layer.cornerRadius = 3;
    }
    return _secondImageView;
}

- (UIImageView *)thirdImageView {
    if (!_thirdImageView) {
        _thirdImageView = [UIImageView new];
        _thirdImageView.contentMode = UIViewContentModeScaleAspectFill;
        _thirdImageView.clipsToBounds = YES;
        _thirdImageView.layer.cornerRadius = 3;
    }
    return _thirdImageView;
}

- (UIImageView *)fourthImageView {
    if (!_fourthImageView) {
        _fourthImageView = [UIImageView new];
        _fourthImageView.contentMode = UIViewContentModeScaleAspectFill;
        _fourthImageView.clipsToBounds = YES;
        _fourthImageView.layer.cornerRadius = 3;
    }
    return _fourthImageView;
}

- (UILabel *)megaTextLabel {
    if (!_megaTextLabel) {
        _megaTextLabel = [UILabel new];
        _megaTextLabel.numberOfLines = 0;
    }
    return _megaTextLabel;
}

@end
