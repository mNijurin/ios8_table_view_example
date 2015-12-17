//
//  KOChatEntryElement.h
//  Pods
//
//  Created by Kalys Osmonov on 8/7/14.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "KOChatEntryDelegate.h"

@interface KOChatEntryElement : NSObject<KOChatElementProtocol>

+ (instancetype)elementWithText:(NSString *)text;

@property (nonatomic, assign) KOChatEntryType type;
@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) NSURL *thumbnailURL;
@property (nonatomic, strong) NSURL *sourceURL;
@property (nonatomic, strong) NSURL *videoThumbnailURL;

@property (nonatomic, strong) NSString *udid;
@property (nonatomic, strong) NSNumber *size;
@property (nonatomic, assign) CGSize mediaSize;

/**
 *  Refreshes local URLs.
 *
 *  You cannot use absolute URLs 
 *  cuz files are removed to the another folder 
 *  when user updates app (runs from Xcode).
 *  That's why we should update URLs.
 */
- (void)refreshLocalURLs;

- (NSString *)sizeString;

@end
