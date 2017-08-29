# NSNetworkManager &copy;*GREENBANAYAN*
![Cocoapods](https://img.shields.io/badge/Cocoapods-Support-green.svg)&nbsp;
![License](https://img.shields.io/badge/License-MIT-orange.svg)&nbsp;
![Platform](https://img.shields.io/badge/Platform-iOS-yellowgreen.svg)&nbsp;
![Support](https://img.shields.io/badge/Support-iOS%208%2B-lightgrey.svg)&nbsp;

 基于[__YYCache__][1]和[__AFNetworking__][2]封装的网络状态监听以及请求库,主要功能如下:
 - 实时监听当前APP的网络状态;
 - 获取当前网络状态，如"3G"、"4G"、"Wifi"等;
 - 常用网络请求，如"get"、"post"、"put"、"patch"、"delete"，支持缓存选项;
 - 支持单张或多张图片上传;
 - 更方便的上传文件、下载文件。
### 目录
<pre>
                      |—— NSNetworkSingleton  //封装单例
                      |—— NSNetworkStatus  //网络状态枚举、网络请求模式枚举
                      |—— NSNetworkProtocol  //网络波动监听协议
  NSNetworkManager    |—— Reachability  //网络状态监测
                      |—— NSNetworkCache  //网络数据缓存封装,refer"YYCache"
                      |—— NSNetworkRequest  //网络请求封装，get、post、put、patch、delete，refer"AFNetworking"
                      |—— NSNetworkMonitor  //网络波动监听
</pre>
### 使用许可
`NSNetworkManager`使用[__MIT license__][3]协议，点击查看协议详情。
### 使用CocoaPods安装
> 1. 使用前请务必安装[__YYCache__][1]和[__AFNetworking__][2] <br/>
> 2. 执行'pod search "NSNetworkManager"' <br/>
> 3. 如果没有则是cocoapods版本不够新，执行'"pod update"'，之后重复步骤2操作。 <br/>
<pre>
 pod 'NSNetworkManager'
</pre>
### 使用示例:
- 使用前确保导入`NSNetworkManager.h`
#### 实时监听当前APP的网络状态
 - 遵守协议
 - 注册通知
 - 实现协议 
<pre>

@interface MonitoringNetworkController ()<NSNetworkMonitorProtocol> //遵守协议
@property (nonatomic,strong) NSString *radioAccess;
@end

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"实时监听网络状态";
    
    [NSNetworkMonitor registerNetworkNotification:self]; //注册通知
    
    //第一次网络状态并不会改变需先把当前的网络状态赋值给_radioAccess
    _radioAccess = [NSNetworkMonitor currentNetworkStatusString]; 
    [TSMessage showNotificationWithTitle:[NSString stringWithFormat:@"当前网络状态:%@",_radioAccess] type:TSMessageNotificationTypeWarning];
}

#pragma mark - 网络状态波动通知
-(void)networkStatusChangeNotification:(NSNotification *)notification
{
    _radioAccess = [NSNetworkMonitor currentNetworkStatusString];
    NSLog(@"%@\n%@",_radioAccess,notification);
    
    [TSMessage showNotificationWithTitle:[NSString stringWithFormat:@"当前网络状态:%@",_radioAccess]  type:TSMessageNotificationTypeWarning];
}
</pre>
#### 获取当前网络状态
<pre>
NSString *radioAccess = [NSNetworkMonitor currentNetworkStatusString];
//'radioAccess'输出结果为如下枚举的中文字符串:"无网络"、"Wifi"、"蜂窝网络"、"2G"、"3G"、"4G"、"未知网络";

/**
 * @brief 网络状态类型
 */
typedef NS_ENUM(NSUInteger,NSNetworkStatus){
    NSNetworkStatusNone = 0, //无网络
    NSNetworkStatusWifi, //Wifi网络
    NSNetworkStatusWWAN, //WWAN网络
    NSNetworkStatus2G, //2G网络
    NSNetworkStatus3G, //3G网络
    NSNetworkStatus4G, //4G网络
    NSNetworkStatusUnkonw //未知网络
};
</pre>
#### 常用的网络请求
 - GET
<pre>
    static NSString *const requestUrlString = @"http://api.budejie.com/api/api_open.php?a=category&c=subscribe";
    #define kPathCache   [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] //缓存路径

    [[NSNetworkRequest sharedInstance] GET:requestUrlString parameters:nil cacheMode:YES successBlock:^(id responseObject) {
        NSLog(@"%@\n缓存路径为:%@",responseObject,kPathCache);
      [TSMessage showNotificationWithTitle:@"GET请求成功,已缓存!" type:TSMessageNotificationTypeWarning];
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
      [TSMessage showNotificationWithTitle:@"GET请求失败" type:TSMessageNotificationTypeWarning];
    }];
</pre>
#### 上传一张或多张图片
<pre>
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
</pre>
#### 上传文件
<pre>

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
</pre>
#### 下载文件
<pre>
    static NSString *const downloadUrlString = @"http://sc1.111ttt.com/2017/4/05/10/298101104389.mp3"; //一首mp3

    [[NSNetworkRequest sharedInstance] downloadFileWithUrlString:downloadUrlString filedirectory:@"DownloadDirectory" progressBlock:^(NSProgress *progress) {
        CGFloat _progress = 100.f * progress.completedUnitCount / progress.totalUnitCount;
        NSLog(@"%.2f%%",_progress);
    } successBlock:^(NSString *filePatch) {
        NSLog(@"%@",filePatch);
        [TSMessage showNotificationWithTitle:@"下载成功" type:TSMessageNotificationTypeWarning];
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
         [TSMessage showNotificationWithTitle:@"下载成功" type:TSMessageNotificationTypeWarning];
    }];
</pre>
### [__简书__][4]

[1]: https://github.com/ibireme/YYCache "YYCache"
[2]: https://github.com/AFNetworking/AFNetworking "AFNetworking"
[3]: https://github.com/GREENBANYAN/NSNetworkManager/blob/master/LICENSE "MIT License"
[4]: http://www.jianshu.com/p/fb3999bb037a "简书"
