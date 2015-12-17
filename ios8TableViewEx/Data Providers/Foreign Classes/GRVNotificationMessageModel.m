//
//  GRVNotificationMessageModel.m
//  GroupChat
//
//  Created by kanybek on 10/14/15.
//  Copyright (c) 2015 Grouvi. All rights reserved.
//

#import "SPLMDateTimeFormatterHelper.h"
#import "GRVNotificationMessageModel.h"
#import "GRVEventMessageModel.h"
#import "AppDelegate.h"
#import "GRVBanModel.h"

@interface GRVNotificationMessageModel ()

@property (nonatomic, strong) NSNumber *membershipId;
@property (nonatomic, strong) NSNumber *groupId;
@property (nonatomic, strong) NSNumber *activityType;
@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *shortText;
@property (nonatomic, strong) NSDate *banExpiryDate;
@property (nonatomic, strong) NSNumber *banType;
@property (nonatomic, strong) NSNumber *unbannedBy;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, strong) NSNumber *isPrivate;
@property (nonatomic, copy) NSString *oldGroupName;
@property (nonatomic, strong) NSNumber *replyMessageSerial;
@property (nonatomic, strong) NSNumber *groupChangedType;

@property (nonatomic, copy) NSString *activityTitle;
@property (nonatomic, copy) NSAttributedString *activityText;
@property (nonatomic, copy) NSString *activityShortText;

@property(nonatomic, assign) BOOL hasRoute;

@end

@implementation GRVNotificationMessageModel

+ (instancetype)buildModelWithDictionary:(NSDictionary *)dictionary {
    GRVNotificationMessageModel *notification = [GRVNotificationMessageModel new];
    notification.activityType = [GRVNotificationMessageModel translateActivityType:dictionary[@"name"]];

    if (notification.enumActivityType & (GRVActivityTypeMembershipRequestCancelled |
            GRVActivityTypeMembershipRequestCreated |
            GRVActivityTypeMembershipRequestSent |
            GRVActivityTypeMembershipRequestRejected)) {
        [[self class] parseGroup:dictionary[@"membership_request"][@"channel"] inToNotification:notification];
        [[self class] parseUser:dictionary[@"membership_request"][@"user"] inToNotification:notification];
    }
    if (notification.enumActivityType == GRVActivityTypeMembershipRequestAccepted) {
        NSDictionary *membership = dictionary[@"membership"];
        [[self class] parseGroup:membership[@"channel"] inToNotification:notification];
        notification.membershipId = membership[@"id"];
    }
    if (notification.enumActivityType & (GRVActivityTypeSecondMemberJoined | GRVActivityTypeDayAfterGroupCreated | GRVActivityTypeGroupDeleted)) {
        [self parseGroup:dictionary[@"channel"] inToNotification:notification];
    }
    if (notification.enumActivityType == GRVActivityTypeGroupChanged) {
        notification.groupChangedType = [GRVEventMessageModel translateGroupChangedType:dictionary[@"attribute"]];
        if (notification.enumGroupChangedType == GRVGroupChangedTypeTitle) {
            notification.oldGroupName = dictionary[@"old_value"];
        }
        [self parseGroup:dictionary[@"channel"] inToNotification:notification];
    }
    if (notification.enumActivityType & (GRVActivityTypeBanned | GRVActivityTypeUserBanned | GRVActivityTypeUnbanned)) {
        [self parseBan:dictionary[@"ban"] inToNotification:notification];
        [self parseGroup:dictionary[@"ban"][@"channel"] inToNotification:notification];
        [self parseUser:dictionary[@"user"] inToNotification:notification];
        if (notification.enumActivityType == GRVActivityTypeUnbanned && !IS_NULL(dictionary[@"unbanned_by"])) {
            notification.unbannedBy = [self translateUnbannedBy:dictionary[@"unbanned_by"]];
        } else if (notification.enumActivityType == GRVActivityTypeUnbanned && IS_NULL(dictionary[@"unbanned_by"])) {
            DLog(@"========================================== pizdec  pizdec  sluchilos in notification message unbanned by == null ==========================================");
        }
    }
    if (notification.enumActivityType == GRVActivityTypeMessageReplied) {
        [self parseGroup:dictionary[@"channel"] inToNotification:notification];
        [self parseUser:dictionary[@"reply"][@"user"] inToNotification:notification];
        notification.replyMessageSerial = dictionary[@"reply"][@"serial"];
    }
    if (notification.enumActivityType == GRVActivityTypeGeneral) {
        notification.icon = dictionary[@"icon"];
        notification.text = dictionary[@"text"];
        notification.shortText = dictionary[@"short_text"];
    }
    [notification fillActivityText];
    return notification;
}

