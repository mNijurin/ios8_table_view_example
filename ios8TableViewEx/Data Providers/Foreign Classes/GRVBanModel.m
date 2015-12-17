//
//  GRVBanModel.m
//  GroupChat
//
//  Created by kanybek on 10/1/15.
//  Copyright (c) 2015 Grouvi. All rights reserved.
//

#import "MTLModel.h"
#import "GRVBanModel.h"
#import "MTLValueTransformer.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"
#import "GRVUserModel.h"

@implementation GRVBanModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"bannedAt"     : @"created_at",
             @"unbanAt"      : @"unban_at",
             @"banType"      : @"ban_type",
             @"banDuration"    : @"duration",
            @"user" : @"user",
             };
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    return dateFormatter;
}

+ (NSValueTransformer *)bannedAtJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)unbanAtJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)banTypeJSONTransformer {
    
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
            @"spam_banned" : @(GRVBanTypeSpamBanned),
            @"admin_banned" : @(GRVBanTypeAdminBanned)
    } defaultValue:@(GRVBanTypeSpamBanned) reverseDefaultValue:nil];
}

+ (NSValueTransformer *)userJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[GRVUserModel class]];
}

#pragma mark -
#pragma mark - MTLManagedObjectSerializing

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    // model_property_name     : core_data_property_name
    return @{
             @"bannedAt"     : @"bannedAt",
             @"unbanAt"      : @"unbanAt",
             @"banType"      : @"banType",
             @"banDuration"  : @"banDuration"
    };
    
}

#pragma mark - public methods

- (NSString *)banText {
    NSString *dateTimeString;
    if (self.unbanAt) {
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = [NSTimeZone localTimeZone];
        dateFormatter.locale = [NSLocale currentLocale];
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateTimeString = [dateFormatter stringFromDate:self.unbanAt];
    }

    switch (self.banDuration.integerValue) {
        case 0:
            if (self.enumBanType == GRVBanTypeSpamBanned) {
                return @"You were blocked from sending messages in this group because one of your messages was marked as \"spam\" and currently pending review by group owner. Come back to this page in a day or two to review your status in this group.";
            } else if (self.enumBanType == GRVBanTypeAdminBanned) {
                return @"After reviewing your spammed message the group owner made a decision to block you from sending messages in this group indefinitely.";
            }
        case 1:
            return [NSString stringWithFormat:@"After reviewing your spammed message the group owner made a decision to block you from sending messages in this group for 24 hours. The block will expire on %@.", dateTimeString ?: @""];
        case 7:
            return [NSString stringWithFormat:@"After reviewing your spammed message the group owner made a decision to block you from sending messages in this group for 1 week. The block will expire on %@.", dateTimeString ?: @""];
        default:
            return @"You were blocked from sending messages in this group.";
    }
}

- (GRVBanType)enumBanType {
    return (GRVBanType) self.banType.unsignedIntegerValue;
}

@end
