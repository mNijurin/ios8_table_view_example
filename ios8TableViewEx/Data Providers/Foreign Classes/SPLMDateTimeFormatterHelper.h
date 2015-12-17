//
// Created by Adilet Abylov on 4/23/14.
// Copyright (c) 2014 Adilet Abylov. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SPLMDateTimeFormatterHelper : NSObject
+ (SPLMDateTimeFormatterHelper *)sharedHelper;

- (void)updateTimeZone;

- (NSAttributedString *)timeTextForDate:(NSDate *)date;

- (NSAttributedString *)dateTextForDate:(NSDate *)date;


@end