//
//  ContentMessageCell.m
//  test
//
//  Created by Maxim Nizhurin on 11/28/15.
//  Copyright © 2015 test. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import "ContentMessageCell.h"
#import "EXTScope.h"
#import "View+MASAdditions.h"
#import "ContentMessageItem.h"
#import "UIImageView+WebCache.h"
#import "KOChatEntryElement.h"
#import "SPLMMessage.h"
#import "UIColor+EDHexColor.h"

@interface ContentMessageCell ()

@property (nonatomic, strong) UIImageView *bubbleBackgroundImageView;

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIView *avatarStrokeView;

@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UILabel *userNameLabel;

@property (nonatomic, assign) NSUInteger imagesCount;
@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong) UIImageView *firstImageView;
@property (nonatomic, strong) UIImageView *secondImageView;
@property (nonatomic, strong) UIImageView *thirdImageView;
@property (nonatomic, strong) UIImageView *fourthImageView;

@property (nonatomic, strong) UILabel *megaTextLabel;

@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, strong) UILabel *timeStampLabel;

@end

@implementation ContentMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containerWidth:(CGFloat)containerWidth imagesCount:(NSUInteger)imagesCount {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier containerWidth:containerWidth];
    if (self) {
        self.imageViews = [NSMutableArray new];
        self.imagesCount = imagesCount;
    }
    return self;
}

#pragma mark  - ui

- (void)addSubviews {
    [super addSubviews];
    [self.customContentView addSubview:self.avatarStrokeView];
    [self.customContentView addSubview:self.avatarImageView];
    [self.customContentView addSubview:self.bubbleBackgroundImageView];
    [self.customContentView addSubview:self.topBar];
    [self.topBar addSubview:self.userNameLabel];
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
    [self.customContentView addSubview:self.bottomBar];
    [self.bottomBar addSubview:self.timeStampLabel];
}

- (void)setupConstraints {
    [super setupConstraints];
    @weakify(self);
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.leading.equalTo(self.customContentView).offset(6);
        make.top.equalTo(self.customContentView).offset(1);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(32);
    }];
    [self.avatarStrokeView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.centerY.equalTo(self.avatarImageView);
        make.width.height.equalTo(self.avatarImageView).offset(1);
    }];
    [self.bubbleBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.leading.equalTo(self.customContentView).offset(40);
        make.top.trailing.bottom.equalTo(self.customContentView);
    }];
    [self.topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.leading.equalTo(self.customContentView).offset(54);
        make.top.trailing.equalTo(self.customContentView);
        make.height.mas_equalTo(25);
    }];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.leading.equalTo(self.topBar).offset(4);
        make.bottom.equalTo(self.topBar).offset(-1);
    }];
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
            make.leading.equalTo(self.customContentView).offset(textLabelLeftMargin);
            make.top.equalTo(self.topBar.mas_bottom);
            make.trailing.equalTo(self.customContentView).offset(-textLabelRightMargin);
            make.bottom.equalTo(self.bottomBar.mas_top);
        }];
    } else if (self.imagesCount > 0) {
        [self.customContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(5);
            make.bottom.equalTo(self.contentView).offset(-5);
            make.width.mas_equalTo(self.containerMinWidth * percentTakenByContent);
        }];
        [self.megaTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.customContentView).offset(textLabelLeftMargin);
            make.trailing.equalTo(self.customContentView).offset(-textLabelRightMargin);
            make.bottom.equalTo(self.bottomBar.mas_top);
        }];
    }
    if (self.imagesCount == 1) {
        [self.firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.customContentView).offset(54);
            make.top.equalTo(self.topBar.mas_bottom);
            make.trailing.equalTo(self.customContentView).offset(-8);
            make.bottom.equalTo(self.megaTextLabel.mas_top).offset(-8);
            make.height.equalTo(self.firstImageView.mas_width).dividedBy(squareImageWHRatio);
        }];
    }
    if (self.imagesCount == 2) {
        [self.firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.customContentView).offset(54);
            make.top.equalTo(self.topBar.mas_bottom);
            make.trailing.equalTo(self.secondImageView.mas_leading).offset(-8);
            make.bottom.equalTo(self.megaTextLabel.mas_top).offset(-8);
            make.height.equalTo(self.firstImageView.mas_width).dividedBy(squareImageWHRatio);
            make.width.equalTo(self.secondImageView);
        }];
        [self.secondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.firstImageView);
            make.trailing.equalTo(self.customContentView).offset(-8);
            make.bottom.equalTo(self.firstImageView);
            make.height.equalTo(self.secondImageView.mas_width).dividedBy(squareImageWHRatio);
        }];
    }
    if (self.imagesCount == 3) {
        [self.firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.customContentView).offset(54);
            make.top.equalTo(self.topBar.mas_bottom);
            make.trailing.equalTo(self.secondImageView.mas_leading).offset(-8);
            make.height.equalTo(self.firstImageView.mas_width).dividedBy(squareImageWHRatio);
            make.width.equalTo(self.secondImageView);
        }];
        [self.secondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.firstImageView);
            make.trailing.equalTo(self.customContentView).offset(-8);
            make.height.equalTo(self.secondImageView.mas_width).dividedBy(squareImageWHRatio);
        }];
        [self.thirdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.firstImageView);
            make.top.equalTo(self.firstImageView.mas_bottom).offset(8);
            make.trailing.equalTo(self.customContentView).offset(-8);
            make.bottom.equalTo(self.megaTextLabel.mas_top).offset(-8);
            make.height.equalTo(self.thirdImageView.mas_width).dividedBy(rectangleImageWHRatio);
        }];
    }
    if (self.imagesCount == 4) {
        [self.firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.customContentView).offset(54);
            make.top.equalTo(self.topBar.mas_bottom);
            make.trailing.equalTo(self.secondImageView.mas_leading).offset(-8);
            make.height.equalTo(self.firstImageView.mas_width).dividedBy(squareImageWHRatio);
            make.width.equalTo(self.secondImageView);
        }];
        [self.secondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.firstImageView);
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
            make.bottom.equalTo(self.thirdImageView);
        }];
    }
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.height.mas_equalTo(bottomBarReducedHeight).key(@"bottom_bar_height");
        make.leading.trailing.bottom.equalTo(self.customContentView);
    }];
    [self.timeStampLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.trailing.equalTo(self.bottomBar).offset(-5);
        make.bottom.equalTo(self.bottomBar).offset(-2);
    }];
}

