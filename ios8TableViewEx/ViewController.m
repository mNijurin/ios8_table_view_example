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
#import "MegaItem.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.items = [NSMutableArray new];
    for (int i = 0; i < 101; i ++) {
        [self.items addObject:[MegaItem itemWithImagesCount:(NSUInteger) fmodf(i, 5) index:i]];
    }
    self.tableView.estimatedRowHeight = 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cellForRow: %i", indexPath.row);
    MegaItem *currentItem = self.items[(NSUInteger) indexPath.row];
    MegaCell *cell = (MegaCell *) [tableView dequeueReusableCellWithIdentifier:currentItem.reuseIdentifier];
    if (!cell) {
        cell = [currentItem createCell];
    }
    [cell fillWithItem:currentItem];

//    cell.megaTextLabel.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat estimatedHeight;
    NSUInteger imagesCount = (NSUInteger) fmodf(indexPath.row, 5);
    switch (imagesCount) {
        case 0: {
            estimatedHeight = 100;
            break;
        }
        case 1: {
            estimatedHeight = 250;
            break;
        }
        case 2: {
            estimatedHeight = 250;
            break;
        }
        case 3: {
            estimatedHeight = 400;
            break;
        }
        case 4: {
            estimatedHeight = 400;
            break;
        }
        default: {
            estimatedHeight = 100;
        }
    }
    return estimatedHeight;
}

@end
