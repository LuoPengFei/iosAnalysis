//
//  APPModel.m
//  AppAnalysis
//
//  Created by 骆朋飞 on 2017/5/28.
//  Copyright © 2017年 骆朋飞. All rights reserved.
//

#import "APPModel.h"
#import <objc/runtime.h>

@interface APPModel ()
{
    id _applocationProxy;
}

@end

@implementation APPModel

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

#pragma mark - Public Methods

- (instancetype)initWithAppProxy:(id)app {
    
    if (self = [super init]) {
        
        _applocationProxy = app;
    }
    
    return self;
}

- (NSString *)applicationIdentifier {
    return [_applocationProxy performSelector:NSSelectorFromString(@"applicationIdentifier")];
}

- (NSNumber *)ODRDiskUsage {
    return [_applocationProxy performSelector:NSSelectorFromString(@"ODRDiskUsage")];
}

- (NSNumber *)staticDiskUsage {
    return [_applocationProxy performSelector:NSSelectorFromString(@"staticDiskUsage")];
}

- (BOOL)isSystemOrInternalApp {
    
    return [_applocationProxy performSelector:NSSelectorFromString(@"isSystemOrInternalApp")];
}


- (NSString *)localizedName {
    
    return [_applocationProxy performSelector:NSSelectorFromString(@"localizedName")];
    
}


- (NSString *)description {
    
    return [NSString stringWithFormat:@"name: %@\nversion:%@", [self localizedName],
            self.shortVersionString];
}

- (UIImage *)iconImage {
    
    NSData *iconData = [_applocationProxy performSelector:NSSelectorFromString(@"iconDataForVariant:") withObject:@(2)];
    
    NSInteger lenth = iconData.length;
    NSInteger width = 87;
    NSInteger height = 87;
    
    uint32_t *pixels = (uint32_t *)malloc(width * height * sizeof(uint32_t));
    [iconData getBytes:pixels range:NSMakeRange(32, lenth - 32)];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(pixels,
                                             width,
                                             height,
                                             8,
                                             (width + 1) * sizeof(uint32_t),
                                             colorSpace,
                                             kCGBitmapByteOrder32Little |
                                             kCGImageAlphaPremultipliedFirst);
    
    CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    UIImage *icon = [UIImage imageWithCGImage: cgImage];
    CGImageRelease(cgImage);
    
    return icon;
}

- (NSString *)prettySizeString {
    
    NSArray *units = @[ @"B", @"KB", @"MB", @"GB"];
    double dsize = [self.staticDiskUsage doubleValue];
    NSString *unit = @"B";
    NSInteger i = 0;
    while (dsize >= 1024) {
        
        dsize /= 1024;
        ++i;
        unit = [units objectAtIndex: i];
    }
    
    return [NSString stringWithFormat:@"%.2f %@", dsize, unit];
}

#pragma clang diagnostic pop


@end