#pragma mark - life cycle

- (void)fillWithItem:(BaseMessageItem *)item {
    ContentMessageItem *currentItem = (ContentMessageItem *) item;

    if (currentItem.message.userAvatarThumbUrl) {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:currentItem.message.userAvatarThumbUrl]];
    }

    self.userNameLabel.text = item.message.userName;

    int indexOfCurrentImageView = 0;
    self.megaTextLabel.text = @"";
    for (KOChatEntryElement *element in currentItem.message.contentArray) {
        if (element.type == koChatEntryTypePhoto || element.type == koChatEntryTypeVideo) {
            UIImageView *imageView = self.imageViews[(NSUInteger) indexOfCurrentImageView];
            [imageView sd_setImageWithURL:element.thumbnailURL];
            indexOfCurrentImageView++;
        } else if (element.type == koChatEntryTypeText) {
            if ([self.megaTextLabel.text isEqualToString:@""]) {
                self.megaTextLabel.text = element.text;
            } else {
                self.megaTextLabel.text = [NSString stringWithFormat:@"%@\n%@", self.megaTextLabel.text, element.text];
            }
        }
    }
    self.timeStampLabel.text = currentItem.message.creationTimeString;

    if (currentItem.message.likesCount == 0 && currentItem.message.spamsCount == 0 && self.megaTextLabel.text.length > 0) {
        NSUInteger initialLength = self.megaTextLabel.text.length;
        NSUInteger additionalLength = currentItem.message.creationTimeString.length + 3;
        NSUInteger resultLength = initialLength + additionalLength;
        NSString *stringWithNbspInserted = [self.megaTextLabel.text stringByPaddingToLength:resultLength withString:@"\u00a0" startingAtIndex:0];
        NSString *stringWithJoinChar = [NSString stringWithFormat:@"%@\u200c", stringWithNbspInserted];
        self.megaTextLabel.text = stringWithJoinChar;
    }

    self.contentView.frame = CGRectMake(0,0,10000000,10000000);
    @weakify(self);
    if (currentItem.message.likesCount == 0 && currentItem.message.spamsCount == 0 && self.megaTextLabel.text.length > 0) {
        [self.bottomBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(bottomBarReducedHeight);
        }];
        if (currentItem.imagesCount == 1) {
            [self.firstImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.bottom.equalTo(self.megaTextLabel.mas_top).offset(-8);
            }];
        }
        if (currentItem.imagesCount == 2) {
            [self.firstImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.bottom.equalTo(self.megaTextLabel.mas_top).offset(-8);
            }];
        }
        if (currentItem.imagesCount == 3) {
            [self.thirdImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.bottom.equalTo(self.megaTextLabel.mas_top).offset(-8);
            }];
        }
        if (currentItem.imagesCount == 4) {
            [self.thirdImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.bottom.equalTo(self.megaTextLabel.mas_top).offset(-8);
            }];
        }
    } else if ((currentItem.message.likesCount != 0 || currentItem.message.spamsCount != 0) && self.megaTextLabel.text.length > 0) {
        [self.bottomBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(bottomBarExpandedHeight);
        }];
        if (currentItem.imagesCount == 1) {
            [self.firstImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.bottom.equalTo(self.megaTextLabel.mas_top).offset(-8);
            }];
        }
        if (currentItem.imagesCount == 2) {
            [self.firstImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.bottom.equalTo(self.megaTextLabel.mas_top).offset(-8);
            }];
        }
        if (currentItem.imagesCount == 3) {
            [self.thirdImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.bottom.equalTo(self.megaTextLabel.mas_top).offset(-8);
            }];
        }
        if (currentItem.imagesCount == 4) {
            [self.thirdImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.bottom.equalTo(self.megaTextLabel.mas_top).offset(-8);
            }];
        }
    } else {
        [self.bottomBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(bottomBarExpandedHeight);
        }];
        if (currentItem.imagesCount == 1) {
            [self.firstImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.bottom.equalTo(self.megaTextLabel.mas_top);
            }];
        }
        if (currentItem.imagesCount == 2) {
            [self.firstImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.bottom.equalTo(self.megaTextLabel.mas_top).offset(0);
            }];
        }
        if (currentItem.imagesCount == 3) {
            [self.thirdImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.bottom.equalTo(self.megaTextLabel.mas_top);
            }];
        }
        if (currentItem.imagesCount == 4) {
            [self.thirdImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.bottom.equalTo(self.megaTextLabel.mas_top);
            }];
        }
    }
}

