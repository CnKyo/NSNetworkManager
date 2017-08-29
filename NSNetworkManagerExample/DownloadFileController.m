//
//  DownloadFileController.m
//  NSNetworkManagerExample
//
//  Created by BANYAN on 2017/8/29.
//  Copyright © 2017年 GREENBANYAN. All rights reserved.
//

#import "DownloadFileController.h"
#import <Masonry.h>
#import <TSMessage.h>
#import "NSNetworkManager.h"

static NSString *const downloadUrlString = @"http://sc1.111ttt.com/2017/4/05/10/298101104389.mp3"; //纯音乐《春江花月夜》

@interface DownloadFileController ()

@end

@implementation DownloadFileController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"下载文件";
    
    [[NSNetworkRequest sharedInstance] downloadFileWithUrlString:downloadUrlString filedirectory:@"DownloadDirectory" progressBlock:^(NSProgress *progress) {
        CGFloat _progress = 100.f * progress.completedUnitCount / progress.totalUnitCount;
        NSLog(@"%.2f%%",_progress);
    } successBlock:^(NSString *filePatch) {
        NSLog(@"%@",filePatch);
        [TSMessage showNotificationWithTitle:@"下载成功" type:TSMessageNotificationTypeWarning];
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
         [TSMessage showNotificationWithTitle:@"下载失败" type:TSMessageNotificationTypeWarning];
    }];
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
