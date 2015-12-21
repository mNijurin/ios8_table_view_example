//
// Created by Adilet Abylov on 2/25/14.
// Copyright (c) 2014 Adilet Abylov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

#import "KOChatEntryDelegate.h"

/*(
 {
     data =         {
         "channel_id" = 5228;
         "created_at" = "2015-11-24T12:44:36.242Z";
         data =             {
             attribute = title;
             channel =                 {
                 "created_at" = "2015-11-24 12:25:01 UTC";
                 description = "";
                 id = 5229;
                 "is_deleted" = 0;
                 "is_private" = 1;
                 "media_count" = 0;
                 "members_count" = 1;
                 picture = "<null>";
                 "picture_thumb" = "<null>";
                 "tapstream_url" = "http://grou.vi/seek";
                 title = "rrrrrr wertwter dfgfdgdfg ertet ret dfg dfg dfg";
                 type = Group;
                 "updated_at" = "2015-11-24 12:44:36 UTC";
             };
             name = "channel_changed";
             "old_value" = "rrrrrr wertwter dfgfdgdfg ertet ret dfg dfg";
         };
         id = 459763;
         serial = 3;
         status = new;
         type = NotificationMessage;
         "updated_at" = "2015-11-24T12:44:36.242Z";
         uuid = "00fc392f-f1c1-446a-b21f-2fd38a891fdd";
     };
     type = "message_received";
 }
 )*/

@class MHGalleryItem;

@class SPLMUploadFileItem;
@class SPLMUploadMediaItem;
@class GRVEventMessageModel;
@class GRVNotificationMessageModel;
@class GRVUserModel;

typedef NS_ENUM(NSInteger, MessageType) {
    GRVMessageTypeContent,
    GRVMessageTypeEvent,
    GRVMessageTypeNotification
};

@interface SPLMMessage : MTLModel<MTLJSONSerializing>

#pragma mark json fields
@property (nonatomic) NSString *text;
@property (nonatomic) NSNumber *messageId;
@property (nonatomic) NSNumber *userId;
@property (nonatomic) NSNumber *groupId;
@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *userAvatarThumbUrl;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic) NSNumber *blocked;
@property (nonatomic) NSNumber *wasRemoved;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSNumber *serialNumber;
@property (nonatomic, strong) NSNumber *inReplyToId;//to be changed to original message
@property (nonatomic, strong) NSNumber *messageType;

@property (nonatomic, readwrite) NSSet *bookmarkedBy;
@property (nonatomic, strong) NSSet *likedBy;
@property (nonatomic, strong) NSSet *spamReportedBy;

@property (nonatomic, strong) SPLMMessage *repliedMessage;

#pragma mark used in app
@property (nonatomic, strong) NSNumber *sendingStatus;
//need to preserve on update from server
@property (nonatomic) NSNumber *read;

@property (nonatomic, strong, readonly) NSNumber *liked;
@property (nonatomic, strong, readonly) NSNumber *saved;
@property (nonatomic, strong, readonly) NSNumber *spammed;

#pragma mark not stored in DB
@property (nonatomic, copy) NSArray *contentArray;
@property (nonatomic, readwrite) GRVEventMessageModel *event;
@property (nonatomic, readwrite) GRVNotificationMessageModel *notification;

@property (nonatomic, assign) MessageType enumMessageType;

#pragma mark unknown fields
@property NSString *media;
@property NSString *thumbnail;
@property NSArray *elements;

#pragma mark - Presentation
@property (nonatomic, copy) NSString* timeStringForActivity;
@property (nonatomic, copy) NSString* timeStringForGroupsPage;
@property (nonatomic, copy) NSString *creationTimeString;
@property (nonatomic, copy) NSString *creationDateString;
@property (nonatomic, copy) NSString* shortUsername;

- (NSString*) shortMessagePreview;


- (id)initMessageWithText:(NSString *)text sender:(GRVUserModel *)sender groupId:(NSNumber *)groupId status:(KOMessageStatus)messageStatus;

- (BOOL)isEqualToMessage:(SPLMMessage *)message;

- (NSString *)contentToString;

/**
*  Checks if message is spammed or reported
*
*  @return Boolean value
*/
- (BOOL)isSpammedAndReported;

- (BOOL)isBlocked;

- (BOOL)isDeleted;

- (BOOL)isRead;

/**
*  Restores element by text
*/
- (void)restoreElements;

/**
*  Checks if all its media files exist on file system
*
*  @return
*/
- (BOOL)hasMissingCachedMedia;

- (NSInteger)likesCount;

/**
*  Return NSURL instance to user avatar
*
*  @return
*/
- (NSURL *)avatarURL;

- (NSString *)dateString;

- (BOOL)isSaved;

- (BOOL)isLiked;

- (BOOL)isSpammed;

- (NSInteger)spamsCount;

/**
 *  Set ids for media elements
 */
- (void)setPermanentIDsForMediaElements;




@end