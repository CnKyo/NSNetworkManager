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

#import "NSNetworkRequest.h"
#import "NSNetworkCache.h"
#import <AFNetworking.h>

@implementation NSNetworkRequest NSNetworkSingletonM(Instance)

NSString *const DownloadDirectory = @"DownloadDirectory"; //下载目录

static const NSUInteger TIMEOUT = 15;
static AFHTTPSessionManager *manager;

+(void)startRequestWithUrlString:(NSString *)urlString
                      parameters:(NSDictionary *)parameters
                     requestType:(NSURLRequestType)requestType
                       cacheMode:(NSURLRequestCacheMode)cacheMode
                    successBlock:(SuccessBlock)successBlock
                    failureBlock:(FailureBlock)failureBlock{
    
    manager = [AFHTTPSessionManager manager]; //设置请求参数的类型
    [manager.requestSerializer setTimeoutInterval:TIMEOUT]; //设置请求的超时时间
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer]; //设置服务器返回结果的类型:JSON
    manager.operationQueue.maxConcurrentOperationCount = 4; //请求队列的最大并发数
#pragma mark - token设置
    [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"accesstoken"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/json",
                                                         @"text/javascript",
                                                         @"text/html",
                                                         @"text/plain", nil];
    //GET
    if (requestType == NSURLRequestTypeGet) {
        if (cacheMode == NSURLRequestCacheModeNone) {
            [manager GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                //
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                successBlock ? successBlock(responseObject) :nil;
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failureBlock ? failureBlock(error) : nil;
            }];
        }else{
            [manager GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                //
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                successBlock ? successBlock(responseObject) :nil;
                [NSNetworkCache saveDataCache:responseObject forkey:urlString];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                successBlock([NSNetworkCache readCache:urlString]);
            }];
        }
    }else if (requestType == NSURLRequestTypePost){
        //POST
        if (cacheMode == NSURLRequestCacheModeNone) {
            [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                //
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                successBlock ? successBlock(responseObject) :nil;
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failureBlock(error);
            }];
        }else{
            [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                //
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                successBlock(responseObject);
                [NSNetworkCache saveDataCache:responseObject forkey:urlString];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                successBlock([NSNetworkCache readCache:urlString]);
            }];
        }
    }else if (requestType == NSURLRequestTypePut){
        //PUT
        [manager PUT:urlString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            successBlock ? successBlock(responseObject) :nil;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failureBlock ? failureBlock(error) : nil;
        }];
    }else if (requestType == NSURLRequestTypePatch){
        //PATCH
        [manager PATCH:urlString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            successBlock ? successBlock(responseObject) :nil;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failureBlock ? failureBlock(error) : nil;
        }];
    }else if (requestType == NSURLRequestTypeDelete){
        //DELETE
        [manager DELETE:urlString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            successBlock(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failureBlock ? failureBlock(error) : nil;
        }];
    }
    
}