+ (void)parseBan:(NSDictionary *)ban inToNotification:(GRVNotificationMessageModel *)notification {
    if (!IS_NULL(ban[@"unban_at"])) {
        notification.banExpiryDate = [[GRVNotificationMessageModel dateFormatter] dateFromString:ban[@"unban_at"]];
    }
    notification.banType = [self translateBanType:ban[@"ban_type"]];
}

+ (void)parseGroup:(NSDictionary *)group inToNotification:(GRVNotificationMessageModel *)notification {
    notification.groupId = group[@"id"];
    notification.groupName =  group[@"title"];
    notification.icon = group[@"picture_thumb"];
    notification.isPrivate = group[@"is_private"];
}

+ (void)parseUser:(NSDictionary *)user inToNotification:(GRVNotificationMessageModel *)notification {
    notification.userName = user[@"username"];
}

+ (NSNumber *)translateActivityType:(NSString *)stringActivityType {
    if ([stringActivityType isEqualToString:@"banned"])                     {return @(GRVActivityTypeBanned);}//sent to user, has two ban types (system, admin) serve to ban user
    if ([stringActivityType isEqualToString:@"user_banned"])                {return @(GRVActivityTypeUserBanned);}//sent to admin, has one type serve to notify admin
    if ([stringActivityType isEqualToString:@"unbanned"])                   {return @(GRVActivityTypeUnbanned);}
    if ([stringActivityType isEqualToString:@"message_replied"])            {return @(GRVActivityTypeMessageReplied);}//
    if ([stringActivityType isEqualToString:@"channel_deleted"])            {return @(GRVActivityTypeGroupDeleted);}//
    if ([stringActivityType isEqualToString:@"membership_request_created"]) {return @(GRVActivityTypeMembershipRequestCreated);}//
    if ([stringActivityType isEqualToString:@"membership_request_cancelled"]) {return @(GRVActivityTypeMembershipRequestCancelled);}//
    if ([stringActivityType isEqualToString:@"membership_request_accepted"]){return @(GRVActivityTypeMembershipRequestAccepted);}//
    if ([stringActivityType isEqualToString:@"membership_request_rejected"]){return @(GRVActivityTypeMembershipRequestRejected);}//
    if ([stringActivityType isEqualToString:@"channel_changed"])            {return @(GRVActivityTypeGroupChanged);}//
    if ([stringActivityType isEqualToString:@"membership_request_sent"])    {return @(GRVActivityTypeMembershipRequestSent);}//
    if ([stringActivityType isEqualToString:@"week_after_user_registered"]) {return @(GRVActivityTypeWeekAfterUserRegistered);}
    if ([stringActivityType isEqualToString:@"second_member_joined"])       {return @(GRVActivityTypeSecondMemberJoined);}//
    if ([stringActivityType isEqualToString:@"day_after_group_created"])    {return @(GRVActivityTypeDayAfterGroupCreated);}//
    if ([stringActivityType isEqualToString:@"general"])                    {return @(GRVActivityTypeGeneral);}
    return @(GRVActivityTypeGeneral);
}

