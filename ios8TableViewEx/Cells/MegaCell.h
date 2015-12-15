//
//  MegaCell.h
//  test
//
//  Created by Maxim Nizhurin on 11/28/15.
//  Copyright © 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMessageCell.h"

@class MegaItem;
@class NIAttributedLabel;

@interface MegaCell : BaseMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containerWidth:(CGFloat)containerWidth imagesCount:(NSUInteger)imagesCount;

- (void)fillWithItem:(MegaItem *)item;

@end
