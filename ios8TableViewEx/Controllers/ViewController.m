//
//  ViewController.m
//  test
//
//  Created by Maxim Nizhurin on 11/28/15.
//  Copyright © 2015 test. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "ViewController.h"
#import "ContentIncomingMessageCell.h"
#import "ContentMessageItem.h"
#import "MessagesProvider.h"
#import "MessageItemsConverter.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) NSMutableDictionary *cellsForSizing;
@property (nonatomic, strong) NSMutableDictionary *heightsCache;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellsForSizing = [NSMutableDictionary new];
    self.heightsCache = [NSMutableDictionary new];
    NSMutableArray *array = [[[MessagesProvider new] getMessages] mutableCopy];
    self.items = [[MessageItemsConverter new] convertMessages:array];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"cell for row: %i", indexPath.row);
    BaseMessageItem *currentItem = self.items[(NSUInteger) indexPath.row];
    
    //NSLog(@"currentItem.message.userId = %@",currentItem.message.userId);
    //NSLog(@"currentItem.message.userName = %@",currentItem.message.userName);
    
    BaseMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:currentItem.reuseIdentifier];
    if (!cell) {
        cell = [currentItem createCellWithContainerWidth:MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [cell cellDidLoad];
    }
    [cell fillWithItem:currentItem];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"height for row: %i", indexPath.row);
    BaseMessageItem *currentItem = self.items[(NSUInteger) indexPath.row];
    if (self.heightsCache[[NSString stringWithFormat:@"%u", currentItem.hash]]) {
//        NSLog(@"height from cache for row: %i", indexPath.row);
        return [self.heightsCache[[NSString stringWithFormat:@"%u", currentItem.hash]] floatValue];
    } else {
//        NSLog(@"height calc for row: %i", indexPath.row);
        BaseMessageCell *currentCell = self.cellsForSizing[currentItem.reuseIdentifier];
        if (!currentCell) {
            currentCell = [currentItem createCellWithContainerWidth:MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            [currentCell cellDidLoad];
            self.cellsForSizing[currentItem.reuseIdentifier] = currentCell;
        }
        [currentCell fillWithItem:currentItem];
        CGFloat height = [currentCell calculateHeight];
        self.heightsCache[[NSString stringWithFormat:@"%u", currentItem.hash]] = @(height);
        return height;
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    self.heightsCache = [NSMutableDictionary new];
    [coordinator animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext> context) {
        [self.tableView reloadData];
    } completion:^(id <UIViewControllerTransitionCoordinatorContext> context) {

    }];
}

@end
