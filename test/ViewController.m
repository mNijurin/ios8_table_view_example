//
//  ViewController.m
//  test
//
//  Created by Maxim Nizhurin on 11/28/15.
//  Copyright © 2015 test. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "ViewController.h"
#import "MegaCell.h"
#import "UIImageView+WebCache.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cellForRow: %i", indexPath.row);
    NSUInteger imagesCount = (NSUInteger) fmodf(indexPath.row, 5);
//    NSUInteger imagesCount = 4;
    MegaCell *cell = (MegaCell *) [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell%u", imagesCount]];
    if (!cell) {
        cell = [MegaCell cellWithImagesCount:imagesCount];
    }

    NSString *url = @"https://placeimg.com/480/320/people/";
    NSString *resultUrl;

    for (int i = 0; i < cell.imageViews.count; i++) {
        resultUrl = [NSString stringWithFormat:@"%@%@", url, @(indexPath.row * 10 + i)];
        UIImageView *imageView = cell.imageViews[(NSUInteger) i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:resultUrl]];
    }

    cell.megaTextLabel.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";
    return cell;
}


@end
