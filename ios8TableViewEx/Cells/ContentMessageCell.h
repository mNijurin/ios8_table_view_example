//
//  ContentMessageCell.h
//  test
//
//  Created by Maxim Nizhurin on 11/28/15.
//  Copyright © 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMessageCell.h"

@class ContentMessageItem;
@class NIAttributedLabel;

@interface ContentMessageCell : BaseMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containerWidth:(CGFloat)containerWidth imagesCount:(NSUInteger)imagesCount;

@end
