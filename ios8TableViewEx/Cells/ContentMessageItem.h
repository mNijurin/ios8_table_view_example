//
// Created by Maxim Nizhurin on 12/8/15.
// Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMessageItem.h"

@class ContentMessageCell;
@class SPLMMessage;

@interface ContentMessageItem : BaseMessageItem

@property (nonatomic, assign) NSInteger imagesCount;

@property(nonatomic, copy) NSMutableString *messageText;
@property(nonatomic, copy) NSString *spacedMessageText;

@end