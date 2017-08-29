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
#import <UIKit/UIKit.h>
#import "NSNetworkSingleton.h"
#import "NSNetworkStatus.h"

@interface NSNetworkRequest : NSObject NSNetworkSingletonH(Instance)

/**
 * @brief GET请求
 */
-(void)GET:(NSString *)urlString parameters:(NSDictionary *)parameters cacheMode:(NSURLRequestCacheMode)cacheMode successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 * @brief POST请求
 */
-(void)POST:(NSString *)urlString parameters:(NSDictionary *)parameters cacheMode:(NSURLRequestCacheMode)cacheMode successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 * @brief PUT请求
 */
-(void)PUT:(NSString *)urlString parameters:(NSDictionary *)parameters successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 * @brief PATCH请求
 */
-(void)PATCH:(NSString *)urlString parameters:(NSDictionary *)parameters successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 * @brief DELETE请求
 */
-(void)DELETE:(NSString *)urlString parameters:(NSDictionary *)parameters successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 * @brief 文件上传
 */
-(void)uploadFileWithUrlString:(NSString *)urlString
                    parameters:(NSDictionary *)parameters
                stipulatedName:(NSString *)stipulatedName
                      filePath:(NSString *)filePath
                 progressBlock:(ProgressBlock)progressBlock
                  successBlock:(SuccessBlock)successBlock
                  failureBlock:(FailureBlock)failureBlock;

/**
 * @brief 文件下载
 */
-(void)downloadFileWithUrlString:(NSString *)urlString
                   filedirectory:(NSString *)filedirectory
                   progressBlock:(ProgressBlock)progressBlock
                    successBlock:(void(^)(NSString *filePatch))successBlock
                    failureBlock:(FailureBlock)failureBlock;

/**
 * @brief 图片上传
 */
-(void)uploadImagesWithUrlString:(NSString *)urlString
                      parameters:(NSDictionary *)parameters
                  stipulatedName:(NSString*)stipulatedName
                          images:(NSArray<UIImage *> *)images
                       fileNames:(NSArray<NSString *> *)fileNames
                   compressFloat:(CGFloat)compressFloat
                     imageFormat:(NSString *)imageFormat
                   progressBlock:(ProgressBlock)progressBlock
                    successBlock:(SuccessBlock)successBlock
                    failureBlock:(FailureBlock)failureBlock;

@end
