//
//  NetworkManager.h
//  AppAnalysis
//
//  Created by 骆朋飞 on 2017/5/28.
//  Copyright © 2017年 骆朋飞. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kSQLitePassword @"networkeye"
#define kSaveRequestMaxCount 300


@interface NetworkManager : NSURLProtocol

/**
 *  open or close HTTP/HTTPS monitor
 *
 */
+ (void)setEnabled:(BOOL)enabled;

/**
 *  display HTTP/HTTPS monitor state
 *
 *  @return HTTP/HTTPS monitor state
 */
+ (BOOL)isEnabled;

@end
