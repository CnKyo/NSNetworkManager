// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "NSNetworkMonitor.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

static NSString *const NSNetworkStatusChangedNotification = @"NSNetworkStatusChangedNotification"; //网络状态变动通知名称

@interface NSNetworkMonitor ()
@property (nonatomic,strong) NSArray *telephoneNetworkInfo2GArray;
@property (nonatomic,strong) NSArray *telephoneNetworkInfo3GArray;
@property (nonatomic,strong) NSArray *telephoneNetworkInfo4GArray;
@property (nonatomic,strong) NSArray *telephoneNetworkStatusStringArray;
@property (nonatomic,getter=isMonitor) BOOL Monitor; //是否监听
@property (nonatomic,strong) CTTelephonyNetworkInfo *telephonyNetworkInfo;
@property (nonatomic,strong) Reachability *reachability;
@property (nonatomic,copy) NSString *currentRadioAccess; //当前网络访问属性
@end

@implementation NSNetworkMonitor NSNetworkSingletonM(Instance)

+(void)initialize{
    NSNetworkMonitor *monitor = [NSNetworkMonitor sharedInstance];
    monitor.telephonyNetworkInfo = [[CTTelephonyNetworkInfo alloc]init];
}

#pragma mark - 当前网络状态枚举
+(NSNetworkStatus)currentNetworkStatus{
    NSNetworkMonitor *monitor = [NSNetworkMonitor sharedInstance];
    return [monitor statusWithRadioAccessTechnology];
}

#pragma mark - 当前网络状态枚举字符串
+(NSString *)currentNetworkStatusString{
    NSNetworkMonitor *monitor = [NSNetworkMonitor sharedInstance];
    return monitor.telephoneNetworkStatusStringArray[[self currentNetworkStatus]];
}

- (NSNetworkStatus)statusWithRadioAccessTechnology
{
    NSNetworkStatus status = (NSNetworkStatus)[self.reachability currentReachabilityStatus];
    
    NSString *radioAccess = self.currentRadioAccess;
    
    if (status == NSNetworkStatusWWAN && radioAccess != nil) {
        
        if ([self.telephoneNetworkInfo2GArray containsObject:radioAccess]){
            
            status = NSNetworkStatus2G;
            
        }else if ([self.telephoneNetworkInfo3GArray containsObject:radioAccess])
            
            status = NSNetworkStatus3G;
        
        else if ([self.telephoneNetworkInfo4GArray containsObject:radioAccess]){
            
            status = NSNetworkStatus4G;
        }
    }
    
    return status;
}

#pragma mark - 注册监听网络波动通知
+(void)registerNetworkNotification:(id<NSNetworkMonitorProtocol>)listener
{
    NSNetworkMonitor *monitor = [NSNetworkMonitor sharedInstance];
    
    monitor.isMonitor == YES ?[self removeNetworkNotification:(id<NSNetworkMonitorProtocol>)listener]:nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:listener selector:@selector(networkStatusChangeNotification:) name:NSNetworkStatusChangedNotification object:monitor];
    [[NSNotificationCenter defaultCenter] addObserver:monitor selector:@selector(networkStatusChangedNotification:) name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:monitor selector:@selector(networkStatusChangedNotification:) name:CTRadioAccessTechnologyDidChangeNotification object:nil];
    
    [monitor.reachability startNotifier];
    
    monitor.Monitor = YES;
}
#pragma mark - 移除监听网络波动通知
+(void)removeNetworkNotification:(id<NSNetworkMonitorProtocol>)listener
{
    NSNetworkMonitor *monitor = [NSNetworkMonitor sharedInstance];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:listener name:NSNetworkStatusChangedNotification object:monitor];
    [[NSNotificationCenter defaultCenter] removeObserver:monitor name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:monitor name:CTRadioAccessTechnologyDidChangeNotification object:nil];
    
    monitor.Monitor = NO;
}
#pragma mark - 网络变动通知
-(void)networkStatusChangedNotification:(NSNotification *)notification
{
    if (notification.name == CTRadioAccessTechnologyDidChangeNotification && notification.object != nil) {
        self.currentRadioAccess = self.telephonyNetworkInfo.currentRadioAccessTechnology;
    }
    
    NSDictionary *userInfo = @{@"NSNetworkStatus":@([NSNetworkMonitor currentNetworkStatus]),
                               @"NSNetworkStatusString":[NSNetworkMonitor currentNetworkStatusString]};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NSNetworkStatusChangedNotification object:self userInfo:userInfo];
}
#pragma mark - 懒加载
-(Reachability *)reachability{
    if (_reachability == nil) {
        _reachability = [Reachability reachabilityForInternetConnection];
    }
    return _reachability;
}

-(CTTelephonyNetworkInfo *)telephonyNetworkInfo{
    if (_telephonyNetworkInfo == nil) {
        _telephonyNetworkInfo = [[CTTelephonyNetworkInfo alloc]init];
    }
    return _telephonyNetworkInfo;
}
//2G标签数组
-(NSArray *)telephoneNetworkInfo2GArray{
    if (_telephoneNetworkInfo2GArray == nil) {
        _telephoneNetworkInfo2GArray = @[CTRadioAccessTechnologyEdge,CTRadioAccessTechnologyGPRS];
    }
    return _telephoneNetworkInfo2GArray;
}
//3G标签数组
-(NSArray *)telephoneNetworkInfo3GArray{
    if (_telephoneNetworkInfo3GArray == nil) {
        _telephoneNetworkInfo3GArray = @[CTRadioAccessTechnologyHSDPA,
                      CTRadioAccessTechnologyWCDMA,
                      CTRadioAccessTechnologyHSUPA,
                      CTRadioAccessTechnologyCDMA1x,
                      CTRadioAccessTechnologyCDMAEVDORev0,
                      CTRadioAccessTechnologyCDMAEVDORevA,
                      CTRadioAccessTechnologyCDMAEVDORevB,
                      CTRadioAccessTechnologyeHRPD];
    }
    return _telephoneNetworkInfo3GArray;
}
//4G标签数组
-(NSArray *)telephoneNetworkInfo4GArray{
    if (_telephoneNetworkInfo4GArray ==  nil) {
        _telephoneNetworkInfo4GArray = @[CTRadioAccessTechnologyLTE];
    }
    return _telephoneNetworkInfo4GArray;
}
//状态标签数组中文
-(NSArray *)telephoneNetworkStatusStringArray{
    if (_telephoneNetworkStatusStringArray == nil) {
        _telephoneNetworkStatusStringArray = @[@"无网络",@"Wifi",@"蜂窝网络",@"2G",@"3G",@"4G",@"未知网络"];
    }
    return _telephoneNetworkStatusStringArray;
}

@end
