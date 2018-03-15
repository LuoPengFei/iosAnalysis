//
//  TBNSLogViewController.m
//  AppAnalysis
//
//  Created by 骆朋飞 on 2017/6/4.
//  Copyright © 2017年 骆朋飞. All rights reserved.
//

#import "TBNSLogViewController.h"
#import <Masonry/Masonry.h>

#import <asl.h>
#include <stdio.h>

@interface TBLogModel:NSObject
@property (nonatomic, strong)   NSDate *date;
@property (nonatomic, copy)     NSString *sender;
@property (nonatomic, copy)     NSString *messageText;
@property (nonatomic, assign)   long long messageID;
@end

@implementation TBLogModel

+(instancetype)messageFromASLMessage:(aslmsg)aslMessage
{
    TBLogModel *logMessage = [[TBLogModel alloc] init];
    
    const char *timestamp = asl_get(aslMessage, ASL_KEY_TIME);
    if (timestamp) {
        NSTimeInterval timeInterval = [@(timestamp) integerValue];
        const char *nanoseconds = asl_get(aslMessage, ASL_KEY_TIME_NSEC);
        if (nanoseconds) {
            timeInterval += [@(nanoseconds) doubleValue] / NSEC_PER_SEC;
        }
        logMessage.date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    }
    
    const char *sender = asl_get(aslMessage, ASL_KEY_SENDER);
    if (sender) {
        logMessage.sender = @(sender);
    }
    
    const char *messageText = asl_get(aslMessage, ASL_KEY_MSG);
    if (messageText) {
        logMessage.messageText = @(messageText);
        
    }
    
    const char *messageID = asl_get(aslMessage, ASL_KEY_MSG_ID);
    if (messageID) {
        logMessage.messageID = [@(messageID) longLongValue];
        
    }
    
    return logMessage;
}

+ (NSString *)stringFormatFromDate:(NSDate *)date
{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    });
    
    return [formatter stringFromDate:date];
}
@end



@interface TBNSLogViewController ()
{
    int maxCount;
}

@property (nonatomic, strong) UITextView *textView;
@end

@implementation TBNSLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btnclose = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    btnclose.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnclose setTitle:@"Back" forState:UIControlStateNormal];
    [btnclose addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc] initWithCustomView:btnclose];
    self.navigationItem.leftBarButtonItem = btnleft;
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [self.textView setEditable:NO];
    self.textView.textContainer.lineBreakMode = NSLineBreakByWordWrapping;
    self.textView.font = [UIFont systemFontOfSize:13];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
    }];

}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)loadLogs {
    __weak UITextView* weakTxt = _textView;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray* arr = [self logs];
        if (arr.count > 0) {
            NSMutableAttributedString* string = [[NSMutableAttributedString alloc] init];
            for (TBLogModel* model in arr) {
                NSString* date = [TBLogModel stringFormatFromDate:model.date];
                NSMutableAttributedString* att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:",date]];
//                [att addAttribute:NSForegroundColorAttributeName value:[JxbDebugTool shareInstance].mainColor range:NSMakeRange(0, att.string.length)];
                
                NSMutableAttributedString* att2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n\n",model.messageText]];
                [att2 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, att2.string.length)];
                
                [string appendAttributedString:att];
                [string appendAttributedString:att2];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                weakTxt.attributedText = string;
            });
            
            //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //               [weakTxt scrollRectToVisible:CGRectMake(0, weakTxt.contentSize.height, weakTxt.frame.size.width, 1) animated:NO];
            //            });
        }
    });
}

- (NSArray* )logs {
    asl_object_t query = asl_new(ASL_TYPE_QUERY);
    char pidStr[100];
    sprintf(pidStr,"%d",[[NSProcessInfo processInfo] processIdentifier]);
    asl_set_query(query, ASL_KEY_PID, pidStr, ASL_QUERY_OP_EQUAL);
    
    //this is too slow!
    aslresponse response = asl_search(NULL, query);
    NSUInteger numberOfLogs = maxCount;
    NSMutableArray *logMessages = [NSMutableArray arrayWithCapacity:numberOfLogs];
    size_t count = asl_count(response);
    for (int i=0; i<numberOfLogs; i++) {
        aslmsg msg = asl_get_index(response, count - i - 1);
        if (msg != NULL) {
            TBLogModel* model = [TBLogModel messageFromASLMessage:msg];
            [logMessages addObject:model];
        }
        else
        break;
    }
    asl_release(response);
    return logMessages;
}


@end
