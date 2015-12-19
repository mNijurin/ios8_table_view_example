//
// Created by Maxim Nizhurin on 12/14/15.
// Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseMessageItem;

static const CGFloat percentTakenByContent = .8f;
static const CGFloat squareImageWHRatio = 1;
static const CGFloat rectangleImageWHRatio = 2;

@interface BaseMessageCell : UITableViewCell

@property(nonatomic) CGFloat containerWidth;
@property (nonatomic, strong) UIView *customContentView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containerWidth:(CGFloat)containerWidth;

- (void)cellDidLoad;

- (void)addSubviews;
- (void)setupConstraints;

- (void)fillWithItem:(BaseMessageItem *)item;

- (CGFloat)heightForWidth:(CGFloat)width;

@end