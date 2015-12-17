//
// Created by Adilet Abylov on 2/25/14.
// Copyright (c) 2014 Adilet Abylov. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import <libextobjc/EXTScope.h>
#import "KOChatEntryElement.h"
#import "SPLMMessage.h"
#import "SPLMDateTimeFormatterHelper.h"
#import "SPLMMessageHelper.h"
#import "NSString+Grouvi.h"
#import "NSDate+DateTools.h"
#import "NSDate-Utilities.h"
#import "GRVUserModel.h"
#import "GRVEventMessageModel.h"
#import "GRVNotificationMessageModel.h"
#import "AppDelegate.h"

@interface SPLMMessage()
@property (nonatomic, strong, readwrite) NSNumber *liked;
@property (nonatomic, strong, readwrite) NSNumber *saved;
@property (nonatomic, strong, readwrite) NSNumber *spammed;
@property (nonatomic, strong, readwrite) NSString* shortMessagePreview;
@end

@implementation SPLMMessage

#pragma mark Mantle methods

+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"messageId": @"id",
             @"createdAt": @"created_at",
             @"updatedAt"   : @"updated_at",
             @"userId": @"user",
             @"userName": @"user",
             @"blocked": @"is_blocked",
             @"wasRemoved": @"is_deleted",
             @"serialNumber": @"serial",
             @"messageType": @"type",
             @"groupId": @"channel_id",
             @"uuid": @"uuid",
             @"userAvatarThumbUrl": @"user",
             @"text": @"data",
             @"bookmarkedBy": @"bookmarked_by",
             @"likedBy": @"liked_by",
             @"spamReportedBy": @"spam_reported_by"
             };
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    return dateFormatter;
}

+ (NSValueTransformer *) updatedAtJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *) createdAtJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *) userIdJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSDictionary *userInfo, BOOL *success, NSError *__autoreleasing *error) {
        return userInfo[@"id"];
    }];
}

+ (NSValueTransformer *) userNameJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSDictionary *userInfo, BOOL *success, NSError *__autoreleasing *error) {
        return userInfo[@"username"];
    }];
}

+ (NSValueTransformer *) userAvatarThumbUrlJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSDictionary *userInfo, BOOL *success, NSError *__autoreleasing *error) {
        return userInfo[@"avatar_thumb"];
    }];
}

+ (NSValueTransformer *) bookmarkedByJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *bookmarkedBy, BOOL *success, NSError *__autoreleasing *error) {
        return [[NSSet alloc] initWithArray:bookmarkedBy];
    } reverseBlock:^id(NSSet *bookmarkedBySet, BOOL *success, NSError *__autoreleasing *error) {
        return [[NSArray alloc] initWithArray:[bookmarkedBySet allObjects]];
    }];
}

+ (NSValueTransformer *) likedByJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *likedBy, BOOL *success, NSError *__autoreleasing *error) {
        return [[NSSet alloc] initWithArray:likedBy];
    } reverseBlock:^id(NSSet *likedBySet, BOOL *success, NSError *__autoreleasing *error) {
        return [[NSArray alloc] initWithArray:[likedBySet allObjects]];
    }];
}

+ (NSValueTransformer *) spamReportedByJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *spamReportedBy, BOOL *success, NSError *__autoreleasing *error) {
        return [[NSSet alloc] initWithArray:spamReportedBy];
    } reverseBlock:^id(NSSet *spamReportedBySet, BOOL *success, NSError *__autoreleasing *error) {
        return [[NSArray alloc] initWithArray:[spamReportedBySet allObjects]];
    }];
}

//@property (nonatomic, strong) NSSet *bookmarkedBy;
//@property (nonatomic, strong) NSSet *likedBy;
//@property (nonatomic, strong) NSSet *spamReportedBy;

+ (NSValueTransformer *) textJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSDictionary *dateDictionary, BOOL *success, NSError *__autoreleasing *error) {
        NSError *errorParsing;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dateDictionary options:NSJSONWritingPrettyPrinted error:&errorParsing];
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    } reverseBlock:^id(NSString *dataString, BOOL *success, NSError *__autoreleasing *error) {
        NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *errorParsing;
        return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&errorParsing];
    }];
}

+ (NSValueTransformer *) messageTypeJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:
            @{
                    @"UserMessage": @(GRVMessageTypeContent),
                    @"EventMessage": @(GRVMessageTypeEvent),
                    @"NotificationMessage": @(GRVMessageTypeNotification)
            } defaultValue:@(GRVMessageTypeContent) reverseDefaultValue:nil];
}

