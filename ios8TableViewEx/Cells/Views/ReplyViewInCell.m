//
// Created by Maxim Nizhurin on 12/23/15.
// Copyright (c) 2015 test. All rights reserved.
//

#import <libextobjc/EXTScope.h>
#import "MTLModel.h"
#import "ReplyViewInCell.h"
#import "View+MASAdditions.h"
#import "UIColor+EDHexColor.h"
#import "SPLMMessage.h"
#import "KOChatEntryElement.h"
#import "UIImageView+WebCache.h"

#define originalImageSize 30

@implementation ReplyViewInCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
        [self setupConstraints];
    }
    return self;
}

#pragma mark - view lifecycle

- (void)addSubviews {
    [self addSubview:self.leftLineView];
    [self addSubview:self.originalImageView];
    [self addSubview:self.userNameLabel];
    [self addSubview:self.originalTextLabel];
}

-(void)setupConstraints {
    @weakify(self);
    [self.leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(1);
        make.leading.equalTo(self);
        make.top.equalTo(self);
    }];
    [self.originalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.height.mas_equalTo(originalImageSize);
        make.leading.equalTo(self.leftLineView.mas_trailing).offset(8);
        make.centerY.equalTo(self.leftLineView);
    }];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.leading.equalTo(self.originalImageView.mas_trailing).offset(8);
        make.top.equalTo(self).offset(2);
        make.trailing.equalTo(self).offset(8);
    }];
    [self.originalTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.leading.equalTo(self.originalImageView.mas_trailing).offset(7);
        make.top.equalTo(self.userNameLabel.mas_bottom).offset(-1);
        make.trailing.equalTo(self).offset(8);
    }];
}

- (void)fillWithItem:(ContentMessageItem *)contentItem {
    NSUInteger countOfMediaInReply = 0;
    BOOL imageIsSet = NO;
    BOOL textIsSet = NO;
    KOChatEntryType firstMediaType = koChatEntryTypePhoto;
    NSURL *thumbUrl;
    NSString *originalText;
    for (KOChatEntryElement *element in contentItem.message.repliedMessage.contentArray) {
        if ((element.type == koChatEntryTypePhoto || element.type == koChatEntryTypeVideo) && !imageIsSet) {
            countOfMediaInReply++;
            firstMediaType = element.type;
            thumbUrl = element.thumbnailURL;
            imageIsSet = YES;
        } else if (element.type == koChatEntryTypeText && !textIsSet) {
            originalText = element.text;
            textIsSet = YES;
        }
    }
    self.userNameLabel.text = contentItem.message.repliedMessage.userName;
    if (countOfMediaInReply == 0) {
        self.originalTextLabel.text = originalText;

        @weakify(self);
        [self.originalImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.width.mas_equalTo(0);
            make.leading.equalTo(self.leftLineView.mas_trailing);
        }];
    } else {
        [self.originalImageView sd_setImageWithURL:thumbUrl];
        if (textIsSet) {
            self.originalTextLabel.text = originalText;
        } else {
            self.originalTextLabel.text = firstMediaType == koChatEntryTypePhoto ? @"photo" : @"video";
        }

        @weakify(self);
        [self.originalImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.width.mas_equalTo(originalImageSize);
            make.leading.equalTo(self.leftLineView.mas_trailing).offset(8);
        }];
    }
}

#pragma mark - getters

- (UIView *)leftLineView {
    if (!_leftLineView) {
        _leftLineView = [UIView new];
        _leftLineView.backgroundColor = [UIColor colorWithHexString:@"9d9892"];
    }
    return _leftLineView;
}

- (UIImageView *)originalImageView {
    if (!_originalImageView) {
        _originalImageView = [UIImageView new];
        _originalImageView.layer.cornerRadius = 1.5;
        _originalImageView.contentMode = UIViewContentModeScaleAspectFill;
        _originalImageView.clipsToBounds = YES;
    }
    return _originalImageView;
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [UILabel new];
        _userNameLabel.font = [UIFont systemFontOfSize:12];
        _userNameLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _userNameLabel;
}

- (UILabel *)originalTextLabel {
    if (!_originalTextLabel) {
        _originalTextLabel = [UILabel new];
        _originalTextLabel.font = [UIFont systemFontOfSize:15];
        _originalTextLabel.textColor = [UIColor colorWithHexString:@"999999"];
        _originalTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _originalTextLabel;
}

@end