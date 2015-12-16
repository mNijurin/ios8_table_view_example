//
// Created by Maxim Nizhurin on 12/14/15.
// Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat percentTakenByContent = .8f;
static const CGFloat squareImageWHRatio = 1;
static const CGFloat rectangleImageWHRatio = 2;

@interface BaseMessageCell : UITableViewCell

@property(nonatomic) CGFloat containerWidth;
@property (nonatomic, strong) UIView *customContentView;
@property (nonatomic, strong) UIImageView *bubbleBackgroundImageView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containerWidth:(CGFloat)containerWidth;

- (void)cellDidLoad;

- (void)addSubviews;
- (void)setupConstraints;

- (CGFloat)heightForWidth:(CGFloat)width;

@end