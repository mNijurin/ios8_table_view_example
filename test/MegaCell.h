//
//  MegaCell.h
//  test
//
//  Created by Maxim Nizhurin on 11/28/15.
//  Copyright © 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MegaCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *firstImageView;
@property (nonatomic, weak) IBOutlet UIImageView *secondImageView;
@property (nonatomic, weak) IBOutlet UIImageView *thirdImageView;
@property (nonatomic, weak) IBOutlet UIImageView *fourthImageView;
@property (nonatomic, weak) IBOutlet UILabel *megaTextLabel;

@property (nonatomic, weak) IBOutlet UIImageView *bubbleBackgroundImageView;

@property (nonatomic, strong) NSNumber *row;
@property (nonatomic, strong) NSMutableArray *imageViews;
@end
