//
// Created by Adilet Abylov on 1/17/15.
// Copyright (c) 2015 Adilet Abylov. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SPLMMessageHelper : NSObject

- (NSString *)inAppNotififcationTextWithMessageElements:(NSArray *)elements sendername:(NSString *)sendername;

- (NSString *)apnNotificationTextWithMessageElements:(NSArray *)elements groupName:(NSString *)groupName;

- (NSArray *)textElementsFromJSONString:(NSString *)jsonString;

- (NSString *) messageDescription:(NSString *) jsonString;

- (NSString *)processText:(NSString *)text;
@end