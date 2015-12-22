//
// Created by Maxim Nizhurin on 12/8/15.
// Copyright (c) 2015 test. All rights reserved.
//

#import "MTLModel.h"
#import "ContentMessageItem.h"
#import "ContentMessageCell.h"
#import "KOChatEntryElement.h"
#import "SPLMMessage.h"

@implementation ContentMessageItem

//possible values: cell0, cell1, cell2, cell3, cell4
- (NSString *)reuseIdentifier {
    return [NSString stringWithFormat:@"cell%u", self.imagesCount];
}

- (ContentMessageCell *)createCellWithContainerWidth:(CGFloat)containerWidth {
    return [[ContentMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.reuseIdentifier containerWidth:containerWidth imagesCount:(NSUInteger) self.imagesCount];
}

- (NSMutableString *)messageText {
    if (!_messageText) {
        _messageText = [NSMutableString new];
        for (KOChatEntryElement *element in self.message.contentArray) {
            if (element.type == koChatEntryTypeText) {
                if ([_messageText isEqualToString:@""]) {
                    [_messageText appendString:element.text];
                } else {
                    [_messageText appendString:[NSString stringWithFormat:@"\n%@", element.text]];
                }
            }
        }
    }
    return _messageText;
}

- (NSString *)spacedMessageText {
    if (!_spacedMessageText && self.messageText.length > 0) {
        NSUInteger initialLength = self.messageText.length;
        NSUInteger additionalLength = self.message.creationTimeString.length + (NSUInteger) ceilf(self.message.creationTimeString.length * .8f);
        NSUInteger resultLength = initialLength + additionalLength;
        NSString *stringWithNbspInserted = [self.messageText stringByPaddingToLength:resultLength withString:@"\u00a0" startingAtIndex:0];
        _spacedMessageText = [NSString stringWithFormat:@"%@\u200c", stringWithNbspInserted];
    }
    return _spacedMessageText;
}

@end