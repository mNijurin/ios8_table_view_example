//
// Created by Maxim Nizhurin on 12/23/15.
// Copyright (c) 2015 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ContentMessageItem.h"

@interface ReplyViewInCell : UIView

@property (nonatomic, strong) UIView *leftLineView;
@property (nonatomic, strong) UIImageView *originalImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *originalTextLabel;

- (void)fillWithItem:(ContentMessageItem *)contentItem;

@end