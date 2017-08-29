//
//  ViewController.m
//  NSNetworkManagerExample
//
//  Created by BANYAN on 2017/8/26.
//  Copyright © 2017年 GREENBANYAN. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>

#import "MonitoringNetworkController.h"
#import "CurrentRadioAccessController.h"
#import "NetworkRequestGetController.h"
#import "NetworkRequestGetController.h"
#import "UploadImageController.h"
#import "UploadFileController.h"
#import "DownloadFileController.h"

NSString *const identifier = @"CellId";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *titleArray;
@end

@implementation ViewController
///================
#define kCellLineEdgeInsets UIEdgeInsetsMake(0,0,0,0)
#define kSCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define kSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets  = NO;
    
    self.navigationItem.title = @"Example";
    
    [self initUI];
}

#pragma mark - UI
-(void)initUI
{
    _titleArray = [NSArray new];
    _titleArray = @[@"实时监听网络状态",@"获取当前网络状态",@"GET请求",@"上传一张或多种图片",@"上传文件",@"下载文件"];
    
    _tableView = [UITableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.scrollEnabled = NO;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH,kSCREEN_HEIGHT - 64));
        make.left.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset(64);
    }];
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:kCellLineEdgeInsets];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:kCellLineEdgeInsets];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:18.f];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            MonitoringNetworkController *vc = [[MonitoringNetworkController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }break;
            
        case 1:
        {
            CurrentRadioAccessController *vc = [[CurrentRadioAccessController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }break;
            
        case 2:
        {
            NetworkRequestGetController *vc = [[NetworkRequestGetController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }break;
            
        case 3:
        {
            UploadImageController *vc = [[UploadImageController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }break;
            
        case 4:
        {
            UploadFileController *vc = [[UploadFileController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }break;
            
        case 5:
        {
            DownloadFileController *vc = [[DownloadFileController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }break;
            
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
