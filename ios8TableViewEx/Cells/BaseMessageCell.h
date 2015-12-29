//
// Created by Maxim Nizhurin on 12/14/15.
// Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseMessageItem;

@interface BaseMessageCell : UITableViewCell

@property(nonatomic) CGFloat containerMinWidth;
@property (nonatomic, strong) UIView *customContentView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containerWidth:(CGFloat)containerWidth;

- (void)cellDidLoad;

- (void)addSubviews;
- (void)setupConstraints;

- (void)fillWithItem:(BaseMessageItem *)item;

- (CGFloat)calculateHeight;

@end