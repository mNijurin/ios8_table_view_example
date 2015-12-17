//
// Created by Adilet Abylov on 1/17/15.
// Copyright (c) 2015 Adilet Abylov. All rights reserved.
//

#import "SPLMMessageHelper.h"
#import "KOChatEntryElement.h"
#import "AppDelegate.h"


@implementation SPLMMessageHelper {
}
- (NSString *)inAppNotififcationTextWithMessageElements:(NSArray *)elements sendername:(NSString *)sendername {
    NSString *textElementNotification = [self textElementNotificationFromContent:elements];
    if (!textElementNotification) {
        return [NSString stringWithFormat:@"%@: %@", sendername, @"sent media."];
    }
    return [NSString stringWithFormat:@"%@: %@", sendername, textElementNotification];
}

- (NSString *)textElementNotificationFromContent:(NSArray *)elements {
    __block NSString *notification;
    const int kPushNotificationLength = 200;
    [elements enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        KOChatEntryElement *element = (KOChatEntryElement *) obj;
        if (element.type == koChatEntryTypeText)
        {
            NSRange range = NSMakeRange(0, element.text.length < kPushNotificationLength ? element.text.length : kPushNotificationLength);
            notification = [element.text substringWithRange:range];
            *stop = YES;
        }
    }];
    return notification;
}

- (NSString *)apnNotificationTextWithMessageElements:(NSArray *)elements groupName:(NSString *)groupName {
    NSString *textElementNotification = [self textElementNotificationFromContent:elements];
    if (!textElementNotification) {
        return [NSString stringWithFormat:@"%@: %@", groupName, @"sent media."];
    }
    return [NSString stringWithFormat:@"%@: %@", groupName, textElementNotification];
}

-(NSString *)messageDescription:(NSString *)jsonString {
    NSArray* elements = [self textElementsFromJSONString:jsonString];
    KOChatEntryElement* lastElement = [elements lastObject];
    if (lastElement.type == koChatEntryTypeText) {
        return lastElement.text;
    } else if (lastElement) {
        return @"sent media";
    }
    return nil;
}


- (NSArray *)textElementsFromJSONString:(NSString *)jsonString {
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    if (!data) {
        return nil;
    }

    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    /*(
     {
         height = 750;
         size = 147856;
         "thumb_url" = "http://cdn.grouvi.org/uploads/fa6dd727-ddd9-4737-bea6-a68e9ebd575c/c8bcc608-6891-4326-b86c-3a5beb82ff6b.jpg";
         type = image;
         url = "http://cdn.grouvi.org/uploads/bab51c83-373b-4d0a-8d74-23c82e4a6b3c/d90a61eb-4e69-45de-99db-69bbc8e1e27d.jpg";
         width = 1000;
     }
     )*/
    
    if (error) {
        DLog(@"textElementsFromJSONString error %@", error);
        return nil;
    }
    NSMutableArray *newArray = [NSMutableArray new];
    for (NSDictionary *elementDict in jsonArray) {
        KOChatEntryElement *element = [KOChatEntryElement new];
        NSString *type = elementDict[@"type"];
        if ([type isEqualToString:@"text"]) {
            element.type = koChatEntryTypeText;
            element.text = elementDict[@"text"];
        } else if ([type isEqualToString:@"image"]) {
            element.type = koChatEntryTypePhoto;
            if (elementDict[@"thumb_url"] && elementDict[@"thumb_url"] != [NSNull null]) {
                element.thumbnailURL = [NSURL URLWithString:elementDict[@"thumb_url"]];
            }
            if (elementDict[@"url"] && elementDict[@"url"] != [NSNull null]) {
                element.sourceURL = [NSURL URLWithString:elementDict[@"url"]];
            }
            element.mediaSize = CGSizeMake([elementDict[@"width"] floatValue], [elementDict[@"height"] floatValue]);

        } else if ([type isEqualToString:@"video"]) {
            element.type = koChatEntryTypeVideo;
            if (elementDict[@"thumb_url"] && elementDict[@"thumb_url"] != [NSNull null]) {
                element.thumbnailURL = [NSURL URLWithString:elementDict[@"thumb_url"]];
            }
            if (elementDict[@"url"] && elementDict[@"url"] != [NSNull null]) {
                element.sourceURL = [NSURL URLWithString:elementDict[@"url"]];
            }
            element.size = elementDict[@"size"];
            element.mediaSize = CGSizeMake([elementDict[@"width"] floatValue], [elementDict[@"height"] floatValue]);
        }
        [newArray addObject:element];
    }
    return [[NSArray alloc] initWithArray:newArray];
}

- (NSString *)processText:(NSString *)text {
    NSString *newString = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray *components = [newString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    components = [components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self <> ''"]];
    NSString *cleanedString = [components componentsJoinedByString:@" "];
    //components = [cleanedString componentsSeparatedByString:@"\n"];
    //components = [components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self <> ''"]];
    //cleanedString = [components componentsJoinedByString:@"\n"];
    return cleanedString;
}
@end