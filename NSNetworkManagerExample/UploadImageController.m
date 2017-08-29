//
//  UploadImageController.m
//  NSNetworkManagerExample
//
//  Created by BANYAN on 2017/8/29.
//  Copyright © 2017年 GREENBANYAN. All rights reserved.
//

#import "UploadImageController.h"
#import "NSNetworkManager.h"
#import <TSMessage.h>

static NSString *const uploadUrlString = @""; //上传图片地址
static NSString *const stipulatedName = @""; //服务器约定名称

@interface UploadImageController ()
@property (nonatomic,strong) NSMutableArray *imageDataArray;
@property (nonatomic,strong) NSMutableArray *imageNameArray;
@end

@implementation UploadImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"上传一张或多张图片";
    
    _imageDataArray = [NSMutableArray array];
    _imageNameArray = [NSMutableArray array];
    
    [[NSNetworkRequest sharedInstance]uploadImagesWithUrlString:uploadUrlString
                                                     parameters:nil
                                                 stipulatedName:stipulatedName
                                                         images:_imageDataArray
                                                      fileNames:_imageNameArray
                                                  compressFloat:1.0f
                                                    imageFormat:@"jpg"
                                                  progressBlock:^(NSProgress *progress) {
                                                      CGFloat _progress = 100.f * progress.completedUnitCount / progress.totalUnitCount;
                                                      NSLog(@"%.2f%%",_progress);
    } successBlock:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [TSMessage showNotificationWithTitle:@"上传成功" type:TSMessageNotificationTypeWarning];
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [TSMessage showNotificationWithTitle:error.description type:TSMessageNotificationTypeWarning];
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
