//
//  ContentIncomingMessageCell.m
//  test
//
//  Created by Maxim Nizhurin on 11/28/15.
//  Copyright © 2015 test. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import "ContentIncomingMessageCell.h"
#import "EXTScope.h"
#import "View+MASAdditions.h"
#import "ContentMessageItem.h"
#import "UIImageView+WebCache.h"
#import "UIColor+EDHexColor.h"
#import "ReplyViewInCell.h"

#define messageContentViewLeftMargin 45

@interface ContentIncomingMessageCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UILabel *userNameLabel;

@end

@implementation ContentIncomingMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containerWidth:(CGFloat)containerWidth imagesCount:(NSUInteger)imagesCount {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier containerWidth:containerWidth imagesCount:imagesCount];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"bubble_hooked_incoming.png"];
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(38.0, 16.0, 9.0, 9.0);
        self.bubbleBackgroundImageView.image = [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
    }
    return self;
}

#pragma mark - view lifecycle

- (void)addSubviews {
    [super addSubviews];
    [self.customContentView addSubview:self.avatarImageView];
    [self.messageContentView addSubview:self.topBar];
    [self.topBar addSubview:self.userNameLabel];
}

- (void)setupConstraints {
    [super setupConstraints];
    @weakify(self);
    if (self.imagesCount == 0) {
        [self.customContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(5);
            make.bottom.equalTo(self.contentView).offset(-5);
            make.width.lessThanOrEqualTo(self.contentView).multipliedBy(percentTakenByContent);
        }];
    } else if (self.imagesCount > 0) {
        [self.customContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(5);
            make.bottom.equalTo(self.contentView).offset(-5);
            make.width.mas_equalTo(self.containerMinWidth * percentTakenByContent);
        }];
    }

    [self.messageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.leading.equalTo(self.customContentView).offset(messageContentViewLeftMargin);
        make.top.trailing.bottom.equalTo(self.customContentView);
    }];
    [self.bubbleBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.leading.equalTo(self.messageContentView).offset(-7);
        make.top.trailing.bottom.equalTo(self.messageContentView);
    }];

    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.leading.equalTo(self.customContentView).offset(4);
        make.top.equalTo(self.customContentView);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(35);
    }];

    [self.topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.leading.equalTo(self.messageContentView).offset(8);
        make.top.trailing.equalTo(self.messageContentView);
        make.height.mas_equalTo(24);
    }];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.leading.equalTo(self.topBar);
        make.bottom.equalTo(self.topBar);
    }];

    [self.replyView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.leading.equalTo(self.messageContentView).offset(replyViewLeftMargin);
        make.top.equalTo(self.topBar.mas_bottom).offset(replyViewTopMargin);
        make.trailing.equalTo(self.messageContentView).offset(-replyViewRightMargin);
        make.height.mas_equalTo(replyViewExpandedHeight);
    }];

    [self.timeStampLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.trailing.equalTo(self.bottomBar).offset(-5);
        make.bottom.equalTo(self.bottomBar).offset(-2);
    }];
}

#pragma mark - life cycle

- (void)fillWithItem:(BaseMessageItem *)item {
    [super fillWithItem:item];
    ContentMessageItem *currentItem = (ContentMessageItem *) item;

    if (currentItem.message.userAvatarThumbUrl) {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:currentItem.message.userAvatarThumbUrl]];
    }

    self.userNameLabel.text = item.message.userName;
    
    @weakify(self);
    if (currentItem.message.repliedMessage) {
        [self.replyView fillWithItem:currentItem];
        self.replyView.hidden = NO;
        [self.replyView mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.topBar.mas_bottom).offset(replyViewTopMargin);
            make.height.mas_equalTo(replyViewExpandedHeight);
        }];
    } else {
        self.replyView.hidden = YES;
        [self.replyView mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.topBar.mas_bottom);
            make.height.mas_equalTo(replyViewReducedHeight);
        }];
    }
}

- (CGFloat)heightForWidth:(CGFloat)width {
    CGFloat horizontalLabelMargins = textLabelLeftMargin + textLabelRightMargin;
    if (self.imagesCount == 0) {
        self.megaTextLabel.preferredMaxLayoutWidth = width * percentTakenByContent - messageContentViewLeftMargin - horizontalLabelMargins;
    } else if (self.imagesCount > 0) {
        self.megaTextLabel.preferredMaxLayoutWidth = self.containerMinWidth * percentTakenByContent - messageContentViewLeftMargin - horizontalLabelMargins;
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
        _userNameLabel.font = [UIFont boldSystemFontOfSize:13.7];
        _userNameLabel.textColor = [UIColor colorWithHexString:@"ff7c00"];
    }
    return _userNameLabel;
}

@end
