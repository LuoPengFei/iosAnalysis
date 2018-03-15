//
//  TBNetWorkURLSessionConfiguration.h
//  AppAnalysis
//
//  Created by 骆朋飞 on 2017/6/4.
//  Copyright © 2017年 骆朋飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBNetWorkURLSessionConfiguration : NSObject

@property (nonatomic,assign) BOOL isSwizzle;// whether swizzle NSURLSessionConfiguration's protocolClasses method

/**
 *  get NEURLSessionConfiguration's singleton object
 *
 *  @return singleton object
 */
+ (TBNetWorkURLSessionConfiguration *)defaultConfiguration;

/**
 *  swizzle NSURLSessionConfiguration's protocolClasses method
 */
- (void)load;

/**
 *  make NSURLSessionConfiguration's protocolClasses method is normal
 */
- (void)unload;


@end
