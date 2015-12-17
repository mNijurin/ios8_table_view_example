//
// Created by Adilet Abylov on 3/25/14.
// Copyright (c) 2014 Adilet Abylov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Grouvi)

- (NSUInteger)countOfUTFSymbols;

- (NSString *)sentenceCapitalizedString;

- (NSString *) firstSentence;

- (NSString *)realSentenceCapitalizedString;

+ (NSString *)uuid;
@end