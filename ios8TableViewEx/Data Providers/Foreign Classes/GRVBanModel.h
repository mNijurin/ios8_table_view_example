//
//  GRVBanModel.h
//  GroupChat
//
//  Created by kanybek on 10/1/15.
//  Copyright (c) 2015 Grouvi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@class GRVUserModel;

/*
ban =     {
    "banned_at" = "2015-10-01T05:55:54.031Z";
    type = "admin_banned";
    "unban_at" = "2015-10-08T05:55:54.030Z";
}*/

//type = "admin_banned ";
//       "spam_banned "

typedef enum : NSUInteger {
    GRVBanTypeSpamBanned,
    GRVBanTypeAdminBanned
} GRVBanType;

typedef NS_ENUM(NSUInteger, GRVUnbannedBy) {
    GRVUnbannedByAdmin,
    GRVUnbannedBySystem
};

@interface GRVBanModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong, readonly) NSDate *bannedAt;
@property (nonatomic, strong, readonly) NSDate *unbanAt;
@property (nonatomic, strong, readonly) NSNumber *banType;
@property (nonatomic, strong, readonly) NSNumber *banDuration;

@property (nonatomic, copy, readonly) NSString *banText;

//not stored fields
@property (nonatomic, assign, readonly) GRVBanType enumBanType;
@property (nonatomic, strong) GRVUserModel *user;

@end
