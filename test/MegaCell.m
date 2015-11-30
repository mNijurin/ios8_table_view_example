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

@interface MegaCell ()
@property (nonatomic, strong) UIView *customContentView;

@property (nonatomic, strong) UIImageView *bubbleBackgroundImageView;

@property (nonatomic, strong) UIImageView *firstImageView;
@property (nonatomic, strong) UIImageView *secondImageView;
@property (nonatomic, strong) UIImageView *thirdImageView;
@property (nonatomic, strong) UIImageView *fourthImageView;

@end

@implementation MegaCell

+ (instancetype)cellWithImagesCount:(NSUInteger)imagesCount {
    MegaCell *cell = [[MegaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"cell%u", imagesCount]];
    [cell addSubviewsWithImagesCount:imagesCount];
    [cell setupConstraintsWithImagesCount:imagesCount];

    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageViews = [NSMutableArray new];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)addSubviewsWithImagesCount:(NSUInteger)imagesCount {
    [self.contentView addSubview:self.customContentView];
    [self.customContentView addSubview:self.bubbleBackgroundImageView];
    if (imagesCount > 0) {
        [self.customContentView addSubview:self.firstImageView];
        [self.imageViews addObject:self.firstImageView];
    }
    if (imagesCount > 1) {
        [self.customContentView addSubview:self.secondImageView];
        [self.imageViews addObject:self.secondImageView];
    }
    if (imagesCount > 2) {
        [self.customContentView addSubview:self.thirdImageView];
        [self.imageViews addObject:self.thirdImageView];
    }
    if (imagesCount > 3) {
        [self.customContentView addSubview:self.fourthImageView];
        [self.imageViews addObject:self.fourthImageView];
    }
    [self.customContentView addSubview:self.megaTextLabel];
}

- (void)setupConstraintsWithImagesCount:(NSUInteger)imagesCount {
    @weakify(self);
    [self.customContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.leading.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(5);
        make.trailing.equalTo(self.contentView).offset(-60);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
    [self.bubbleBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.customContentView);
    }];
    if (imagesCount == 0) {
        [self.megaTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.customContentView).offset(14);
            make.top.equalTo(self.customContentView).offset(8);
            make.trailing.bottom.equalTo(self.customContentView).offset(-8);
        }];
    }
    if (imagesCount == 1) {
        [self.firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.customContentView).offset(14);
            make.top.equalTo(self.customContentView).offset(8);
            make.trailing.equalTo(self.customContentView).offset(-8);
            make.bottom.equalTo(self.megaTextLabel.mas_top).offset(-8);
            make.height.equalTo(self.firstImageView.mas_width).dividedBy(2);
        }];
        [self.megaTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.customContentView).offset(14);
            make.trailing.bottom.equalTo(self.customContentView).offset(-8);
        }];
    }
    if (imagesCount == 2) {
        [self.firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.customContentView).offset(14);
            make.top.equalTo(self.customContentView).offset(8);
            make.trailing.equalTo(self.secondImageView.mas_leading).offset(-8);
            make.bottom.equalTo(self.megaTextLabel.mas_top).offset(-8);
            make.height.equalTo(self.firstImageView.mas_width).dividedBy(1.4);
            make.width.equalTo(self.secondImageView);
        }];
        [self.secondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.customContentView).offset(8);
            make.trailing.equalTo(self.customContentView).offset(-8);
            make.bottom.equalTo(self.megaTextLabel.mas_top).offset(-8);
            make.height.equalTo(self.secondImageView.mas_width).dividedBy(1.4);
        }];
        [self.megaTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.customContentView).offset(14);
            make.trailing.bottom.equalTo(self.customContentView).offset(-8);
        }];
    }
    if (imagesCount == 3) {
        [self.firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.customContentView).offset(14);
            make.top.equalTo(self.customContentView).offset(8);
            make.trailing.equalTo(self.secondImageView.mas_leading).offset(-8);
            make.height.equalTo(self.firstImageView.mas_width).dividedBy(1.4);
            make.width.equalTo(self.secondImageView);
        }];
        [self.secondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.customContentView).offset(8);
            make.trailing.equalTo(self.customContentView).offset(-8);
            make.height.equalTo(self.secondImageView.mas_width).dividedBy(1.4);
        }];
        [self.thirdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.customContentView).offset(14);
            make.top.equalTo(self.firstImageView.mas_bottom).offset(8);
            make.trailing.equalTo(self.customContentView).offset(-8);
            make.bottom.equalTo(self.megaTextLabel.mas_top).offset(-8);
            make.height.equalTo(self.thirdImageView.mas_width).dividedBy(2.6).priority(999);//unknown behaviour - not working without priority
        }];
        [self.megaTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.customContentView).offset(14);
            make.trailing.bottom.equalTo(self.customContentView).offset(-8);
        }];
    }
    if (imagesCount == 4) {
        [self.firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.customContentView).offset(14);
            make.top.equalTo(self.customContentView).offset(8);
            make.trailing.equalTo(self.secondImageView.mas_leading).offset(-8);
            make.height.equalTo(self.firstImageView.mas_width).dividedBy(1.4);
            make.width.equalTo(self.secondImageView);
        }];
        [self.secondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.customContentView).offset(8);
            make.trailing.equalTo(self.customContentView).offset(-8);
            make.height.equalTo(self.secondImageView.mas_width).dividedBy(1.4);
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
        [self.megaTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.customContentView).offset(14);
            make.trailing.bottom.equalTo(self.customContentView).offset(-8);
        }];
    }
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
        UIImage *image = [UIImage imageNamed:@"bubble_greenborder"];
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(8.0, 15.0, 15.0, 8.0);
        _bubbleBackgroundImageView.image = [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
    }
    return _bubbleBackgroundImageView;
}

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