+ (NSNumber *)translateBanType:(NSString *)stringBanType {
    if ([stringBanType isEqualToString:@"spam_banned"]) {return @(GRVBanTypeSpamBanned);}
    if ([stringBanType isEqualToString:@"admin_banned"]) {return @(GRVBanTypeAdminBanned);}
    return @(GRVBanTypeSpamBanned);
}

+ (NSNumber *)translateUnbannedBy:(NSString *)stringUnbannedBy {
    if ([stringUnbannedBy isEqualToString:@"admin"]) {return @(GRVUnbannedByAdmin);}
    if ([stringUnbannedBy isEqualToString:@"system"]) {return @(GRVUnbannedBySystem);}
    return @(GRVUnbannedBySystem);
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    return dateFormatter;
}

#pragma mark -
#pragma mark - public method

- (GRVActivityType)enumActivityType {
    return (GRVActivityType)self.activityType.unsignedIntegerValue;
}

- (GRVBanType)enumBanType {
    return (GRVBanType) self.banType.unsignedIntegerValue;
}

- (GRVUnbannedBy)enumUnbannedBy {
    return (GRVUnbannedBy) self.unbannedBy.unsignedIntegerValue;
}

- (GRVGroupChangedType)enumGroupChangedType {
    return (GRVGroupChangedType) self.groupChangedType.unsignedIntegerValue;
}

- (NSString *)activityTitle {
    if (!_activityTitle) {
        if (self.groupName && ![self.groupName isEqualToString:@""]) {
            _activityTitle = self.groupName;
        } else {
            _activityTitle = @"General";
        }
    }
    return _activityTitle;
}

- (NSAttributedString *)activityText {
    if (_activityPresentationText) {
        return _activityPresentationText;
    }
    if (!_activityText) {
        [self fillActivityText];
    }
    return _activityText;
}

- (NSString *)activityShortText {
    if (!_activityShortText) {
        [self fillActivityShortText];
    }
    return _activityShortText;
}

- (BOOL)hasRoute {
    return self.enumActivityType & ( GRVActivityTypeBanned |
            GRVActivityTypeUserBanned |
            GRVActivityTypeUnbanned |
            GRVActivityTypeMessageReplied |
            GRVActivityTypeMembershipRequestCreated |
            GRVActivityTypeMembershipRequestAccepted |
            GRVActivityTypeGroupChanged |
            GRVActivityTypeMembershipRequestSent |
            GRVActivityTypeWeekAfterUserRegistered |
            GRVActivityTypeSecondMemberJoined |
            GRVActivityTypeDayAfterGroupCreated);
}

- (void)fillActivityShortText {
    switch (self.enumActivityType) {
        case GRVActivityTypeBanned: {
            if (self.enumBanType == GRVBanTypeSpamBanned) {
                _activityShortText = @"Your message was spammed.";
            } if (self.enumBanType == GRVBanTypeAdminBanned) {
                _activityShortText = @"Group owner blocked you.";
            }
            break;
        }
        case GRVActivityTypeUserBanned: {
            _activityShortText = @"Take action: Spam report!";
            break;
        }
        case GRVActivityTypeUnbanned: {
            if (self.enumUnbannedBy == GRVUnbannedByAdmin) {
                _activityShortText = @"Group owner unblocked you.";
            } else {
                _activityShortText = @"You are unblocked!";
            }
            break;
        }
        case GRVActivityTypeMessageReplied: {
            _activityShortText = @"Someone replied to your message!";
            break;
        }
        case GRVActivityTypeGroupDeleted: {
            _activityShortText = @"";//no notification here
            break;
        }
        case GRVActivityTypeMembershipRequestCreated: {
            _activityShortText = @"Take action: User wants to join your group!";
            break;
        }
        case GRVActivityTypeMembershipRequestCancelled: {
            //no notification here
            break;
        }
        case GRVActivityTypeMembershipRequestAccepted: {
            _activityShortText = @"You are accepted to a group.";
            break;
        }
        case GRVActivityTypeMembershipRequestRejected: {
            //no notification here
            break;
        }
        case GRVActivityTypeGroupChanged : {
            if (self.enumGroupChangedType == GRVGroupChangedTypeStatus) {
                _activityShortText = @"Group privacy changed.";
            } else if (self.enumGroupChangedType == GRVGroupChangedTypeTitle) {
                _activityShortText = @"Group name changed.";
            }
            break;
        }
        case GRVActivityTypeMembershipRequestSent: {
            //no notification here
            break;
        }
        case GRVActivityTypeWeekAfterUserRegistered: {
            //no notification here
            break;
        }
        case GRVActivityTypeSecondMemberJoined: {
            _activityShortText = @"Your group got its first member!";
            break;
        }
        case GRVActivityTypeDayAfterGroupCreated: {
            //no notification here
            break;
        }
        case GRVActivityTypeGeneral: {
            _activityShortText = self.shortText;
            break;
        }
    }
}

