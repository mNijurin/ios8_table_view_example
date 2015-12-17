//
//  AppDelegate.h
//  test
//
//  Created by Maxim Nizhurin on 11/28/15.
//  Copyright © 2015 test. All rights reserved.
//

#define DLog(fmt, ...) NSLog((@"%@ Ln%d: " fmt), NSStringFromClass([self class]), __LINE__, ##__VA_ARGS__)
#define IS_NULL(v) (v == nil || [v isKindOfClass:[NSNull class]])

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;

@end

