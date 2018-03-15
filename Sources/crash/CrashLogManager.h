//
//  CrashLogManager.h
//  AppAnalysis
//
//  Created by 骆朋飞 on 2017/5/28.
//  Copyright © 2017年 骆朋飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrashLogManager : NSObject

+ (instancetype)sharedInstance;

/**
 appdelegate 注册回调函数
 */
- (void)install;

- (NSDictionary* )crashForKey:(NSString* )key;
- (NSArray* )crashPlist;
- (NSArray* )crashLogs;

@end