- (void)fillActivityText {
    NSAttributedString* emptySpaceAttributedString = [[NSAttributedString alloc] initWithString:@"    "];
    switch (self.enumActivityType) {
        case GRVActivityTypeBanned: {
            if (self.enumBanType == GRVBanTypeSpamBanned) {
                _activityText = [self boldString:@"<b>You are blocked</b> from sending messages in a group because your message was marked as spam by other members. The group owner is notified and will review it. Learn more …"];
            } else if (self.enumBanType == GRVBanTypeAdminBanned) {
                _activityText = [self boldString:[NSString stringWithFormat:@"After reviewing your spammed message group owner decided to <b>block you</b> <b>%@</b>.", [self getTextPeriod]]];
            }
            _activityPresentationText = [[NSMutableAttributedString alloc] initWithAttributedString:_activityText];
            [_activityPresentationText insertAttributedString:emptySpaceAttributedString atIndex:0];
            break;
        }
        case GRVActivityTypeUserBanned: {
            _activityText = [self boldString:@"A member of your group <b>reported for spam</b>. Take action!"];
            _activityPresentationText = [[NSMutableAttributedString alloc] initWithAttributedString:_activityText];
            [_activityPresentationText insertAttributedString:emptySpaceAttributedString atIndex:0];
            break;

            break;
        }
        case GRVActivityTypeUnbanned: {
            if (self.enumUnbannedBy == GRVUnbannedByAdmin) {
                _activityText = [self boldString:@"Group owner reviewed your spammed message and <b>unblocked you</b>."];
            } else {
                _activityText = [self boldString:@"Your <b>block period has expired</b>. You can participate in the group again. Stay in good shape!"];
            }
            _activityPresentationText = [[NSMutableAttributedString alloc] initWithAttributedString:_activityText];
            [_activityPresentationText insertAttributedString:emptySpaceAttributedString atIndex:0];
            break;

            break;
        }
        case GRVActivityTypeMessageReplied: {
            _activityText = [self boldString:[NSString stringWithFormat:@"%@ <b>replied to your message</b>.", self.userName]];
            _activityPresentationText = [[NSMutableAttributedString alloc] initWithAttributedString:_activityText];
            [_activityPresentationText insertAttributedString:emptySpaceAttributedString atIndex:0];
            break;

            break;
        }
        case GRVActivityTypeGroupDeleted: {
            _activityText = [self boldString:@"The group was <b>deleted by an owner</b>."];
            _activityPresentationText = [[NSMutableAttributedString alloc] initWithAttributedString:_activityText];
            [_activityPresentationText insertAttributedString:emptySpaceAttributedString atIndex:0];
            break;

            break;
        }
        case GRVActivityTypeMembershipRequestCreated: {
            _activityText = [self boldString:[NSString stringWithFormat:@"%@ <b>requested access</b> to your group. Take action!", self.userName]];
            _activityPresentationText = [[NSMutableAttributedString alloc] initWithAttributedString:_activityText];
            [_activityPresentationText insertAttributedString:emptySpaceAttributedString atIndex:0];
            break;

            break;
        }
        case GRVActivityTypeMembershipRequestCancelled: {
            _activityText = [self boldString:[NSString stringWithFormat:@"%@ <b>cancelled request</b> to join your group.", self.userName]];
            break;
        }
        case GRVActivityTypeMembershipRequestAccepted: {
            _activityText = [self boldString:@"Group owner <b>accepted you</b> to the group. You may participate in discussions now."];
            break;
        }
        case GRVActivityTypeMembershipRequestRejected: {
            _activityText = [self boldString:@"Group owner decided <b>not to accept you</b> to the group. Look for a similar one or try again in the future."];
            break;
        }
        case GRVActivityTypeGroupChanged : {
            if (self.enumGroupChangedType == GRVGroupChangedTypeStatus) {
                _activityText = [self boldString:[NSString stringWithFormat:@"Group owner changed visibility of group from %@ to <b>%@</b>.", self.isPrivate.boolValue ? @"public" : @"private", self.isPrivate.boolValue ? @"private" : @"public"]];
            } else if (self.enumGroupChangedType == GRVGroupChangedTypeTitle) {
                _activityText = [self boldString:[NSString stringWithFormat:@"Group owner changed group name from <b>%@</b> to <b>%@</b>.", self.oldGroupName, self.groupName]];
            }
            break;
        }
        case GRVActivityTypeMembershipRequestSent: {
            _activityText = [self boldString:@"You sent a request to join private group. It’s pending review by a group owner."];
            break;
        }
        case GRVActivityTypeWeekAfterUserRegistered: {
            _activityText = [self boldString:@"You have been around for some time. Learn how you can block spammers from chats."];
            break;
        }
        case GRVActivityTypeSecondMemberJoined: {
            _activityText = [self boldString:@"A group you created just received its first member. Drop a line to the chat to get the conversation started."];
            break;
        }
        case GRVActivityTypeDayAfterGroupCreated: {
            _activityText = [self boldString:@"Your new group doesn't have any members yet. Share your group, invite friends to have it featured on Group Search and attract new members."];
            break;
        }
        case GRVActivityTypeGeneral: {
            _activityText = !IS_NULL(self.text) ? [self boldString:self.text] : [self boldString:@"Something went wrong :("];
            break;
        }
    }
}

