//
// Created by Maxim Nizhurin on 12/23/15.
// Copyright (c) 2015 test. All rights reserved.
//

#import <libextobjc/EXTScope.h>
#import <Masonry/MASConstraintMaker.h>
#import "BaseContentMessageCell.h"
#import "ReplyViewInCell.h"
#import "UIColor+EDHexColor.h"
#import "View+MASAdditions.h"
#import "KOChatEntryElement.h"
#import "UIImageView+WebCache.h"

@implementation BaseContentMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containerWidth:(CGFloat)containerWidth imagesCount:(NSUInteger)imagesCount {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier containerWidth:containerWidth];
    if (self) {
        self.imageViews = [NSMutableArray new];
        self.imagesCount = imagesCount;
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;

        UIImage *image = [UIImage imageNamed:@"bubble_hooked_incoming.png"];
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(38.0, 16.0, 9.0, 9.0);
        self.bubbleBackgroundImageView.image = [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
    }
    return self;
}

#pragma mark - view lifecycle

- (void)addSubviews {
    [super addSubviews];
    [self.customContentView addSubview:self.messageContentView];
    [self.messageContentView addSubview:self.bubbleBackgroundImageView];

    [self.messageContentView addSubview:self.replyView];

    if (self.imagesCount > 0) {
        [self.messageContentView addSubview:self.firstImageView];
        [self.imageViews addObject:self.firstImageView];
    }
    if (self.imagesCount > 1) {
        [self.messageContentView addSubview:self.secondImageView];
        [self.imageViews addObject:self.secondImageView];
    }
    if (self.imagesCount > 2) {
        [self.messageContentView addSubview:self.thirdImageView];
        [self.imageViews addObject:self.thirdImageView];
    }
    if (self.imagesCount > 3) {
        [self.messageContentView addSubview:self.fourthImageView];
        [self.imageViews addObject:self.fourthImageView];
    }
    [self.messageContentView addSubview:self.megaTextLabel];
    [self.messageContentView addSubview:self.bottomBar];
    [self.bottomBar addSubview:self.timeStampLabel];
}

- (void)setupConstraints {
    [super setupConstraints];
    @weakify(self);
    [self.megaTextLabel setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
    [self.megaTextLabel setContentHuggingPriority:10 forAxis:UILayoutConstraintAxisHorizontal];

    if (self.imagesCount == 0) {
        [self.megaTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.messageContentView).offset(textLabelLeftMargin);
            make.top.equalTo(self.replyView.mas_bottom);
            make.trailing.equalTo(self.messageContentView).offset(-textLabelRightMargin);
            make.bottom.equalTo(self.bottomBar.mas_top);
        }];
    } else if (self.imagesCount > 0) {
        [self.megaTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.messageContentView).offset(textLabelLeftMargin);
            make.trailing.equalTo(self.messageContentView).offset(-textLabelRightMargin);
            make.bottom.equalTo(self.bottomBar.mas_top);
        }];
    }

    if (self.imagesCount == 1) {
        [self.firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.messageContentView).offset(leftImageViewLeftMargin);
            make.top.equalTo(self.replyView.mas_bottom).offset(topImageViewTopMargin);
            make.trailing.equalTo(self.messageContentView).offset(-8);
            make.bottom.equalTo(self.megaTextLabel.mas_top).offset(-textLabelTopMargin);
            make.height.equalTo(self.firstImageView.mas_width).dividedBy(squareImageWHRatio);
        }];
    }
    if (self.imagesCount == 2) {
        [self.firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.messageContentView).offset(leftImageViewLeftMargin);
            make.top.equalTo(self.replyView.mas_bottom).offset(topImageViewTopMargin);
            make.trailing.equalTo(self.secondImageView.mas_leading).offset(-8);
            make.bottom.equalTo(self.megaTextLabel.mas_top).offset(-textLabelTopMargin);
            make.height.equalTo(self.firstImageView.mas_width).dividedBy(squareImageWHRatio);
            make.width.equalTo(self.secondImageView);
        }];
        [self.secondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.firstImageView);
            make.trailing.equalTo(self.messageContentView).offset(-8);
            make.bottom.equalTo(self.firstImageView);
            make.height.equalTo(self.secondImageView.mas_width).dividedBy(squareImageWHRatio);
        }];
    }
    if (self.imagesCount == 3) {
        [self.firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.messageContentView).offset(leftImageViewLeftMargin);
            make.top.equalTo(self.replyView.mas_bottom).offset(topImageViewTopMargin);
            make.trailing.equalTo(self.secondImageView.mas_leading).offset(-8);
            make.height.equalTo(self.firstImageView.mas_width).dividedBy(squareImageWHRatio);
            make.width.equalTo(self.secondImageView);
        }];
        [self.secondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.firstImageView);
            make.trailing.equalTo(self.messageContentView).offset(-8);
            make.height.equalTo(self.secondImageView.mas_width).dividedBy(squareImageWHRatio);
        }];
        [self.thirdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.firstImageView);
            make.top.equalTo(self.firstImageView.mas_bottom).offset(8);
            make.trailing.equalTo(self.secondImageView);
            make.bottom.equalTo(self.megaTextLabel.mas_top).offset(-textLabelTopMargin);
            make.height.equalTo(self.thirdImageView.mas_width).dividedBy(rectangleImageWHRatio);
        }];
    }
    if (self.imagesCount == 4) {
        [self.firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.messageContentView).offset(leftImageViewLeftMargin);
            make.top.equalTo(self.replyView.mas_bottom).offset(topImageViewTopMargin);
            make.trailing.equalTo(self.secondImageView.mas_leading).offset(-8);
            make.height.equalTo(self.firstImageView.mas_width).dividedBy(squareImageWHRatio);
            make.width.equalTo(self.secondImageView);
        }];
        [self.secondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.firstImageView);
            make.trailing.equalTo(self.messageContentView).offset(-8);
            make.height.equalTo(self.secondImageView.mas_width).dividedBy(squareImageWHRatio);
        }];
        [self.thirdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.firstImageView.mas_bottom).offset(8);
            make.leading.trailing.equalTo(self.firstImageView);
            make.height.equalTo(self.firstImageView);
            make.bottom.equalTo(self.megaTextLabel.mas_top).offset(-textLabelTopMargin);
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
        make.leading.trailing.bottom.equalTo(self.messageContentView);
    }];
}

