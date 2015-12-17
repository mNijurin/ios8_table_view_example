//
//  GRVUserModel.m
//  GroupChat
//
//  Created by kanybek on 8/7/15.
//  Copyright (c) 2015 Grouvi. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import <Mantle/MTLJSONAdapter.h>
#import "GRVUserModel.h"
#import "MTLValueTransformer.h"

@interface GRVUserModel ()

@property (nonatomic, copy, readwrite) NSString *creationDateText;

@end

@implementation GRVUserModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    // model_property_name : json_field_name
    return @{
             @"userId"                 : @"id",
             @"userName"               : @"username",
             @"avatarUrl"              : @"avatar",
             @"avatarThumbUrl"         : @"avatar_thumb",
             @"messagesCount"          : @"messages_count",
             @"reverseBookmarksCount"  : @"others_bookmarks_count",
             @"likesCount"         : @"others_likes_count",
             @"spamCount"          : @"others_spam_reports_count",
             @"isOnline"           : @"online",
             @"pushNotificationSound"  : @"push_notification_sound",
             @"isMuted"           : @"muted",
             @"createdAt"         : @"created_at",
             @"updatedAt"         : @"updated_at",
             };
}


+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    return dateFormatter;
}

+ (NSValueTransformer *)createdAtJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)updatedAtJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    // model_property_name     : core_date_property_name
    return @{
             @"userId"               : @"userId",
             @"userName"             : @"userName",
             @"avatarUrl"            : @"avatarUrl",
             @"avatarThumbUrl"       : @"avatarThumbUrl",
             @"messagesCount"        : @"messagesCount",
             @"reverseBookmarksCount"  : @"reverseBookmarksCount",
             @"likesCount"         : @"likesCount",
             @"spamCount"          : @"spamCount",
             @"isOnline"           : @"isOnline",
             @"pushNotificationSound"  : @"pushNotificationSound",
             @"isMuted"           : @"isMuted",
             @"createdAt"         : @"createdAt",
             @"updatedAt"         : @"updatedAt",
    };
}

+ (NSSet *)propertyKeysForManagedObjectUniquing
{
    return [NSSet setWithObject:@"userId"];
}


#warning change here, it s not true, it is not be here
- (NSString *)creationDateText {
    if (!_creationDateText) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"dd MMMM yyyy";
        _creationDateText = [formatter stringFromDate:self.createdAt];
        _creationDateText = [NSString stringWithFormat:@"Member since %@", _creationDateText];
    }
    return _creationDateText;
}

- (NSDictionary *)parametersForRequest {
    NSMutableDictionary *userDictionary = [NSMutableDictionary new];
    userDictionary[@"username"] = self.userName;
    if (self.avatarUrl) {
        userDictionary[@"avatar"] = self.avatarUrl;
    }
    if (self.avatarThumbUrl) {
        userDictionary[@"avatar_thumb"] = self.avatarThumbUrl;
    }
    return userDictionary;
}

//@property (nonatomic, strong) NSArray *spammedMessages;
//- (NSArray *)spammedMessages {
//    @weakify(self);
//    return [_spammedMessages.rac_sequence map:^id(NSDictionary *messageDict) {
//        @strongify(self);
//        SPLMMessage *message = [SPLMMessage buildModel:messageDict];
//        message.sendername = self.username;
//        message.userAvatar = self.avatarImagePath;
//        return message;
//    }].array;
//}

@end
