//
//  NetworkManager.m
//  AppAnalysis
//
//  Created by 骆朋飞 on 2017/5/28.
//  Copyright © 2017年 骆朋飞. All rights reserved.
//

#import "NetworkManager.h"
#import "TBNetWorkURLSessionConfiguration.h"
#import "TBNetWorkHttpModel.h"
#import "TBNetWorkModelManager.h"

@interface NetworkManager ()<NSURLConnectionDelegate, NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic,strong) TBNetWorkHttpModel *ne_HTTPModel;
@end

@implementation NetworkManager

@synthesize ne_HTTPModel;
#pragma mark - public
+ (void)setEnabled:(BOOL)enabled {
    [[NSUserDefaults standardUserDefaults] setDouble:enabled forKey:@"NetworkEyeEnable"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    TBNetWorkURLSessionConfiguration * sessionConfiguration=[TBNetWorkURLSessionConfiguration defaultConfiguration];
    
    if (enabled) {
        [NSURLProtocol registerClass:[NetworkManager class]];
        if (![sessionConfiguration isSwizzle]) {
            [sessionConfiguration load];
        }
    }else{
        [NSURLProtocol unregisterClass:[NetworkManager class]];
        if ([sessionConfiguration isSwizzle]) {
            [sessionConfiguration unload];
        }
    }
}

+ (BOOL)isEnabled {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"NetworkEyeEnable"] boolValue];
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

+ (void)load {
    
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if (![request.URL.scheme isEqualToString:@"http"] &&
        ![request.URL.scheme isEqualToString:@"https"]) {
        return NO;
    }
    
    if ([NSURLProtocol propertyForKey:@"NetworkManager" inRequest:request] ) {
        return NO;
    }
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    [NSURLProtocol setProperty:@YES
                        forKey:@"NetworkManager"
                     inRequest:mutableReqeust];
    return [mutableReqeust copy];
}

- (void)startLoading {
    self.startDate = [NSDate date];
    self.data = [NSMutableData data];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    self.connection = [[NSURLConnection alloc] initWithRequest:[[self class] canonicalRequestForRequest:self.request] delegate:self startImmediately:YES];
#pragma clang diagnostic pop
    
    ne_HTTPModel=[[TBNetWorkHttpModel alloc] init];
    ne_HTTPModel.ne_request=self.request;
    ne_HTTPModel.startDateString=[self stringWithDate:[NSDate date]];
    
    NSTimeInterval myID=[[NSDate date] timeIntervalSince1970];
    double randomNum=((double)(arc4random() % 100))/10000;
    ne_HTTPModel.myID=myID+randomNum;
}

- (void)stopLoading {
    [self.connection cancel];
    ne_HTTPModel.ne_response=(NSHTTPURLResponse *)self.response;
    ne_HTTPModel.endDateString=[self stringWithDate:[NSDate date]];
    NSString *mimeType = self.response.MIMEType;
    if ([mimeType isEqualToString:@"application/json"]) {
        ne_HTTPModel.receiveJSONData = [self responseJSONFromData:self.data];
    } else if ([mimeType isEqualToString:@"text/javascript"]) {
        // try to parse json if it is jsonp request
        NSString *jsonString = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
        // formalize string
        if ([jsonString hasSuffix:@")"]) {
            jsonString = [NSString stringWithFormat:@"%@;", jsonString];
        }
        if ([jsonString hasSuffix:@");"]) {
            NSRange range = [jsonString rangeOfString:@"("];
            if (range.location != NSNotFound) {
                range.location++;
                range.length = [jsonString length] - range.location - 2; // removes parens and trailing semicolon
                jsonString = [jsonString substringWithRange:range];
                NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                ne_HTTPModel.receiveJSONData = [self responseJSONFromData:jsonData];
            }
        }
        
    }else if ([mimeType isEqualToString:@"application/xml"] ||[mimeType isEqualToString:@"text/xml"]){
        NSString *xmlString = [[NSString alloc]initWithData:self.data encoding:NSUTF8StringEncoding];
        if (xmlString && xmlString.length>0) {
            ne_HTTPModel.receiveJSONData = xmlString;//example http://webservice.webxml.com.cn/webservices/qqOnlineWebService.asmx/qqCheckOnline?qqCode=2121
        }
    }
    double flowCount=[[[NSUserDefaults standardUserDefaults] objectForKey:@"flowCount"] doubleValue];
    if (!flowCount) {
        flowCount=0.0;
    }
    flowCount=flowCount+self.response.expectedContentLength/(1024.0*1024.0);
    [[NSUserDefaults standardUserDefaults] setDouble:flowCount forKey:@"flowCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];//https://github.com/coderyi/NetworkEye/pull/6
    [[TBNetWorkModelManager defaultManager] addModel:ne_HTTPModel];
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error {
    [[self client] URLProtocol:self didFailWithError:error];
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection {
    return YES;
}

- (void)connection:(NSURLConnection *)connection
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [[self client] URLProtocol:self didReceiveAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection
didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [[self client] URLProtocol:self didCancelAuthenticationChallenge:challenge];
}

#pragma mark - NSURLConnectionDataDelegate
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
    if (response != nil){
        self.response = response;
        [[self client] URLProtocol:self wasRedirectedToRequest:request redirectResponse:response];
    }
    return request;
}

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response {
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    self.response = response;
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data {
    NSString *mimeType = self.response.MIMEType;
    if ([mimeType isEqualToString:@"application/json"]) {
        NSArray *allMapRequests = [[TBNetWorkModelManager defaultManager] allMapObjects];
        for (NSInteger i=0; i < allMapRequests.count; i++) {
            TBNetWorkHttpModel *req = [allMapRequests objectAtIndex:i];
            if ([[ne_HTTPModel.ne_request.URL absoluteString] containsString:req.mapPath]) {
                NSData *jsonData = [req.mapJSONData dataUsingEncoding:NSUTF8StringEncoding];
                [[self client] URLProtocol:self didLoadData:jsonData];
                [self.data appendData:jsonData];
                return;
                
            }
        }
    }
    [[self client] URLProtocol:self didLoadData:data];
    [self.data appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return cachedResponse;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [[self client] URLProtocolDidFinishLoading:self];
}

#pragma mark - Utils

-(id)responseJSONFromData:(NSData *)data {
    if(data == nil) return nil;
    NSError *error = nil;
    id returnValue = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if(error) {
        NSLog(@"JSON Parsing Error: %@", error);
        return nil;
    }
    if (!returnValue || returnValue == [NSNull null]) {
        return nil;
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:returnValue options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

- (NSString *)stringWithDate:(NSDate *)date {
    NSString *destDateString = [[NetworkManager defaultDateFormatter] stringFromDate:date];
    return destDateString;
}

+ (NSDateFormatter *)defaultDateFormatter {
    static NSDateFormatter *staticDateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticDateFormatter=[[NSDateFormatter alloc] init];
        [staticDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];//zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    });
    return staticDateFormatter;
}





@end
