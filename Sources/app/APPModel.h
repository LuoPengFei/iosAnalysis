//
//  APPModel.h
//  AppAnalysis
//
//  Created by 骆朋飞 on 2017/5/28.
//  Copyright © 2017年 骆朋飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
 app model类
 需要属性通过类似applicationIdentifier方法获取
 目前实现了几个需要用的
 */
@interface APPModel : NSObject
@property (nonatomic, readonly) NSNumber *ODRDiskUsage;
@property (nonatomic, readonly) NSString *applicationIdentifier;
@property (nonatomic, readonly) NSString *applicationType;
@property (nonatomic, readonly) NSNumber *dynamicDiskUsage;
@property (nonatomic, readonly) BOOL isBetaApp;
@property (nonatomic, readonly) BOOL isInstalled;
@property (nonatomic, readonly) BOOL isNewsstandApp;
@property (nonatomic, readonly) BOOL isPlaceholder;
@property (nonatomic, readonly) BOOL isRestricted;
@property (nonatomic, readonly) BOOL isWatchKitApp;
@property (nonatomic, readonly) NSNumber *itemID;
@property (nonatomic, readonly) NSString *itemName;
@property (nonatomic, readonly) NSString *minimumSystemVersion;
@property (nonatomic, readonly) NSString *sdkVersion;
@property (nonatomic, readonly) NSString *shortVersionString;
@property (nonatomic, readonly) NSString *sourceAppIdentifier;
@property (nonatomic, readonly) NSNumber *staticDiskUsage;
@property (nonatomic, readonly) NSString *teamID;
@property (nonatomic, readonly) NSString *bundleIdentifier;


- (instancetype)initWithAppProxy:(id)app;

- (NSString *)localizedName;
- (UIImage *)iconImage;
- (NSString *)prettySizeString;
- (BOOL)isSystemOrInternalApp;


@end
