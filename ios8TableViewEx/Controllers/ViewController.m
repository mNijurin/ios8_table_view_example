//
//  ViewController.m
//  test
//
//  Created by Maxim Nizhurin on 11/28/15.
//  Copyright © 2015 test. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "ViewController.h"
#import "ContentMessageCell.h"
#import "ContentMessageItem.h"
#import "MessagesProvider.h"
#import "MessageItemsConverter.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) NSMutableDictionary *cellsForSizing;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellsForSizing = [NSMutableDictionary new];
    NSMutableArray *array = [[[MessagesProvider new] getMessages] mutableCopy];
    self.items = [[MessageItemsConverter new] convertMessages:array];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseMessageItem *currentItem = self.items[(NSUInteger) indexPath.row];
    BaseMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:currentItem.reuseIdentifier];
    if (!cell) {
        cell = [currentItem createCellWithContainerWidth:MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [cell cellDidLoad];
    }
    [cell fillWithItem:currentItem];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseMessageItem *currentItem = self.items[(NSUInteger) indexPath.row];
    BaseMessageCell *currentCell = self.cellsForSizing[currentItem.reuseIdentifier];
    if (!currentCell) {
        currentCell = [currentItem createCellWithContainerWidth:MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [currentCell cellDidLoad];
        self.cellsForSizing[currentItem.reuseIdentifier] = currentCell;
    }
    [currentCell fillWithItem:currentItem];
    return [currentCell heightForWidth:self.tableView.frame.size.width];
}

@end
