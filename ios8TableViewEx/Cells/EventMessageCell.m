//
// Created by Maxim Nizhurin on 12/19/15.
// Copyright (c) 2015 test. All rights reserved.
//

#import "MTLModel.h"
#import <libextobjc/EXTScope.h>
#import <Masonry/View+MASAdditions.h>
#import "EventMessageCell.h"
#import "BaseMessageItem.h"
#import "SPLMMessage.h"
#import "GRVEventMessageModel.h"

@interface EventMessageCell ()

@property (nonatomic, strong) UILabel *eventLabel;
@property (nonatomic, strong) UIImageView *eventBackgroundImageView;

@end

@implementation EventMessageCell

- (void)addSubviews {
    [super addSubviews];
    [self.customContentView addSubview:self.eventBackgroundImageView];
    [self.customContentView addSubview:self.eventLabel];
}

- (void)setupConstraints {
    [super setupConstraints];
    @weakify(self);
    [self.customContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.leading.trailing.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(5);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
    [self.eventLabel setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
    [self.eventLabel setContentHuggingPriority:10 forAxis:UILayoutConstraintAxisHorizontal];
    [self.eventLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.customContentView);
        make.top.bottom.equalTo(self.customContentView);
        make.width.lessThanOrEqualTo(self.customContentView).offset(-20);
    }];
    [self.eventBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.eventLabel);
        make.leading.equalTo(self.eventLabel).offset(-5);
        make.trailing.equalTo(self.eventLabel).offset(5);
    }];
}

- (void)fillWithItem:(BaseMessageItem *)item {
    self.eventLabel.text = item.message.event.eventMessage;
}

- (CGFloat)heightForWidth:(CGFloat)width {
    self.eventLabel.preferredMaxLayoutWidth = width - 20;
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}


#pragma mark - getters

- (UILabel *)eventLabel {
    if (!_eventLabel) {
        _eventLabel = [UILabel new];
        _eventLabel.font = [UIFont systemFontOfSize:13];
    }
    return _eventLabel;
}

- (UIImageView *)eventBackgroundImageView {
    if (!_eventBackgroundImageView) {
        _eventBackgroundImageView = [UIImageView new];
        UIImage *image = [UIImage imageNamed:@"event_message_bubble"];
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(7.0, 7.0, 7.0, 7.0);
        _eventBackgroundImageView.image = [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
    }
    return _eventBackgroundImageView;
}

@end