#pragma mark -
#pragma mark - MTLManagedObjectSerializing

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    // model_property_name     : core_date_property_name
    return @{
            @"text" : @"text",
            @"messageId" : @"messageId",
            @"userId" : @"userId",
            @"groupId" : @"groupId",
            @"userName" : @"userName",
            @"userAvatarThumbUrl" : @"userAvatarThumbUrl",
            @"createdAt" : @"createdAt",
            @"updatedAt" : @"updatedAt",
            @"blocked" : @"blocked",
            @"wasRemoved" : @"wasRemoved",
            @"uuid" : @"uuid",
            @"serialNumber" : @"serialNumber",
            @"inReplyToId" : @"inReplyToId",
            @"messageType" : @"messageType",
            @"bookmarkedBy" : @"bookmarkedBy",
            @"likedBy" : @"likedBy",
            @"spamReportedBy" : @"spamReportedBy",
            @"sendingStatus" : @"sendingStatus",
            @"read" : @"read",
            @"liked" : @"liked",
            @"saved" : @"saved",
            @"spammed" : @"spammed"
    };
}

+ (NSSet *)propertyKeysForManagedObjectUniquing {
    return [NSSet setWithObject:@"uuid"];
}

#pragma mark -
#pragma mark - Getters
- (NSNumber *)saved {
    _saved = @([self.bookmarkedBy containsObject:@12]);
    return _saved;
}

- (NSNumber *)liked {
    _liked = @([self.likedBy containsObject:@12]);
    return _liked;
}

- (NSNumber *)spammed {
    _spammed = @([self.spamReportedBy containsObject:@12]);
    return _spammed;
}

#pragma mark - Initializers
- (instancetype)init {
    self = [super init];
    if (self) {
        self.sendingStatus = @(koMessageStatusSuccessful);
        self.createdAt = [NSDate new];
        self.messageType = @(GRVMessageTypeContent);
    }

    return self;
}

- (id)initMessageWithText:(NSString *)text
                   sender:(GRVUserModel *)sender
                  groupId:(NSNumber *)groupId
                   status:(KOMessageStatus)messageStatus {
    self = [super init];
    if (self) {
        self.createdAt = [NSDate new];
        self.userName = sender.userName;
        self.userAvatarThumbUrl = sender.avatarUrl;
        self.userId = sender.userId;
        self.groupId = groupId;
        self.sendingStatus = @(messageStatus);
        self.messageType = @(GRVMessageTypeContent);
        self.text = text;
        self.uuid = [[NSString uuid] lowercaseString];
    }
    return self;
}

- (BOOL)isEqualToMessage:(SPLMMessage *)other {
    if (!other) {
        return NO;
    }

    if (self == other) {
        return YES;
    }

    if (self.uuid && other.uuid && ![self.uuid isEqualToString:@""] && ![other.uuid isEqualToString:@""]) {
        return [self.uuid isEqualToString:other.uuid];
    }

    BOOL sameStatus = self.sendingStatus == other.sendingStatus;
    BOOL sameFirstName = self.userName.hash == other.userName.hash;
    BOOL sameText = self.text.hash == other.text.hash;
    BOOL sameMedia = self.media.hash == other.media.hash;
    BOOL sameSerialNumber = self.serialNumber.unsignedIntegerValue == other.serialNumber.unsignedIntegerValue;
    return sameFirstName && sameText && sameMedia && sameStatus && sameSerialNumber;
}

- (BOOL)isSpammedAndReported {
    return self.isSpammed || self.isBlocked;
}

- (BOOL)isBlocked {
    return _blocked.boolValue;
}

- (BOOL)isDeleted {
    return _wasRemoved.boolValue;
}

- (BOOL)isRead {
    return _read.boolValue;
}

- (GRVEventMessageModel *)event {
    if (!_event && self.enumMessageType == GRVMessageTypeEvent) {
        NSError *errorParsing;
        NSData *data = [self.text dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *eventDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&errorParsing];
        _event = [GRVEventMessageModel buildModelWithDictionary:eventDictionary];
    }
    return _event;
}

- (GRVNotificationMessageModel *)notification {
    if (!_notification && self.enumMessageType == GRVMessageTypeNotification) {
        NSError *errorParsing;
        NSData *data = [self.text dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *notificationDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&errorParsing];
        _notification = [GRVNotificationMessageModel buildModelWithDictionary:notificationDictionary];
    }
    return _notification;
}

- (MessageType)enumMessageType {
    return (MessageType) _messageType.unsignedIntegerValue;
}

