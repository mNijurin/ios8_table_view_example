//
//  KOChatEntryDelegate.h
//  Pods
//
//  Created by Kalys Osmonov on 7/13/14.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    koChatEntryTypeText = 1,
    koChatEntryTypePhoto = 2,
    koChatEntryTypeVideo = 3
} KOChatEntryType;

typedef enum {
    koMessageStatusSending = 1,
    koMessageStatusSuccessful = 2,
    koMessageStatusError = 3
} KOMessageStatus;

@protocol KOChatElementProtocol<NSObject>

@property (nonatomic, readonly) KOChatEntryType type;
@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) NSURL *thumbnailURL;
@property (nonatomic, readonly) NSURL *sourceURL;
@property (nonatomic, readonly) NSURL *videoThumbnailURL;
@property (nonatomic, readonly) NSString *udid;
@property (nonatomic, readonly) NSNumber *size;

@end
