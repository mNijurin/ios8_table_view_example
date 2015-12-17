//
//  GRVEventMessageModel.m
//  GroupChat
//
//  Created by kanybek on 10/14/15.
//  Copyright (c) 2015 Grouvi. All rights reserved.
//

#import "SPLMDateTimeFormatterHelper.h"
#import "GRVEventMessageModel.h"
#import "AppDelegate.h"

@interface GRVEventMessageModel ()
@property (nonatomic, strong, readwrite) NSNumber *eventType;
@property (nonatomic, copy, readwrite)   NSString *userName;
@property (nonatomic, copy, readwrite)   NSString *nGroupTitle;
@property (nonatomic, strong, readwrite) NSNumber *isPrivate;
@property (nonatomic, strong, readwrite) NSDate *unbanAt;

@property (nonatomic, strong, readwrite) NSNumber *banType;
@property (nonatomic, strong, readwrite) NSNumber *unbannedBy;
@property (nonatomic, strong, readwrite) NSNumber *groupChangedType;

@end

@implementation GRVEventMessageModel

+ (instancetype)buildModelWithDictionary:(NSDictionary *)dictionary {
    GRVEventMessageModel *event = [GRVEventMessageModel new];
    event.eventType = [self translateEventType:dictionary[@"name"]];

    if (event.enumEventType == GRVEventTypeGroupChanged) {
        event.groupChangedType = [self translateGroupChangedType:dictionary[@"attribute"]];
        [self parseGroup:dictionary[@"channel"] inToEvent:event];
    }
    if (event.enumEventType & (GRVEventTypeGroupCreated | GRVEventTypeUserJoined | GRVEventTypeUserLeft)) {
        [self parseUser:dictionary[@"user"] inToEvent:event];
    }
    if (event.enumEventType & (GRVEventTypeUserBanned | GRVEventTypeUserUnbanned)) {
        [self parseBan:dictionary[@"ban"] inToEvent:event];
        [self parseGroup:dictionary[@"ban"][@"channel"] inToEvent:event];
        [self parseUser:dictionary[@"ban"][@"user"] inToEvent:event];
        if (event.enumEventType == GRVEventTypeUserUnbanned && !IS_NULL(dictionary[@"unbanned_by"])) {
            event.unbannedBy = [self translateUnbannedBy:dictionary[@"unbanned_by"]];
        } else if (event.enumEventType == GRVEventTypeUserUnbanned && IS_NULL(dictionary[@"unbanned_by"])) {
            DLog(@"========================================== pizdec  pizdec  sluchilos in event message unbanned by == null ==========================================");
        }
    }
    return event;
}

+ (void)parseBan:(NSDictionary *)ban inToEvent:(GRVEventMessageModel *)event {
    if (!IS_NULL(ban[@"unban_at"])) {
        event.unbanAt = [[self dateFormatter] dateFromString:ban[@"unban_at"]];
    }
    event.banType = [self translateBanType:ban[@"ban_type"]];
}

+ (void)parseGroup:(NSDictionary *)group inToEvent:(GRVEventMessageModel *)event {
    event.isPrivate = group[@"is_private"];
    event.nGroupTitle = group[@"title"];
}

+ (void)parseUser:(NSDictionary *)user inToEvent:(GRVEventMessageModel *)event {
    event.userName = user[@"username"];
}

+ (NSNumber *)translateEventType:(NSString *)stringEventType {
    if ([stringEventType isEqualToString:@"channel_created"]) {return @(GRVEventTypeGroupCreated);}
    if ([stringEventType isEqualToString:@"channel_deleted"]) {return @(GRVEventTypeGroupDeleted);}
    if ([stringEventType isEqualToString:@"channel_changed"]) {return @(GRVEventTypeGroupChanged);}
    if ([stringEventType isEqualToString:@"user_joined"]) {return @(GRVEventTypeUserJoined);}
    if ([stringEventType isEqualToString:@"user_left"]) {return @(GRVEventTypeUserLeft);}
    if ([stringEventType isEqualToString:@"user_banned"]) {return @(GRVEventTypeUserBanned);}
    if ([stringEventType isEqualToString:@"user_unbanned"]) {return @(GRVEventTypeUserUnbanned);}
    return @(GRVEventTypeUserJoined);
}

