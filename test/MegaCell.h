//
//  MegaCell.h
//  test
//
//  Created by Maxim Nizhurin on 11/28/15.
//  Copyright © 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MegaCell : UITableViewCell
@property (nonatomic, strong) UILabel *megaTextLabel;

@property (nonatomic, strong) NSMutableArray *imageViews;

+ (instancetype)cellWithImagesCount:(NSUInteger)imagesCount;
@end