- (void)fillWithItem:(BaseMessageItem *)item {
    ContentMessageItem *currentItem = (ContentMessageItem *) item;

    if (currentItem.message.likesCount == 0 && currentItem.message.spamsCount == 0) {
        self.megaTextLabel.text = currentItem.spacedMessageText;
    } else {
        self.megaTextLabel.text = currentItem.messageText;
    }

    int indexOfCurrentImageView = 0;
    for (KOChatEntryElement *element in currentItem.message.contentArray) {
        if (element.type == koChatEntryTypePhoto || element.type == koChatEntryTypeVideo) {
            UIImageView *imageView = self.imageViews[(NSUInteger) indexOfCurrentImageView];
            [imageView sd_setImageWithURL:element.thumbnailURL];
            indexOfCurrentImageView++;
        }
    }
    self.timeStampLabel.text = currentItem.message.creationTimeString;

    self.contentView.frame = CGRectMake(0,0,10000000,10000000);
    @weakify(self);
    if (currentItem.message.likesCount == 0 && currentItem.message.spamsCount == 0 && self.megaTextLabel.text.length > 0) {
        [self.bottomBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(bottomBarReducedHeight);
        }];
        if (currentItem.imagesCount == 1) {
            [self.firstImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.bottom.equalTo(self.megaTextLabel.mas_top).offset(-textLabelTopMargin);
            }];
        }
        if (currentItem.imagesCount == 2) {
            [self.firstImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.bottom.equalTo(self.megaTextLabel.mas_top).offset(-textLabelTopMargin);
            }];
        }
        if (currentItem.imagesCount == 3) {
            [self.thirdImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.bottom.equalTo(self.megaTextLabel.mas_top).offset(-textLabelTopMargin);
            }];
        }
        if (currentItem.imagesCount == 4) {
            [self.thirdImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.bottom.equalTo(self.megaTextLabel.mas_top).offset(-textLabelTopMargin);
            }];
        }
    } else if ((currentItem.message.likesCount != 0 || currentItem.message.spamsCount != 0) && self.megaTextLabel.text.length > 0) {
        [self.bottomBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(bottomBarExpandedHeight);
        }];
        if (currentItem.imagesCount == 1) {
            [self.firstImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.bottom.equalTo(self.megaTextLabel.mas_top).offset(-textLabelTopMargin);
            }];
        }
        if (currentItem.imagesCount == 2) {
            [self.firstImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.bottom.equalTo(self.megaTextLabel.mas_top).offset(-textLabelTopMargin);
            }];
        }
        if (currentItem.imagesCount == 3) {
            [self.thirdImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.bottom.equalTo(self.megaTextLabel.mas_top).offset(-textLabelTopMargin);
            }];
        }
        if (currentItem.imagesCount == 4) {
            [self.thirdImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.bottom.equalTo(self.megaTextLabel.mas_top).offset(-textLabelTopMargin);
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
                make.bottom.equalTo(self.megaTextLabel.mas_top);
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

#pragma mark - getters

- (UIView *)messageContentView {
    if (!_messageContentView) {
        _messageContentView = [UIView new];
        _messageContentView.backgroundColor = [UIColor clearColor];
    }
    return _messageContentView;
}

- (UIImageView *)bubbleBackgroundImageView {
    if (!_bubbleBackgroundImageView) {
        _bubbleBackgroundImageView = [UIImageView new];
    }
    return _bubbleBackgroundImageView;
}

- (ReplyViewInCell *)replyView {
    if (!_replyView) {
        _replyView = [ReplyViewInCell new];
        _replyView.backgroundColor = [UIColor clearColor];
    }
    return _replyView;
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