+ (NSNumber *)translateBanType:(NSString *)stringBanType {
    if ([stringBanType isEqualToString:@"spam_banned"]) {return @(GRVBanTypeSpamBanned);}
    if ([stringBanType isEqualToString:@"admin_banned"]) {return @(GRVBanTypeAdminBanned);}
    return @(GRVBanTypeSpamBanned);
}

+ (NSNumber *)translateGroupChangedType:(NSString *)stringBanType {
    if ([stringBanType isEqualToString:@"title"]) {return @(GRVGroupChangedTypeTitle);}
    if ([stringBanType isEqualToString:@"picture"]) {return @(GRVGroupChangedTypePicture);}
    if ([stringBanType isEqualToString:@"description"]) {return @(GRVGroupChangedTypeDescription);}
    if ([stringBanType isEqualToString:@"is_private"]) {return @(GRVGroupChangedTypeStatus);}
    return @(GRVGroupChangedTypePicture);
}

+ (NSNumber *)translateUnbannedBy:(NSString *)stringUnbannedBy {
    if ([stringUnbannedBy isEqualToString:@"admin"]) {return @(GRVUnbannedByAdmin);}
    if ([stringUnbannedBy isEqualToString:@"system"]) {return @(GRVUnbannedBySystem);}
    return @(GRVUnbannedBySystem);
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    return dateFormatter;
}

#pragma mark -
#pragma mark - public methods

- (GRVEventType)enumEventType {
    return (GRVEventType)self.eventType.unsignedIntegerValue;
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


#pragma mark - Message to present in GRVEventRow
-(NSString *)eventMessage {
    NSString* result;
    switch (self.enumEventType) {
        case GRVEventTypeGroupCreated: {
            result = [NSString stringWithFormat:@"%@ created this group", self.userName];
            break;
        }
        case GRVEventTypeGroupDeleted: {
            result = @"Group was deleted";
            break;
        }
        case GRVEventTypeGroupChanged: {
            switch (self.enumGroupChangedType) {
                case GRVGroupChangedTypeTitle: {
                    result = [NSString stringWithFormat:@"Group owner changed group name to %@", self.nGroupTitle];
                    break;
                }
                case GRVGroupChangedTypePicture: {
                    result = [NSString stringWithFormat:@"Group owner changed group icon"];
                    break;
                }
                case GRVGroupChangedTypeDescription: {
                    result = [NSString stringWithFormat:@"Group owner changed group description"];
                    break;
                }
                case GRVGroupChangedTypeStatus: {
                    result = [NSString stringWithFormat:@"Group owner changed group visibility to %@", self.isPrivate.boolValue ? @"private" : @"public"];
                    break;
                }
            }
            break;
        }
        case GRVEventTypeUserJoined: {
            result = [NSString stringWithFormat:@"%@ joined", self.userName];
            break;
        }
        case GRVEventTypeUserLeft: {
            result = [NSString stringWithFormat:@"%@ left",self.userName];
            break;
        }
        case GRVEventTypeUserBanned: {
            if (self.enumBanType == GRVBanTypeSpamBanned) {
                result = [NSString stringWithFormat:@"%@ temporarily blocked for spamming. Pending review by a group owner", self.userName];
            } else {
                result = [NSString stringWithFormat:@"Group owner blocked %@ %@", self.userName, [self getTextPeriod]];
            }
            break;
        }
        case GRVEventTypeUserUnbanned: {
            if (self.enumUnbannedBy == GRVUnbannedBySystem) {
                result = [NSString stringWithFormat:@"%@'s block period has expired", self.userName];
            } else {
                result = [NSString stringWithFormat:@"Group owner unblocked %@", self.userName];
            }
            break;
        }
    }
    return result;
}

- (NSString *)getTextPeriod {
    return self.unbanAt == nil ? @" permanently" : [NSString stringWithFormat:@" until %@", [[SPLMDateTimeFormatterHelper sharedHelper] dateTextForDate:self.unbanAt].string];
}

@end
