//
//  GRVUserModel.h
//  GroupChat
//
//  Created by kanybek on 8/7/15.
//  Copyright (c) 2015 Grouvi. All rights reserved.
//

#import <Foundation/Foundation.h>
/*user =         {
    avatar = "https://scontent.xx.fbcdn.net/hprofile-ash2/l/t31.0-1/c214.72.897.897/1149307_10201728343995303_1117475398_o.jpg";
    "avatar_thumb" = "https://scontent.xx.fbcdn.net/hprofile-ash2/v/l/t1.0-1/c155.52.650.650/s100x100/1098240_10201728343995303_1117475398_n.jpg?oh=d86c24527328f2ba6a83a968340b95e1&oe=56C1B517";
    "created_at" = "2015-11-05T08:14:00.305Z";
    id = 8;
    "messages_count" = 2;
    muted = 0;
    online = 0;
    "others_bookmarks_count" = 0;
    "others_likes_count" = 0;
    "others_spam_reports_count" = 0;
    "push_notification_sound" = "<null>";
    "updated_at" = "2015-11-05T08:14:00.305Z";
    username = "\U042d\U0441\U0435\U043d\U0431\U0435\U043a \U041a\U044b\U0434\U044b\U0440 \U0443\U0443\U043b\U0443";
}*/

@interface GRVUserModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong, readonly) NSNumber *userId;
@property (nonatomic, copy,   readwrite) NSString *userName;
@property (nonatomic, copy, readwrite) NSString *avatarUrl;
@property (nonatomic, copy, readwrite) NSString *avatarThumbUrl;
@property (nonatomic, strong, readonly) NSNumber *messagesCount;
@property (nonatomic, strong, readonly) NSNumber *reverseBookmarksCount;
@property (nonatomic, strong, readonly) NSNumber *likesCount;
@property (nonatomic, strong, readonly) NSNumber *spamCount;
@property (nonatomic, strong, readonly) NSNumber *isOnline;
@property (nonatomic, copy,   readonly) NSString *pushNotificationSound;
@property (nonatomic, strong, readonly) NSNumber *isMuted;
@property (nonatomic, strong, readonly) NSDate *createdAt;
@property (nonatomic, strong, readonly) NSDate *updatedAt;

//not stored in db
@property (nonatomic, copy, readonly) NSString *creationDateText;

- (NSDictionary *)parametersForRequest;
@end
