//
//  UploadFileController.m
//  NSNetworkManagerExample
//
//  Created by BANYAN on 2017/8/29.
//  Copyright © 2017年 GREENBANYAN. All rights reserved.
//

#import "UploadFileController.h"
#import "NSNetworkManager.h"
#import <TSMessage.h>

static NSString *const uploadUrlString = @""; //上传图片地址
static NSString *const stipulatedName = @""; //服务器约定名称
#define kPathCache   [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] 

@interface UploadFileController ()

@end

@implementation UploadFileController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"上传文件";
    
    [[NSNetworkRequest sharedInstance]uploadFileWithUrlString:uploadUrlString parameters:nil stipulatedName:stipulatedName filePath:kPathCache progressBlock:^(NSProgress *progress) {
        CGFloat _progress = 100.f * progress.completedUnitCount / progress.totalUnitCount;
        NSLog(@"%.2f%%",_progress);
    } successBlock:^(id responseObject) {
        [TSMessage showNotificationWithTitle:@"上传成功" type:TSMessageNotificationTypeWarning];
        NSLog(@"%@\n%@",responseObject,kPathCache);
    } failureBlock:^(NSError *error) {
        [TSMessage showNotificationWithTitle:[NSString stringWithFormat:@"上传失败:%@",error.description] type:TSMessageNotificationTypeWarning];
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