- (CGFloat)heightForWidth:(CGFloat)width {
    CGFloat horizontalLabelMargins = textLabelLeftMargin + textLabelRightMargin;
    if (self.imagesCount == 0) {
        self.megaTextLabel.preferredMaxLayoutWidth = width * percentTakenByContent - horizontalLabelMargins;
    } else if (self.imagesCount > 0) {
        self.megaTextLabel.preferredMaxLayoutWidth = self.containerMinWidth * percentTakenByContent - horizontalLabelMargins;
    }
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

#pragma mark - getters

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView new];
        _avatarImageView.layer.cornerRadius = 17;
        _avatarImageView.clipsToBounds = YES;
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _avatarImageView;
}

- (UIView *)avatarStrokeView {
    if (!_avatarStrokeView) {
        _avatarStrokeView = [UIView new];
        _avatarStrokeView.backgroundColor = [UIColor greenColor];
        _avatarStrokeView.layer.cornerRadius = 17;
    }
    return _avatarStrokeView;
}

- (UIImageView *)bubbleBackgroundImageView {
    if (!_bubbleBackgroundImageView) {
        _bubbleBackgroundImageView = [UIImageView new];
        UIImage *image = [UIImage imageNamed:@"bubble_hooked_incoming.png"];
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(38.0, 16.0, 9.0, 9.0);
        _bubbleBackgroundImageView.image = [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
    }
    return _bubbleBackgroundImageView;
}

- (UIView *)topBar {
    if (!_topBar) {
        _topBar = [UIView new];
        _topBar.backgroundColor = [UIColor clearColor];
    }
    return _topBar;
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [UILabel new];
        _userNameLabel.font = [UIFont boldSystemFontOfSize:14.3];
        _userNameLabel.textColor = [UIColor colorWithHexString:@"ff7c00"];
    }
    return _userNameLabel;
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
        _megaTextLabel.font = [UIFont systemFontOfSize:17];
        _megaTextLabel.numberOfLines = 0;
    }
    return _megaTextLabel;
}

- (UIView *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [UIView new];
        _bottomBar.backgroundColor = [UIColor clearColor];
    }
    return _bottomBar;
}

- (UILabel *)timeStampLabel {
    if (!_timeStampLabel) {
        _timeStampLabel = [UILabel new];
        _timeStampLabel.textColor = [UIColor colorWithHexString:@"CCCCCC"];
        _timeStampLabel.font = [UIFont italicSystemFontOfSize:12];
    }
    return _timeStampLabel;
}

@end
