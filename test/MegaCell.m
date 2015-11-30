//
//  MegaCell.m
//  test
//
//  Created by Maxim Nizhurin on 11/28/15.
//  Copyright © 2015 test. All rights reserved.
//

#import "MegaCell.h"


@implementation MegaCell

- (void)awakeFromNib {
//    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;

    self.imageViews = [NSMutableArray new];
    if (self.firstImageView) {
        self.firstImageView.clipsToBounds = YES;
        self.firstImageView.layer.cornerRadius = 3;
        [self.imageViews addObject:self.firstImageView];
    }
    if (self.secondImageView) {
        self.secondImageView.clipsToBounds = YES;
        self.secondImageView.layer.cornerRadius = 3;
        [self.imageViews addObject:self.secondImageView];
    }
    if (self.thirdImageView) {
        self.thirdImageView.clipsToBounds = YES;
        self.thirdImageView.layer.cornerRadius = 3;
        [self.imageViews addObject:self.thirdImageView];
    }
    if (self.fourthImageView) {
        self.fourthImageView.clipsToBounds = YES;
        self.fourthImageView.layer.cornerRadius = 3;
        [self.imageViews addObject:self.fourthImageView];
    }

    UIImage *image = [UIImage imageNamed:@"bubble_greenborder"];
//    UIEdgeInsets edgeInsets = flip ? UIEdgeInsetsMake(15.0, 15.0, 8.0, 8.0) : UIEdgeInsetsMake(8.0, 15.0, 15.0, 8.0);
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(8.0, 15.0, 15.0, 8.0);
    self.bubbleBackgroundImageView.image = [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
