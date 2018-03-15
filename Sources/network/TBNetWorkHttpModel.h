//
//  TBNetWorkHttpModel.h
//  AppAnalysis
//
//  Created by 骆朋飞 on 2017/6/4.
//  Copyright © 2017年 骆朋飞. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface TBNetWorkHttpModel : NSObject

@property (nonatomic,strong) NSURLRequest *ne_request;
@property (nonatomic,strong) NSHTTPURLResponse *ne_response;
@property (nonatomic,assign) double myID;
@property (nonatomic,strong) NSString *startDateString;
@property (nonatomic,strong) NSString *endDateString;

//request
@property (nonatomic,strong) NSString *requestURLString;
@property (nonatomic,strong) NSString *requestCachePolicy;
@property (nonatomic,assign) double requestTimeoutInterval;
@property (nonatomic,nullable, strong) NSString *requestHTTPMethod;
@property (nonatomic,nullable,strong) NSString *requestAllHTTPHeaderFields;
@property (nonatomic,nullable,strong) NSString *requestHTTPBody;

//response
@property (nonatomic,nullable,strong) NSString *responseMIMEType;
@property (nonatomic,strong) NSString * responseExpectedContentLength;
@property (nonatomic,nullable,strong) NSString *responseTextEncodingName;
@property (nullable, nonatomic, strong) NSString *responseSuggestedFilename;
@property (nonatomic,assign) int responseStatusCode;
@property (nonatomic,nullable,strong) NSString *responseAllHeaderFields;

//JSONData
@property (nonatomic,strong) NSString *receiveJSONData;

@property (nonatomic,strong) NSString *mapPath;
@property (nonatomic,strong) NSString *mapJSONData;

@end
NS_ASSUME_NONNULL_END
