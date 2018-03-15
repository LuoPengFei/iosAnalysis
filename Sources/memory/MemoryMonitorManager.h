//
//  MemoryMonitorManager.h
//  AppAnalysis
//
//  Created by 骆朋飞 on 2017/5/28.
//  Copyright © 2017年 骆朋飞. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 获取当前应用的 CPU 占有率
 */
float cpu_usage();


@interface MemoryMonitorManager : NSObject


/**
 获取当前 App Memory 使用情况
 */
- (NSUInteger)getResidentMemory;

/**
 获取当前应用的 CPU 占有率
 */
- (void)getCPUUsage;
@end
