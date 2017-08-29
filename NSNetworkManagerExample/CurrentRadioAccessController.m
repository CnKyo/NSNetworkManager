//
//  CurrentRadioAccessController.m
//  NSNetworkManagerExample
//
//  Created by BANYAN on 2017/8/29.
//  Copyright © 2017年 GREENBANYAN. All rights reserved.
//

#import "CurrentRadioAccessController.h"
#import <Masonry.h>
#import <TSMessage.h>
#import "NSNetworkManager.h"

@interface CurrentRadioAccessController ()
{
    UILabel *radioAccess;
}
@end

@implementation CurrentRadioAccessController
///================
#define kSCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define kSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"获取当前网络状态";
    
    radioAccess = [[UILabel alloc]init];
    radioAccess.font = [UIFont systemFontOfSize:20];
    radioAccess.textColor = [UIColor orangeColor];
    radioAccess.textAlignment = 1;
    [self.view addSubview:radioAccess];
    [radioAccess mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH, (kSCREEN_HEIGHT - 64 - 200) /2));
        make.left.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset(64);
    }];
    
    radioAccess.text = [NSString stringWithFormat:@"当前网络状态:%@",[NSNetworkMonitor currentNetworkStatusString]];
    [TSMessage showNotificationWithTitle:[NSString stringWithFormat:@"当前网络状态:%@",radioAccess.text] type:TSMessageNotificationTypeWarning];
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

@end
