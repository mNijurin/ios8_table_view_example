//
//  GRVNotificationMessageModel.h
//  GroupChat
//
//  Created by kanybek on 10/14/15.
//  Copyright (c) 2015 Grouvi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRVBanModel.h"
#import "GRVEventMessageModel.h"

typedef NS_ENUM(NSUInteger, GRVActivityType) {
    GRVActivityTypeBanned = 1 << 0,
    GRVActivityTypeUserBanned = 1 << 1,
    GRVActivityTypeUnbanned = 1 << 2,
    GRVActivityTypeMessageReplied = 1 << 3,
    GRVActivityTypeGroupDeleted = 1 << 4,
    GRVActivityTypeMembershipRequestCreated = 1 << 5,
    GRVActivityTypeMembershipRequestCancelled = 1 << 6,
    GRVActivityTypeMembershipRequestAccepted = 1 << 7,
    GRVActivityTypeMembershipRequestRejected = 1 << 8,

    GRVActivityTypeGroupChanged = 1 << 9,

    GRVActivityTypeMembershipRequestSent = 1 << 10,
    GRVActivityTypeWeekAfterUserRegistered = 1 << 11,
    GRVActivityTypeSecondMemberJoined = 1 << 12,
    GRVActivityTypeDayAfterGroupCreated = 1 << 13,
    GRVActivityTypeGeneral = 1 << 14
};

@interface GRVNotificationMessageModel : NSObject

#pragma mark JSON fields

@property (nonatomic, strong, readonly) NSNumber *membershipId;
@property (nonatomic, strong, readonly) NSNumber *groupId;
@property (nonatomic, copy, readwrite) NSString *icon;
@property(nonatomic, strong, readonly) NSNumber *replyMessageSerial;

#pragma mark used in app

@property (nonatomic, copy, readonly) NSString *activityTitle;
@property (nonatomic, copy, readonly) NSAttributedString *activityText;
@property (nonatomic, strong) NSMutableAttributedString* activityPresentationText;
@property (nonatomic, copy, readonly) NSString *activityShortText;

@property(nonatomic, assign, readonly) BOOL hasRoute;

@property(nonatomic, assign, readonly) GRVActivityType enumActivityType;
@property(nonatomic, assign, readonly) GRVBanType enumBanType;
@property(nonatomic, assign, readonly) GRVUnbannedBy enumUnbannedBy;
@property(nonatomic, assign, readonly) GRVGroupChangedType enumGroupChangedType;

+ (instancetype)buildModelWithDictionary:(NSDictionary *)dictionary;


@end
