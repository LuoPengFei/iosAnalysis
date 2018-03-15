//
//  FPSManager.m
//  AppAnalysis
//
//  Created by 骆朋飞 on 2017/5/28.
//  Copyright © 2017年 骆朋飞. All rights reserved.
//

#import "FPSManager.h"

@interface FPSManager () {
    
}

@end

@implementation FPSManager

+ (instancetype)shareInstance {
    static FPSManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FPSManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _displayFrame = CGRectMake(10, 20, 80, 30);
    }
    
    return self;
}


@end
