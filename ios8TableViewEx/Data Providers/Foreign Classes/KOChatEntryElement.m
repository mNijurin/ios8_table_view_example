//
//  KOChatEntryElement.m
//  Pods
//
//  Created by Kalys Osmonov on 8/7/14.
//
//

#import "KOChatEntryElement.h"

@implementation KOChatEntryElement

+ (instancetype)elementWithText:(NSString *)text {
    KOChatEntryElement *element = [KOChatEntryElement new];
    if (element) {
        element.type = koChatEntryTypeText;
        element.text = text;
    }
    return element;
}

- (NSString *)sizeString {
    return [NSByteCountFormatter stringFromByteCount:[self.size longLongValue] countStyle:NSByteCountFormatterCountStyleFile];
}

/**
 *  See .h file for description.
 */
- (void)refreshLocalURLs {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [@"file://" stringByAppendingString:paths[0]];

    if ([[self.thumbnailURL scheme] isEqualToString:@"file"]) {
        NSString *lastPathComponent = [self.thumbnailURL lastPathComponent];
        self.thumbnailURL = [NSURL URLWithString:[cacheDirectory stringByAppendingPathComponent:lastPathComponent]];
    }

    if ([[self.sourceURL scheme] isEqualToString:@"file"]) {
        NSString *lastPathComponent = [self.sourceURL lastPathComponent];
        self.sourceURL = [NSURL URLWithString:[cacheDirectory stringByAppendingPathComponent:lastPathComponent]];
    }
}

@end
