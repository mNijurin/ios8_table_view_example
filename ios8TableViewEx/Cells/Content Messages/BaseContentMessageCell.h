//
// Created by Maxim Nizhurin on 12/23/15.
// Copyright (c) 2015 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTLModel.h"
#import "BaseMessageCell.h"
#import "SPLMMessage.h"

#define percentTakenByContent .9f

#define replyViewLeftMargin 10
#define replyViewRightMargin 11
#define replyViewExpandedHeight 39

#define leftImageViewLeftMargin 8
#define topImageViewTopMargin 4
#define squareImageWHRatio 1
#define rectangleImageWHRatio 2

#define textLabelLeftMargin 8
#define textLabelRightMargin 8
#define textLabelTopMargin 5

#define bottomBarReducedHeight 8
#define bottomBarExpandedHeight 19

@class ReplyViewInCell;

@interface BaseContentMessageCell : BaseMessageCell

@property (nonatomic, strong) UIView *messageContentView;

@property (nonatomic, strong) UIImageView *bubbleBackgroundImageView;
@property (nonatomic, strong) ReplyViewInCell *replyView;

@property (nonatomic, assign) NSUInteger imagesCount;
@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong) UIImageView *firstImageView;
@property (nonatomic, strong) UIImageView *secondImageView;
@property (nonatomic, strong) UIImageView *thirdImageView;
@property (nonatomic, strong) UIImageView *fourthImageView;

@property (nonatomic, strong) UILabel *megaTextLabel;

@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, strong) UILabel *timeStampLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containerWidth:(CGFloat)containerWidth imagesCount:(NSUInteger)imagesCount;

@end