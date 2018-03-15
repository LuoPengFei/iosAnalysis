//
//  TBNetWorkListViewController.m
//  AppAnalysis
//
//  Created by 骆朋飞 on 2017/6/4.
//  Copyright © 2017年 骆朋飞. All rights reserved.
//

#import "TBNetWorkListViewController.h"
#import <Masonry/Masonry.h>
#import "TBNetWorkListTableViewCell.h"

#import "TBNetWorkModelManager.h"
#import "TBNetWorkModelDetailViewController.h"

@interface TBNetWorkListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) NSArray *httpRequests;
@property (nonatomic, strong) NSArray *filterHttpRequests;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong)UIButton *backButton;


@end

@implementation TBNetWorkListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
    
    [self.navigationItem setTitleView:self.titleLabel];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.httpRequests = [[TBNetWorkModelManager defaultManager] allobjects];
    
    [self.tableView reloadData];
}

#pragma mark- <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.httpRequests.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TBNetWorkListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (nil == cell) {
        cell = [[TBNetWorkListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
    }
    cell.httpModel = self.httpRequests[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TBNetWorkModelDetailViewController *detailVC = [[TBNetWorkModelDetailViewController alloc] init];
    detailVC.model = self.httpRequests[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backBtAction {
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-64) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        double flowCount=[[[NSUserDefaults standardUserDefaults] objectForKey:@"flowCount"] doubleValue];
        if (!flowCount) {
            flowCount=0.0;
        }
        UIColor *titleColor=[UIColor whiteColor];
        UIFont *titleFont=[UIFont systemFontOfSize:18.0];
        UIColor *detailColor=[UIColor whiteColor];
        UIFont *detailFont=[UIFont systemFontOfSize:12.0];
        
        NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:@"NetWorkMonitor\n"
                                                                                        attributes:@{
                                                                                                     NSFontAttributeName : titleFont,
                                                                                                     NSForegroundColorAttributeName: titleColor
                                                                                                     }];
        
        NSMutableAttributedString *flowCountString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"流量共%.1lfMB",flowCount]
                                                                                            attributes:@{
                                                                                                         NSFontAttributeName : detailFont,
                                                                                                         NSForegroundColorAttributeName: detailColor
                                                                                                         }];
        
        NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] init];
        [attrText appendAttributedString:titleString];
        [attrText appendAttributedString:flowCountString];
        UILabel *titleText = [[UILabel alloc] initWithFrame: CGRectMake(([[UIScreen mainScreen] bounds].size.width-120)/2, 20, 120, 44)];
        titleText.backgroundColor = [UIColor clearColor];
        titleText.textColor=[UIColor whiteColor];
        titleText.textAlignment=NSTextAlignmentCenter;
        titleText.numberOfLines=0;
        titleText.attributedText=attrText;
        _titleLabel = titleText;
    }
    
    return _titleLabel;
}

- (UIButton *)backButton {
    if (!_backButton) {
        UIButton *backBt=[UIButton buttonWithType:UIButtonTypeCustom];
        backBt.frame=CGRectMake(10, 27, 40, 30);
        [backBt setTitle:@"返回" forState:UIControlStateNormal];
        backBt.titleLabel.font=[UIFont systemFontOfSize:15];
        [backBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [backBt addTarget:self action:@selector(backBtAction) forControlEvents:UIControlEventTouchUpInside];
        _backButton = backBt;
    }
    return _backButton;
}
@end
