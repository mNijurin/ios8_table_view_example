//
//  GRVEventMessageModel.h
//  GroupChat
//
//  Created by kanybek on 10/14/15.
//  Copyright (c) 2015 Grouvi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRVBanModel.h"

/*
data =     {
    name = "group_picture_changed";
};*/

/*
user_joined/user_left
system_banned
admin_banned
system_unbanned
admin_unbanned
group_title_changed
group_picture_changed
group_description_changed
group_status_changed (private/public)
*/

/*{
    "name": "user_joined",
    "username": "User Name”,
    "banned_at" = "2015-10-14T05:53:27.025Z”,
    "unban_at" = "<null>”,
    "new_title": "Sample New Title”,
    "is_private": true
}*/
    
typedef enum : NSUInteger {
    GRVEventTypeGroupCreated = 1 << 0,
    GRVEventTypeGroupDeleted = 1 << 1,
    GRVEventTypeGroupChanged = 1 << 2,
    GRVEventTypeUserJoined = 1 << 3,
    GRVEventTypeUserLeft = 1 << 4,
    GRVEventTypeUserBanned = 1 << 5,
    GRVEventTypeUserUnbanned = 1 << 6,
} GRVEventType;

typedef enum : NSUInteger {
    GRVGroupChangedTypeTitle,
    GRVGroupChangedTypePicture,
    GRVGroupChangedTypeDescription,
    GRVGroupChangedTypeStatus,
} GRVGroupChangedType;

@interface GRVEventMessageModel : NSObject
@property (nonatomic, copy, readonly)   NSString *userName;
@property (nonatomic, copy, readonly)   NSString *nGroupTitle;
@property (nonatomic, strong, readonly) NSDate *bannedAt;
@property (nonatomic, strong, readonly) NSDate *unbanAt;
@property (nonatomic, strong, readonly) NSNumber *isPrivate;

@property (nonatomic, assign, readonly) GRVEventType enumEventType;
@property (nonatomic, assign, readonly) GRVBanType enumBanType;
@property (nonatomic, assign, readonly) GRVUnbannedBy enumUnbannedBy;
@property (nonatomic, assign, readonly) GRVGroupChangedType enumGroupChangedType;

+ (instancetype)buildModelWithDictionary:(NSDictionary *)dictionary;

+ (NSNumber *)translateGroupChangedType:(NSString *)stringBanType;

- (NSString *) eventMessage;

@end
