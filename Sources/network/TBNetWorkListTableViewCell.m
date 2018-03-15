//
//  TBNetWorkListTableViewCell.m
//  AppAnalysis
//
//  Created by 骆朋飞 on 2017/6/4.
//  Copyright © 2017年 骆朋飞. All rights reserved.
//

#import "TBNetWorkListTableViewCell.h"
#import <Masonry/Masonry.h>

@interface TBNetWorkListTableViewCell ()

@end

@implementation TBNetWorkListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:12.f];
        self.textLabel.textColor=[UIColor colorWithRed:0.24f green:0.51f blue:0.78f alpha:1.00f];
    }
    
    return self;
}

- (void)setHttpModel:(TBNetWorkHttpModel *)httpModel {
    _httpModel = httpModel;
    self.textLabel.text = httpModel.requestURLString;
    
    NSAttributedString *responseStatusCode;
    NSAttributedString *requestHTTPMethod;
    UIColor *titleColor=[UIColor colorWithRed:0.96 green:0.15 blue:0.11 alpha:1];
    if (httpModel.responseStatusCode == 200) {
        titleColor=[UIColor colorWithRed:0.11 green:0.76 blue:0.13 alpha:1];
    }
    UIFont *titleFont=[UIFont systemFontOfSize:12.0];
    UIColor *detailColor=[UIColor blackColor];
    UIFont *detailFont=[UIFont systemFontOfSize:12.0];
    responseStatusCode = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d   ",httpModel.responseStatusCode]
                                                                attributes:@{
                                                                             NSFontAttributeName : titleFont,
                                                                             NSForegroundColorAttributeName: titleColor
                                                                             }];
    
    requestHTTPMethod = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@   %@   %@",httpModel.requestHTTPMethod,httpModel.responseMIMEType,[httpModel.startDateString substringFromIndex:5]]
                                                               attributes:@{
                                                                            NSFontAttributeName : detailFont,
                                                                            NSForegroundColorAttributeName: detailColor
                                                                            }];
    NSMutableAttributedString *detail=[[NSMutableAttributedString alloc] init];
    [detail appendAttributedString:responseStatusCode];
    [detail appendAttributedString:requestHTTPMethod];
    self.detailTextLabel.attributedText=detail;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
