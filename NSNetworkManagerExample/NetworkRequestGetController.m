//
//  NetworkRequestGetController.m
//  NSNetworkManagerExample
//
//  Created by BANYAN on 2017/8/29.
//  Copyright © 2017年 GREENBANYAN. All rights reserved.
//

#import "NetworkRequestGetController.h"
#import <TSMessage.h>
#import "NSNetworkManager.h"

static NSString *const requestUrlString = @"http://api.budejie.com/api/api_open.php?a=category&c=subscribe";
#define kPathCache   [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] //缓存路径

@interface NetworkRequestGetController ()

@end

@implementation NetworkRequestGetController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"GET请求";
    
    [[NSNetworkRequest sharedInstance] GET:requestUrlString parameters:nil cacheMode:YES successBlock:^(id responseObject) {
        NSLog(@"%@\n缓存路径为:  %@",responseObject,kPathCache);
      [TSMessage showNotificationWithTitle:@"GET请求成功,已缓存!" type:TSMessageNotificationTypeWarning];
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
      [TSMessage showNotificationWithTitle:[NSString stringWithFormat:@"GET请求失败:%@",error.description] type:TSMessageNotificationTypeWarning];
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
