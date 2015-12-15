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

@property (nonatomic, strong) NSMutableDictionary *cellsForSizing;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellsForSizing = [NSMutableDictionary new];
    self.items = [NSMutableArray new];
    for (int i = 0; i < 101; i ++) {
        [self.items addObject:[MegaItem itemWithImagesCount:(NSUInteger) fmodf(i, 5) index:i]];
//        [self.items addObject:[MegaItem itemWithImagesCount:4 index:i]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cellForRow: %i", indexPath.row);
    MegaItem *currentItem = self.items[(NSUInteger) indexPath.row];
    MegaCell *cell = [tableView dequeueReusableCellWithIdentifier:currentItem.reuseIdentifier];
    if (!cell) {
        cell = [currentItem createCellWithContainerWidth:MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [cell cellDidLoad];
    }
    [cell fillWithItem:currentItem];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MegaItem *currentItem = self.items[(NSUInteger) indexPath.row];
    MegaCell *currentCell = self.cellsForSizing[currentItem.reuseIdentifier];
    if (!currentCell) {
        currentCell = [currentItem createCellWithContainerWidth:MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [currentCell cellDidLoad];
        self.cellsForSizing[currentItem.reuseIdentifier] = currentCell;
    }
    [currentCell fillWithItem:currentItem];
    return [currentCell heightForWidth:self.tableView.frame.size.width];
}

@end
