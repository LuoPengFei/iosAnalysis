//
//  ApplicationListManager.m
//  AppAnalysis
//
//  Created by 骆朋飞 on 2017/5/26.
//  Copyright © 2017年 骆朋飞. All rights reserved.
//

#import "ApplicationListManager.h"
#import <objc/runtime.h>

@implementation ApplicationListManager

+(instancetype)shareInstance {
    static ApplicationListManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ApplicationListManager alloc] init];
    });
    return manager;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (void)scanApps {
    
    Class cls = NSClassFromString(@"LSApplicationWorkspace");
    id s = [(id)cls performSelector:NSSelectorFromString(@"defaultWorkspace")];
    //    allApplications
    NSArray *arr = [s performSelector:NSSelectorFromString(@"allInstalledApplications")];
    NSMutableArray *apps = [NSMutableArray arrayWithCapacity:arr.count];
    for (id item in arr) {
        [apps addObject: [[APPModel alloc] initWithAppProxy: item]];
    }
    
    _apps = [apps copy];
}

- (BOOL)openApp:(APPModel *)app {
    
    Class cls = NSClassFromString(@"LSApplicationWorkspace");
    id s = [(id)cls performSelector:NSSelectorFromString(@"defaultWorkspace")];
    //
    BOOL success = [s performSelector:NSSelectorFromString(@"openApplicationWithBundleID:") withObject:app.applicationIdentifier];
    NSLog(@"open: %zd", success);
    
    return success;
}

#pragma clang diagnostic pop

@end
