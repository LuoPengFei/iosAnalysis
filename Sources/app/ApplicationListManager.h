//
//  ApplicationListManager.h
//  AppAnalysis
//
//  Created by 骆朋飞 on 2017/5/26.
//  Copyright © 2017年 骆朋飞. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "APPModel.h"

@interface ApplicationListManager : NSObject

@property (nonatomic, strong, readonly) NSArray *apps;

+(instancetype)shareInstance;

/**
 *  扫描本地安装的 App
 */
- (void)scanApps;

/**
 *  打开 App
 *
 *  @param app APPModel
 *
 *  @return success
 */
- (BOOL)openApp:(APPModel *)app;

@end