- (NSString *)userName {
    return _userName;
}

- (NSString *) shortUsername {
    if (!_userName) return nil;
    if (!_shortUsername) {
        if ([@12 isEqualToNumber:self.userId]) {
            _shortUsername = @"You: ";
        } else {
            NSString* shortName = [_userName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSArray* splits = [shortName componentsSeparatedByString:@" "];
            _shortUsername = [splits.firstObject stringByAppendingString:@": "];
        }
    }
    return _shortUsername;
}

-(NSString *)shortMessagePreview {
    if (!_shortMessagePreview) {
        if (self.event) {
            _shortMessagePreview = [self.event eventMessage];
        } else if (!self.notification) {
            DLog(@"ALLOC MESSAGE PREVIEW");
            SPLMMessageHelper* helper = [SPLMMessageHelper new];
            _shortMessagePreview = [helper messageDescription:_text];
        }
    }
    return _shortMessagePreview;
}


- (NSString *)avatarPath {
    return _userAvatarThumbUrl;
}

- (NSInteger)likesCount {
    return _likedBy.count;
}

-(NSString *)timeStringForActivity {
    if (!_timeStringForActivity) {
        _timeStringForActivity = [[self.createdAt shortTimeAgoSinceNow] stringByAppendingString:@" ago"];
    }
    return _timeStringForActivity;
}

-(NSString *)timeStringForGroupsPage {
    if (!_timeStringForGroupsPage) {
        if ([self.createdAt isToday]) {
            _timeStringForGroupsPage = self.timeString;
        } else if ([self.createdAt isWeekBeforeNow]) {
            _timeStringForGroupsPage = [self.createdAt dayOfWeek];
        } else {
            _timeStringForGroupsPage = self.createdAt.shortDateString;
        }
    }
    return _timeStringForGroupsPage;
}

- (NSString *)timeString {
    if (!self.creationTimeString) {
        self.creationTimeString = [[SPLMDateTimeFormatterHelper sharedHelper] timeTextForDate:self.createdAt].string;
    }
    return self.creationTimeString;
}

- (NSString *)dateString {
    if (!self.creationDateString) {
        self.creationDateString = [[SPLMDateTimeFormatterHelper sharedHelper] dateTextForDate:self.createdAt].string;
    }
    return self.creationDateString;
}

- (BOOL)isSaved {
    _saved = @([self.bookmarkedBy containsObject:@12]);
    return _saved.boolValue;
}

- (BOOL)isLiked {
    _liked = @([self.likedBy containsObject:@12]);
    return _liked.boolValue;
}

- (BOOL)isSpammed {
    _spammed = @([self.spamReportedBy containsObject:@12]);
    return _spammed.boolValue;
}

- (NSInteger)spamsCount {
    return _spamReportedBy.count;
}

- (NSArray *)contentArray{
    if (!_contentArray && self.enumMessageType == GRVMessageTypeContent) {
        if (self.text) {

            SPLMMessageHelper *messageHelper = [SPLMMessageHelper new];
            self.contentArray = [messageHelper textElementsFromJSONString:self.text];
            
        }
    }
    return _contentArray;
}


#pragma mark -
#pragma mark - NSObject
- (BOOL)isEqual:(SPLMMessage *)object {
    
    if (![object isKindOfClass:[SPLMMessage class]]) {
        return NO;
    }
    
    return [self isEqualToMessage:object];
}

- (NSUInteger)hash {
    return [self.uuid hash];
}

#pragma mark -
#pragma mark - Public methods
/**
 *  See .h file
 */

- (NSString *)contentToString {
    if (self.contentArray) {
        NSString *contentString = @"";
        for (KOChatEntryElement *element in self.contentArray) {
            switch (element.type) {
                case koChatEntryTypeText:
                    contentString = [contentString stringByAppendingFormat:@"%@ ", element.text];
                    break;

                case koChatEntryTypePhoto:
                    contentString = [contentString stringByAppendingString:[NSString stringWithFormat:@"%@ ", element.sourceURL.absoluteString]];
                    break;

                case koChatEntryTypeVideo:
                    contentString = [contentString stringByAppendingString:[NSString stringWithFormat:@"%@ ", element.sourceURL.absoluteString]];
                    break;
            }
        }
        return contentString;
    }
    return nil;
}

- (NSURL *)avatarURL {
    return [NSURL URLWithString:self.userAvatarThumbUrl];
}

#pragma mark GRVInAppNotificationProtocol

- (NSURL *) inAppAvatarURL {
    return self.avatarURL;
}

@end