#pragma mark - GET
-(void)GET:(NSString *)urlString parameters:(NSDictionary *)parameters cacheMode:(NSURLRequestCacheMode)cacheMode successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [NSNetworkRequest startRequestWithUrlString:urlString
                                     parameters:parameters
                                    requestType:NSURLRequestTypeGet
                                      cacheMode:cacheMode
                                   successBlock:^(id responseObject) {
                                       successBlock ? successBlock(responseObject) :nil;
                                       [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                   } failureBlock:^(NSError *error) {
                                       failureBlock ? failureBlock(error) : nil;
                                       [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                   }];
}

#pragma mark - POST
-(void)POST:(NSString *)urlString parameters:(NSDictionary *)parameters cacheMode:(NSURLRequestCacheMode)cacheMode successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [NSNetworkRequest startRequestWithUrlString:urlString parameters:parameters requestType:NSURLRequestTypePost cacheMode:cacheMode successBlock:^(id responseObject) {
        successBlock ? successBlock(responseObject) :nil;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failureBlock:^(NSError *error) {
        failureBlock ? failureBlock(error) : nil;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

#pragma mark - PUT
-(void)PUT:(NSString *)urlString parameters:(NSDictionary *)parameters successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [NSNetworkRequest startRequestWithUrlString:urlString parameters:parameters requestType:NSURLRequestTypePut cacheMode:NSURLRequestCacheModeNone successBlock:^(id responseObject) {
        successBlock ? successBlock(responseObject) :nil;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failureBlock:^(NSError *error) {
        failureBlock ? failureBlock(error) : nil;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

#pragma mark - PATCH
-(void)PATCH:(NSString *)urlString parameters:(NSDictionary *)parameters successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [NSNetworkRequest startRequestWithUrlString:urlString parameters:parameters requestType:NSURLRequestTypePatch cacheMode:NSURLRequestCacheModeNone successBlock:^(id responseObject) {
        successBlock ? successBlock(responseObject) :nil;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failureBlock:^(NSError *error) {
        failureBlock ? failureBlock(error) : nil;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

#pragma mark - DELETE
-(void)DELETE:(NSString *)urlString parameters:(NSDictionary *)parameters successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [NSNetworkRequest startRequestWithUrlString:urlString parameters:parameters requestType:NSURLRequestTypeDelete cacheMode:NSURLRequestCacheModeNone successBlock:^(id responseObject) {
        successBlock ? successBlock(responseObject) :nil;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failureBlock:^(NSError *error) {
        failureBlock ? failureBlock(error) : nil;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

#pragma mark - 文件上传
-(void)uploadFileWithUrlString:(NSString *)urlString
                    parameters:(NSDictionary *)parameters
                stipulatedName:(NSString *)stipulatedName
                      filePath:(NSString *)filePath
                 progressBlock:(ProgressBlock)progressBlock
                  successBlock:(SuccessBlock)successBlock
                  failureBlock:(FailureBlock)failureBlock
{
    manager = [AFHTTPSessionManager manager]; //设置请求参数的类型
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSError *error = nil;
        [formData appendPartWithFileURL:[NSURL URLWithString:filePath] name:stipulatedName error:&error];
        (failureBlock && error) ? failureBlock(error) : nil;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progressBlock ? progressBlock(uploadProgress) : nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock ? successBlock(responseObject) :nil;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock ? failureBlock(error) : nil;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

#pragma mark - 文件下载
-(void)downloadFileWithUrlString:(NSString *)urlString
                   filedirectory:(NSString *)filedirectory
                   progressBlock:(ProgressBlock)progressBlock
                    successBlock:(void(^)(NSString *filePatch))successBlock
                    failureBlock:(FailureBlock)failureBlock
{
    manager = [AFHTTPSessionManager manager]; //设置请求参数的类型
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    __block NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        progressBlock ? progressBlock(downloadProgress) : nil;
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //拼接缓存目录
        NSString *savedDirectoty = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]  stringByAppendingPathComponent:filedirectory ? filedirectory : DownloadDirectory];
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //创建Download目录
        [fileManager createDirectoryAtPath:savedDirectoty withIntermediateDirectories:YES attributes:nil error:nil];
        //拼接文件路径
        NSString *filePath = [savedDirectoty stringByAppendingPathComponent:response.suggestedFilename];
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (failureBlock && error) {failureBlock(error); return ;};
        successBlock ? successBlock(filePath.absoluteString) : nil;
    }];
    //开始下载
    [downloadTask resume];
}

#pragma mark - 图片上传
-(void)uploadImagesWithUrlString:(NSString *)urlString
                      parameters:(NSDictionary *)parameters
                  stipulatedName:(NSString*)stipulatedName
                          images:(NSArray<UIImage *> *)images
                       fileNames:(NSArray<NSString *> *)fileNames
                   compressFloat:(CGFloat)compressFloat
                     imageFormat:(NSString *)imageFormat
                   progressBlock:(ProgressBlock)progressBlock
                    successBlock:(SuccessBlock)successBlock
                    failureBlock:(FailureBlock)failureBlock{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    manager = [AFHTTPSessionManager manager]; //设置请求参数的类型
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        ///==================
        for (NSInteger i = 0; i < images.count; i++) {
            NSData *data = UIImageJPEGRepresentation(images[i], compressFloat ? :1.f);
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSString *string = [NSString stringWithFormat:@"%@%ld.%@",[formatter stringFromDate:[NSDate date]],i,imageFormat?:@"jpg"];
            
            [formData appendPartWithFileData:data name:stipulatedName fileName:fileNames?[NSString stringWithFormat:@"%@.%@",fileNames[i],imageFormat?:@"jpg"]:string mimeType:[NSString stringWithFormat:@"image/%@",imageFormat ?:@"jpg"]];
        }
        //=================;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progressBlock(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock ? successBlock(responseObject) :nil;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock ? failureBlock(error) : nil;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

@end