- (NSString *)getTextPeriod {
    return self.banExpiryDate == nil ? @" permanently" : [NSString stringWithFormat:@" until %@", [[SPLMDateTimeFormatterHelper sharedHelper] dateTextForDate:self.banExpiryDate].string];
}

- (NSMutableAttributedString *)boldString:(NSString *)string {
    UIFont *boldFont = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    NSMutableAttributedString *attributedDescription = [[NSMutableAttributedString alloc] initWithString:string];

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@".*?<b>(.*?)<\\/b>.*?" options:NSRegularExpressionCaseInsensitive error:NULL];
    NSArray *myArray = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)] ;
    for (NSTextCheckingResult *match in myArray) {
        NSRange matchRange = [match rangeAtIndex:1];
        [attributedDescription addAttribute:NSFontAttributeName value:boldFont range:matchRange];
    }
    NSRange rangeOfTag;
    while ([attributedDescription.string containsString:@"<b>"] || [attributedDescription.string containsString:@"</b>"]) {
        rangeOfTag = [attributedDescription.string rangeOfString:@"<b>"];
        [attributedDescription replaceCharactersInRange:rangeOfTag withString:@""];
        rangeOfTag = [attributedDescription.string rangeOfString:@"</b>"];
        [attributedDescription replaceCharactersInRange:rangeOfTag withString:@""];
    }
    return attributedDescription;
}

@end
