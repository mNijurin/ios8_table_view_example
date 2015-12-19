//
// Created by Maxim Nizhurin on 12/19/15.
// Copyright (c) 2015 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SPLMMessage;
@class BaseMessageCell;

@interface BaseMessageItem : NSObject

@property (nonatomic, strong) NSString *reuseIdentifier;
@property (nonatomic, strong) SPLMMessage *message;

- (BaseMessageCell *)createCellWithContainerWidth:(CGFloat)containerWidth;

@end