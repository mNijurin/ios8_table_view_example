//
// Created by Adilet Abylov on 4/23/14.
// Copyright (c) 2014 Adilet Abylov. All rights reserved.
//

#import "SPLMDateTimeFormatterHelper.h"


@implementation SPLMDateTimeFormatterHelper {
    NSDateFormatter *_dateFormatter;
    NSDictionary *_attributesForTime;
}
+ (SPLMDateTimeFormatterHelper *)sharedHelper {
    static SPLMDateTimeFormatterHelper *sharedHelper;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        sharedHelper = [SPLMDateTimeFormatterHelper new];
    });
    return sharedHelper;
}

- (void)updateTimeZone {
    _dateFormatter.timeZone = [NSTimeZone localTimeZone];
}


- (id)init {
    self = [super init];
    if (self) {
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.timeZone = [NSTimeZone localTimeZone];
        _dateFormatter.locale = [NSLocale currentLocale];
    }

    return self;
}


- (NSAttributedString *)timeTextForDate:(NSDate *)date {
    if (date) {
        _dateFormatter.timeStyle = NSDateFormatterShortStyle;
        _dateFormatter.dateStyle = NSDateFormatterNoStyle;
        return [[NSAttributedString alloc] initWithString:[_dateFormatter stringFromDate:date] attributes:_attributesForTime];
    } else {
        return nil;
    }
}

- (NSAttributedString *)dateTextForDate:(NSDate *)date {
    if (date) {
        _dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        _dateFormatter.timeStyle = NSDateFormatterNoStyle;
        _dateFormatter.doesRelativeDateFormatting = YES;

        return [[NSAttributedString alloc] initWithString:[_dateFormatter stringFromDate:date] attributes:_attributesForTime];
    } else {
        return nil;
    }
}


@end