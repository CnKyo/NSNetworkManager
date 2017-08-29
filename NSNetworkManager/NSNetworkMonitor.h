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

#import <Foundation/Foundation.h>
#import "NSNetworkSingleton.h"
#import "NSNetworkStatus.h"
#import "NSNetworkProtocol.h"
#import "Reachability.h"

@interface NSNetworkMonitor : NSObject NSNetworkSingletonH(Instance)

/**
 * @brief 当前网络状态枚举
 */
+(NSNetworkStatus)currentNetworkStatus;

/**
 * @brief 当前网络状态枚举字符串
 */
+(NSString *)currentNetworkStatusString;

+(void)registerNetworkNotification:(id<NSNetworkMonitorProtocol>)listener;
+(void)removeNetworkNotification:(id<NSNetworkMonitorProtocol>)listener;

/**
 * @brief 网络状态波动通知
 */
//extern NSString *const NSNetworkStatusChangeNotification;

@end
