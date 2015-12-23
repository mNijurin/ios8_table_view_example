//
//  ContentIncomingMessageCell.h
//  test
//
//  Created by Maxim Nizhurin on 11/28/15.
//  Copyright © 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMessageCell.h"

static const CGFloat percentTakenByContent = .9f;

static const int replyViewExpandedHeight = 39;
static const int replyViewReducedHeight = 3;
static const int replyViewTopMargin = 5;

static const int topImageViewTopMargin = 4;
static const CGFloat squareImageWHRatio = 1;
static const CGFloat rectangleImageWHRatio = 2;

static const int textLabelLeftMargin = 56;
static const int textLabelRightMargin = 8;
static const int textLabelTopMargin = 5;

static const int bottomBarReducedHeight = 8;
static const int bottomBarExpandedHeight = 19;

@class ContentMessageItem;
@class NIAttributedLabel;

@interface ContentIncomingMessageCell : BaseMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containerWidth:(CGFloat)containerWidth imagesCount:(NSUInteger)imagesCount;

@end
