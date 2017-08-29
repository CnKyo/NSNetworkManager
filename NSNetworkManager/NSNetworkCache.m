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

#import "NSNetworkCache.h"
#import <YYCache.h>

@implementation NSNetworkCache NSNetworkSingletonM(Instance)

static NSString *const CacheDirectory = @"CacheDirectory"; //缓存目录
static YYCache * _yyCache;

+(void)initialize{
    _yyCache = [[YYCache alloc]initWithName:CacheDirectory];
}

#pragma mark - 保存数据到缓存
+(void)saveDataCache:(id)data forkey:(NSString *)key;{
    [_yyCache setObject:data forKey:key]; //默认会开启线程缓存
}

#pragma mark - 读取缓存
+(id)readCache:(NSString *)key{
    return [_yyCache objectForKey:key];
}

#pragma mark - 获取缓存大小
+(NSString *)getCacheSize{
    
    unsigned long long diskCache = [_yyCache.diskCache totalCost]; //总大小
    
    NSString * sizeText = nil;
    
    if (diskCache >= pow(10, 9)) {
        // size >= 1GB
        sizeText = [NSString stringWithFormat:@"%.2fGB", diskCache / pow(10, 9)];
    } else if (diskCache >= pow(10, 6)) { // 1GB > size >= 1MB
        sizeText = [NSString stringWithFormat:@"%.2fMB", diskCache / pow(10, 6)];
    } else if (diskCache >= pow(10, 3)) { // 1MB > size >= 1KB
        sizeText = [NSString stringWithFormat:@"%.2fKB", diskCache / pow(10, 3)];
    } else { // 1KB > size
        sizeText = [NSString stringWithFormat:@"%zdB", diskCache];
    }
    
    return sizeText;
}

#pragma mark - 通过key查询是否缓存
+(BOOL)isCached:(NSString *)key{
    return [_yyCache containsObjectForKey:key];
}

#pragma mark - 通过key删除其所占缓存
+(void)removeCacheFrom:(NSString *)key{
    [_yyCache removeObjectForKey:key withBlock:nil];
}

#pragma mark - 清除所有缓存
+(void)removeAllCache{
    [_yyCache removeAllObjects];
}

@end
