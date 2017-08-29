//
//  MonitoringNetworkController.m
//  NSNetworkManagerExample
//
//  Created by BANYAN on 2017/8/29.
//  Copyright © 2017年 GREENBANYAN. All rights reserved.
//

#import "MonitoringNetworkController.h"
#import <Masonry.h>
#import <TSMessage.h>
#import "NSNetworkManager.h"

@interface MonitoringNetworkController ()<NSNetworkMonitorProtocol>
@property (nonatomic,strong) NSString *radioAccess;
@end

@implementation MonitoringNetworkController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"实时监听网络状态";
    
    [NSNetworkMonitor registerNetworkNotification:self];
    
    _radioAccess = [NSNetworkMonitor currentNetworkStatusString];
    [TSMessage showNotificationWithTitle:[NSString stringWithFormat:@"当前网络状态:%@",_radioAccess] type:TSMessageNotificationTypeWarning];
}

-(void)networkStatusChangeNotification:(NSNotification *)notification
{
    _radioAccess = [NSNetworkMonitor currentNetworkStatusString];
    NSLog(@"%@\n%@",_radioAccess,notification);
    
    [TSMessage showNotificationWithTitle:[NSString stringWithFormat:@"当前网络状态:%@",_radioAccess]  type:TSMessageNotificationTypeWarning];
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
