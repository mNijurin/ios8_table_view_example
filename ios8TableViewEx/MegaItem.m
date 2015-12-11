//
// Created by Maxim Nizhurin on 12/8/15.
// Copyright (c) 2015 test. All rights reserved.
//

#import "MegaItem.h"
#import "MegaCell.h"


@implementation MegaItem

+ (instancetype)itemWithImagesCount:(int)imagesCount index:(NSInteger)index {
    MegaItem *item = [MegaItem new];

    NSMutableArray *mutableUrls = [NSMutableArray new];
    NSString *url = @"https://placeimg.com/480/320/people/";
    for (int i = 0; i < imagesCount; i++) {
        [mutableUrls addObject:[NSString stringWithFormat:@"%@%@", url, @(index * 10 + i)]];
    }
    item.urls = mutableUrls;

    item.imagesCount = imagesCount;
    if (imagesCount == 0) {
        NSMutableAttributedString *attributedString = [NSMutableAttributedString new];
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = [UIImage imageNamed:@"activities_reply"];
        [attributedString appendAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachment]];

        NSAttributedString *firstString = [[NSAttributedString alloc] initWithString:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed "];
        [attributedString appendAttributedString:firstString];

        NSMutableAttributedString *secondString = [[NSMutableAttributedString alloc] initWithString:@"do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco"];
        [secondString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:14] range:NSMakeRange(0, secondString.string.length)];
        [attributedString appendAttributedString:secondString];

        NSMutableAttributedString *thirdString = [[NSMutableAttributedString alloc] initWithString:@" laboris nisi ut aliquip ex ea commodo consequat."];
        [attributedString appendAttributedString:thirdString];

        item.attributedText = attributedString;
    } else if (imagesCount == 1) {
        item.attributedText = [[NSAttributedString alloc] initWithString:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."];
    } else if (imagesCount == 2) {
        NSMutableAttributedString *attributedString = [NSMutableAttributedString new];
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = [UIImage imageNamed:@"activities_unban"];
        [attributedString appendAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachment]];

        NSMutableAttributedString *firstString = [[NSMutableAttributedString alloc] initWithString:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed "];
        [firstString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:14] range:NSMakeRange(0, firstString.string.length)];
        [attributedString appendAttributedString:firstString];

        NSMutableAttributedString *secondString = [[NSMutableAttributedString alloc] initWithString:@"do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco"];
        [attributedString appendAttributedString:secondString];

        NSMutableAttributedString *thirdString = [[NSMutableAttributedString alloc] initWithString:@" laboris nisi ut aliquip ex ea commodo consequat."];
        [attributedString appendAttributedString:thirdString];

        item.attributedText = attributedString;
    } else if (imagesCount == 3) {
        NSMutableAttributedString *attributedString = [NSMutableAttributedString new];

        NSMutableAttributedString *firstString = [[NSMutableAttributedString alloc] initWithString:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed "];
        [attributedString appendAttributedString:firstString];

        NSMutableAttributedString *secondString = [[NSMutableAttributedString alloc] initWithString:@"do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco"];
        [attributedString appendAttributedString:secondString];

        NSMutableAttributedString *thirdString = [[NSMutableAttributedString alloc] initWithString:@" laboris nisi ut aliquip ex ea commodo consequat."];
        [thirdString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:14] range:NSMakeRange(0, thirdString.string.length)];
        [attributedString appendAttributedString:thirdString];

        item.attributedText = attributedString;
    } else if (imagesCount == 4) {
        NSMutableAttributedString *attributedString = [NSMutableAttributedString new];
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = [UIImage imageNamed:@"activities_unlock"];
        [attributedString appendAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachment]];

        NSMutableAttributedString *firstString = [[NSMutableAttributedString alloc] initWithString:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed "];
        [attributedString appendAttributedString:firstString];

        NSMutableAttributedString *secondString = [[NSMutableAttributedString alloc] initWithString:@"do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco"];
        [attributedString appendAttributedString:secondString];

        NSMutableAttributedString *thirdString = [[NSMutableAttributedString alloc] initWithString:@" laboris nisi ut aliquip ex ea commodo consequat."];
        [attributedString appendAttributedString:thirdString];

        item.attributedText = attributedString;
    }
    return item;
}

- (NSString *)reuseIdentifier {
    return [NSString stringWithFormat:@"cell%u", self.imagesCount];
}

- (MegaCell *)createCell {
    return [MegaCell cellWithImagesCount:(NSUInteger) self.imagesCount];
}

@end