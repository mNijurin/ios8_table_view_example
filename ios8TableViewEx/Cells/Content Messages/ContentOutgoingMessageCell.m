//
// Created by Maxim Nizhurin on 12/23/15.
// Copyright (c) 2015 test. All rights reserved.
//

#import <Masonry/MASConstraintMaker.h>
#import <libextobjc/EXTScope.h>
#import <Masonry/View+MASAdditions.h>
#import "ContentOutgoingMessageCell.h"
#import "ReplyViewInCell.h"
@interface ContentOutgoingMessageCell ()

@property (nonatomic, strong) UIImageView *statusImageView;

@end

@implementation ContentOutgoingMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containerWidth:(CGFloat)containerWidth imagesCount:(NSUInteger)imagesCount {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier containerWidth:containerWidth imagesCount:imagesCount];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"bubble_hooked_outgoing"];
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(21.0, 9.0, 9.0, 16.0);
        self.bubbleBackgroundImageView.image = [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
    }
    return self;
}

- (void)addSubviews {
    [super addSubviews];
    [self.messageContentView addSubview:self.statusImageView];
}

- (void)setupConstraints {
    [super setupConstraints];
    @weakify(self);
    if (self.imagesCount == 0) {
        [self.customContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.contentView).offset(5);
            make.trailing.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-5);
            make.width.lessThanOrEqualTo(self.contentView).multipliedBy(percentTakenByContent);
        }];
    } else if (self.imagesCount > 0) {
        [self.customContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.contentView).offset(5);
            make.trailing.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-5);
            make.width.mas_equalTo(self.containerMinWidth * percentTakenByContent);
        }];
    }

    [self.messageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.leading.bottom.equalTo(self.customContentView);
        make.trailing.equalTo(self.customContentView).offset(-7);
    }];
    [self.bubbleBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.trailing.equalTo(self.messageContentView).offset(7);
        make.top.leading.bottom.equalTo(self.messageContentView);
    }];

    [self.replyView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.leading.equalTo(self.messageContentView).offset(replyViewLeftMargin);
        make.top.equalTo(self.messageContentView).offset(replyViewTopMargin);
        make.trailing.equalTo(self.messageContentView).offset(-replyViewRightMargin);
        make.height.mas_equalTo(replyViewExpandedHeight);
    }];

    [self.timeStampLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.trailing.equalTo(self.statusImageView.mas_leading).offset(-5);
        make.bottom.equalTo(self.bottomBar).offset(-2);
    }];
    [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.bottomBar).offset(-2);
        make.trailing.equalTo(self.bottomBar).offset(-5);
        make.width.height.mas_equalTo(12);
    }];
}

- (void)fillWithItem:(BaseMessageItem *)item {
    [super fillWithItem:item];
    ContentMessageItem *currentItem = (ContentMessageItem *) item;

    @weakify(self);
    if (currentItem.message.repliedMessage) {
        [self.replyView fillWithItem:currentItem];
        self.replyView.hidden = NO;
        [self.replyView mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.messageContentView).offset(replyViewTopMargin);
            make.height.mas_equalTo(replyViewExpandedHeight);
        }];
    } else {
        self.replyView.hidden = YES;
        [self.replyView mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.messageContentView);
            make.height.mas_equalTo(replyViewReducedHeight);
        }];
    }
}

- (CGFloat)heightForWidth:(CGFloat)width {
    CGFloat horizontalLabelMargins = textLabelLeftMargin + textLabelRightMargin + 7;
    if (self.imagesCount == 0) {
        self.megaTextLabel.preferredMaxLayoutWidth = width * percentTakenByContent - horizontalLabelMargins;
    } else if (self.imagesCount > 0) {
        self.megaTextLabel.preferredMaxLayoutWidth = self.containerMinWidth * percentTakenByContent - horizontalLabelMargins;
    }
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

#pragma mark - getters

- (UIImageView *)statusImageView {
    if (!_statusImageView) {
        _statusImageView = [UIImageView new];
        _statusImageView.image = [UIImage imageNamed:@"message_status_sent"];
    }
    return _statusImageView;
}

@end