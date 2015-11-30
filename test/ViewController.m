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
    [self.tableView registerNib:[UINib nibWithNibName:@"MegaCell0" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell0"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MegaCell1" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell1"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MegaCell2" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell2"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MegaCell3" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell3"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MegaCell4" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell4"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cellForRow: %i", indexPath.row);
    NSNumber *imagesCount = @(fmodf(indexPath.row, 5));
    MegaCell *cell = (MegaCell *) [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell%@", imagesCount]];
//    MegaCell *cell = (MegaCell *) [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    cell.row = @(indexPath.row);

    NSString *url = @"https://placeimg.com/480/320/people/";
    NSString *resultUrl;

    for (int i = 0; i < cell.imageViews.count; i++) {
        resultUrl = [NSString stringWithFormat:@"%@%@", url, @(indexPath.row * 10 + i)];
        UIImageView *imageView = cell.imageViews[(NSUInteger) i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:resultUrl]];
    }

    return cell;
}


@end
