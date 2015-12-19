//
// Created by Maxim Nizhurin on 12/16/15.
// Copyright (c) 2015 test. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import "MessageItemsConverter.h"
#import "SPLMMessage.h"
#import "KOChatEntryElement.h"
#import "ContentMessageItem.h"
#import "EventMessageItem.h"


@implementation MessageItemsConverter

- (NSMutableArray *)convertMessages:(NSArray *)messages {
    NSMutableArray *items = [NSMutableArray new];
    for (SPLMMessage *message in messages) {
        if (message.enumMessageType == GRVMessageTypeContent) {
            ContentMessageItem *item = [ContentMessageItem new];
            for (KOChatEntryElement *element in message.contentArray) {
                if (element.type == koChatEntryTypePhoto || element.type == koChatEntryTypeVideo) {
                    item.imagesCount ++;
                }
            }
            item.message = message;
            [items addObject:item];
        } else if (message.enumMessageType == GRVMessageTypeEvent) {
            EventMessageItem *item = [EventMessageItem new];
            item.message = message;
            [items addObject:item];
        }
    }
    return items;
}

@end