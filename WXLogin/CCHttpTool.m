//
//  CCHttpTool.m
//  goTele
//
//  Created by 橙子 on 2017/4/5.
//  Copyright © 2017年 刘成城. All rights reserved.
//

#import "CCHttpTool.h"


@implementation CCHttpTool

static BOOL isShow;



////通用post
//+(void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(id))failure
//{
//    //非登录接口 切需要登录 直接跳登录界面不继续z执行
//    if (kGlobalNetworkUtil.isShowLoginVC && ![URLString isEqualToString:apiLoginUrl]) {
//        return;
//    }
//    
////    [[IQKeyboardManager sharedManager] resignFirstResponder];
//
//
//    AFHTTPSessionManager *session = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
//
//    session.requestSerializer.timeoutInterval = 15;
//
//    
//    NSMutableDictionary *params = [parameters mj_keyValues];
//    if (![URLString isEqualToString:apiLoginUrl]) {
//        [session.requestSerializer setValue:kUserInfoModel.token forHTTPHeaderField:@"token"];
//    }
//    
//    [session POST:URLString parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//
//        if ([responseObject[@"code"] integerValue] == 0) {
//            if (success) {
//                success(responseObject);
//            }
//        }else{
//            [SVProgressHUD showInfoWithStatus:responseObject[@"msg"]];
//        }
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
////        [SVProgressHUD dismiss];
//        NSLog(@"%@",error);
//        if (failure) {
//            failure(error);
//        }
//        
//        [CCHttpTool showAlertWithError:error];
//    }];
//    
//    
//}
//
////通用get
//+(void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(id))failure
//{
//    
//    if (kGlobalNetworkUtil.isShowLoginVC && ![URLString isEqualToString:apiLoginUrl]) {
//        return;
//    }
//    
//    AFHTTPSessionManager *session = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
//
//    
//    NSMutableDictionary *params = [parameters mj_keyValues];
//    if (![URLString isEqualToString:apiLoginUrl]) {
//        [session.requestSerializer setValue:kUserInfoModel.token forHTTPHeaderField:@"token"];
//    }
//    
//    [session GET:URLString
//      parameters:params progress:nil success:^(NSURLSessionDataTask * task, id responseObject) {
//          [SVProgressHUD dismiss];
//          if ([responseObject[@"code"] integerValue] == 0) {
//              if (success) {
//                  success(responseObject);
//              }
//          }else{
//              [SVProgressHUD showInfoWithStatus:responseObject[@"msg"]];
//          }
//          
//      } failure:^(NSURLSessionDataTask * task, NSError * error) {
////          [SVProgressHUD dismiss];
//          NSLog(@"%@",error);
//          if (failure) {
//              failure(error);
//          }
//          [CCHttpTool showAlertWithError:error];
//      }];
//}
////Tan通用post
//+(void)TanPOST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(id))failure
//{
//    //非登录接口 切需要登录 直接跳登录界面不继续z执行
//    if (kGlobalNetworkUtil.isShowLoginVC && ![URLString isEqualToString:apiLoginUrl]) {
//        return;
//    }
////    [[IQKeyboardManager sharedManager] resignFirstResponder];
//    AFHTTPSessionManager *session = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
//    session.requestSerializer.timeoutInterval = 15;
//
////    NSMutableDictionary *params = [parameters mj_keyValues];
////    if (![URLString isEqualToString:apiLoginUrl]) {
////        [params setValue:kUserInfoModel.token forKey:@"token"];
////    }
//    NSMutableDictionary *params = [parameters mj_keyValues];
//    //    if (![URLString isEqualToString:apiLoginUrl]) {
//    //        [params setValue:kUserInfoModel.token forKey:@"token"];
//    //    }
//    
//    //向请求头中添加参数
//    [session.requestSerializer setValue:kUserInfoModel.token forHTTPHeaderField:@"token"];
//    [session POST:URLString parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        [SVProgressHUD dismiss];
//        if ([responseObject[@"code"] integerValue]!=0) {
//            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
//        }
//        else
//        {
//        if (success) {
//            success(responseObject);
//        }
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                [SVProgressHUD dismiss];
//        NSLog(@"%@",error);
//        if (failure) {
//            failure(error);
//        }
//        [CCHttpTool showAlertWithError:error];
//    }];
//}
////Tan通用get
//+(void)TanGET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(id))failure
//{
//    
//    if (kGlobalNetworkUtil.isShowLoginVC && ![URLString isEqualToString:apiLoginUrl]) {
//        return;
//    }
//    
//    AFHTTPSessionManager *session = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
//  
//    
//    NSMutableDictionary *params = [parameters mj_keyValues];
//    if (![URLString isEqualToString:apiLoginUrl]) {
//        [session.requestSerializer setValue:kUserInfoModel.token forHTTPHeaderField:@"token"];
//    }
//    
//    //向请求头中添加参数
////    [session.requestSerializer setValue:kUserInfoModel.token forHTTPHeaderField:@"token"];
//    [session GET:URLString
//      parameters:params progress:nil success:^(NSURLSessionDataTask * task, id responseObject) {
//          [SVProgressHUD dismiss];
//          responseObject=[ToolsClass setValuesForKeysWithDictionary:responseObject];
//          if ([responseObject[@"code"] integerValue] == 0) {
//              if (success) {
//                  success(responseObject);
//              }
//          }else{
//              [SVProgressHUD showInfoWithStatus:responseObject[@"msg"]];
//          }
//          
//      } failure:^(NSURLSessionDataTask * task, NSError * error) {
//                    [SVProgressHUD dismiss];
//          NSLog(@"%@",error);
//          if (failure) {
//              failure(error);
//          }
//          [CCHttpTool showAlertWithError:error];
//      }];
//}
//
////用于liucc服务器的网络请求
//+(void)LiuccPOST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(id))failure
//{
//    if (!URLString) {
//        URLString = @"";
//    }
////    [[IQKeyboardManager sharedManager] resignFirstResponder];
//    //    [SVProgressHUD showWithStatus:@"..."];
//    
//    AFHTTPSessionManager *session = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString: @"http://www.liucc.cn:8181/api"]];
//
//    session.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html", @"text/plain", @"text/json", @"text/javascript", @"application/json"]];
//    
//    session.requestSerializer.timeoutInterval = 15;
//    
//    
//    NSMutableDictionary *params = [parameters mj_keyValues];
//    [session POST:URLString parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//
//        NSLog(@"%@",responseObject);
//        
//        
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [SVProgressHUD dismiss];
//        NSLog(@"%@",error);
//        if (failure) {
//            failure(error);
//        }
//        
//        [CCHttpTool showAlertWithError:error];
//    }];
//}
//
//
//
//#pragma mark--上传图片到OSS
////从后台拿到oss_access_key_id，urlstr，policy，signature
//- (void)getAccessTokenFromOSS{
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
//    
//    //    MySessionManager *manager = [MySessionManager manager];
//    //    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//    //    AppDelegate * appdegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    //    [dic setValue:appdegate.access_token        forKey:@"access_token"];
//    //    [dic setValue:@"6000" forKey:@"duration"];
//    //    NSString *url = [NSString stringWithFormat:@"%@/oss_access_token",URL_FACE];
//    //    [manager POST:url parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//    //        FaceModel *model = [RMMapper objectWithClass:[FaceModel class] fromDictionary:responseObject ];
//    //        [self postOSSImageKeybucketName:model.oss_access_key_id url:model.url policy:model.policy Signature:model.signature];
//    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//    //
//    //    }];
//}
//
//+(void)postOSSFileWithUrl:(NSString*)url fileName:(NSString*)fileName filePath:(NSString*)filePath fileData:(NSData*)fileData success:(void (^)(id obj))success fail:(void (^)(NSError *error))fail{
//    
//    if (!url) {
//       url = kOSSInfoDict[@"host"];
//    }
//    NSString *accessid = kOSSInfoDict[@"accessid"];
//    NSString *policy = kOSSInfoDict[@"policy"];
//    NSString *signature = kOSSInfoDict[@"signature"];
////    NSString *dir = kOSSInfoDict[@"dir"];
//
//    // 文件二进制文件
//    if (!fileData) {
//        fileData = [NSData dataWithContentsOfFile:filePath];
//    }
//    fileName = [kOSSInfoDict[@"dir"] stringByAppendingPathComponent:fileName];
//    
//    //4. 发起网络请求
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//    [dic setValue:accessid          forKey:@"OSSAccessKeyId"];
//    [dic setValue:policy            forKey:@"policy"];
//    [dic setValue:signature         forKey:@"Signature"];
//    [dic setValue:fileName          forKey:@"key"];
//    [dic setValue:fileData         forKey:@"file"];
//    
//    [self OSSNetworkWithURL:url parameter:dic success:^(id obj) {
//        if (success) {
//            success(obj);
//        }
//    } fail:^(NSError *error) {
//        if (fail) {
//            fail(error);
//        }
//    }];
//}
//
////OSS文件上传
//+ (void)OSSNetworkWithURL:(NSString *)url parameter:(NSDictionary *)paraDic success:(void (^)(id obj))success fail:(void (^)(NSError *error))fail {
//    
//    
//    //分界线的标识符
//    NSString *TWITTERFON_FORM_BOUNDARY = @"9431149156168";
//    //根据url初始化request
//    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
//                                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
//                                                        timeoutInterval:10];
//    //分界线 --AaB03x
//    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
//    //结束符 AaB03x--
//    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
//  
//    
//    //得到文件的data、name
//    NSData *fileData = paraDic[@"file"];
//    NSString *fileName = paraDic[@"key"];
//    NSString *ContentType = [self mimeTypeForFileAtPathExtension:[fileName pathExtension]];
//    
//    YYLog(@"OSSSend fileLength:%ld,fileName:%@,ContentType:%@",fileData.length,fileName,ContentType);
//    //http body的字符串
//    NSMutableString *body=[[NSMutableString alloc]init];
//    //参数的集合的所有key的集合
//    NSArray *keys= [paraDic allKeys];
//    //遍历keys
//    for(int i=0;i<[keys count];i++)
//    {
//        //得到当前key
//        NSString *key=[keys objectAtIndex:i];
//        //如果key不是pic，说明value是字符类型，比如name：Boris
//        if (![key isEqualToString:@"file"]) {
//            //添加分界线，换行
//            [body appendFormat:@"%@\r\n",MPboundary];
//            //添加字段名称，换2行
//            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
//            //添加字段的值
//            [body appendFormat:@"%@\r\n",[paraDic objectForKey:key]];
//        }
//        
//    }
//    ////添加分界线，换行
//    [body appendFormat:@"%@\r\n",MPboundary];
//    //声明pic字段，文件名为boris.png
//    [body appendFormat:@"%@", [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n",fileName]];
//    //声明上传文件的格式
//    [body appendFormat:@"Content-Type: %@\r\n\r\n",ContentType];
//    
//    //声明结束符：--AaB03x--
//    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
//    //声明myRequestData，用来放入http body
//    NSMutableData *myRequestData=[NSMutableData data];
//    //将body字符串转化为UTF8格式的二进制
//    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
//    //将file的data加入
//    [myRequestData appendData:fileData];
//    //加入结束符--AaB03x--
//    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    //设置HTTPHeader中Content-Type的值
//    NSString *content = [[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
//    //设置HTTPHeader
//    [request setValue:content forHTTPHeaderField:@"Content-Type"];
//    //设置Content-Length
//    [request setValue:[NSString stringWithFormat:@"%d", (int)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
//    //设置http body
//    [request setHTTPBody:myRequestData];
//    //http method
//    [request setHTTPMethod:@"POST"];
//    //连接(NSURLSession)
//    NSURLSession *session=[NSURLSession sharedSession];
//    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (error) {
//            YYLog(@"error:%@",error);
////            YYLog(@"response:%ld",response.statusCode);
//            if (fail){
//                fail(error);
//            }
//            
//        } else {
//            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            YYLog(@"body:%@ data:%@", str,data);
//            if (success) {
//                success(str);
//            }
//            YYLog(@"response:%ld",((NSHTTPURLResponse*)response).statusCode);
//            
//        }
//      
//        
//    }];
//    [dataTask resume];
//    
//}
//
//
//+ (NSString *)mimeTypeForFileAtPathExtension:(NSString *)PathExtension
//{
//    //    if (![[[NSFileManager alloc] init] fileExistsAtPath:path]) {
//    //        return nil;
//    //    }
//    
//    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)PathExtension, NULL);
//    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
//    CFRelease(UTI);
//    if (!MIMEType) {
//        return @"application/octet-stream";
//    }
//    return (__bridge NSString *)(MIMEType);
//}
//
//+ (void)showAlertWithError:(NSError *)error
//{
//    if (isShow) {
//        return;
//    }
////    isShow = YES;
////    //如果请求超时的话
////    if (error.code == -1001) {
////        [UIAlertTool showAlertViewWithTitle:@"亲" message:@"网速不给力哦!" cancelButtonTitle:@"确定" otherButtonTitle:nil confirm:nil cancle:nil];
////    }
////    //如果断网的话
////    if (error.code == -1009) {
////        [UIAlertTool showAlertViewWithTitle:@"亲" message:@"木有联网哦!" cancelButtonTitle:@"确定" otherButtonTitle:nil confirm:nil cancle:nil];
////    }
////    //如果服务器挂了的话
////    if (error.code == -1004) {
////        [UIAlertTool showAlertViewWithTitle:@"抱歉" message:@"服务器异常！" cancelButtonTitle:@"确定" otherButtonTitle:nil confirm:nil cancle:nil];
////    }
//}
//
//#pragma mark 检测网路状态
//+ (void)netWorkStatusReachable:(void (^)(AFNetworkReachabilityStatus status))StatusChangeBlock
//{
//    /**
//     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
//     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
//     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
//     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // WiFi
//     */
//    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
//    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
//    
//    // 检测网络连接的单例,网络变化时的回调方法
//    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        if (StatusChangeBlock) {
//            StatusChangeBlock(status);
//        }
////        if (status == AFNetworkReachabilityStatusNotReachable) {
////            if (reachable) {
////                reachable(NO);
////            }
////        } else {
////            if (reachable) {
////                reachable(YES);
////            }
////        }
//    }];
//}
//
//
//+ (void)upLoadDataWithUrlString:(NSString *)URLString parameters:(id)parameters completionHandler:(void (^)(id responseObject, NSError *error))completionHandler{
//    
//    [SVProgressHUD showWithStatus:@"正在上传.."];
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
//    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html", @"text/plain", @"text/json", @"text/javascript", @"application/json"]];
//    manager.requestSerializer.timeoutInterval = 30;
//    
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    
//    
//    
//    [manager POST:URLString parameters:@{@"name":@"pic",@"type":@"file"} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"YYYYMMddHHmmss"];
//        NSString *fileName = [dateFormatter stringFromDate:[NSDate date]];
//        
//        [formData appendPartWithFileData:parameters name:@"pic" fileName:[fileName stringByAppendingString:@".png"] mimeType:@"image/png"];
//        
//    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        
//        [SVProgressHUD dismiss];
//        if (completionHandler) {
//            completionHandler(responseObject, nil);
//        }
//        
//    } failure:^(NSURLSessionDataTask * task, NSError * error) {
//        [SVProgressHUD dismiss];
//        if (completionHandler) {
//            completionHandler(nil, error);
//        }
//        NSLog(@"error %@", error);
//    }];
//    
//}
//
//+ (void)upLoadZIPDataWithUrlString:(NSString *)URLString ZipName:(NSString *)zipName zipPath:(NSString*)zipPath parameters:(id)parameters completionHandler:(void (^)(id responseObject, NSError *error))completionHandler{
//    
////    [SVProgressHUD showWithStatus:@"正在上传..."];
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
//    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html", @"text/plain", @"text/json", @"text/javascript", @"application/json"]];
//    manager.requestSerializer.timeoutInterval = 30;
//    
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    
//    
//    
//    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//
//        
//        [formData appendPartWithFileData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@",zipPath]] name:@"line_data" fileName:zipName mimeType:@"application/zip"];
//
//        
//    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        
//        [SVProgressHUD dismiss];
//        if (completionHandler) {
//            completionHandler(responseObject, nil);
//        }
//        
//    } failure:^(NSURLSessionDataTask * task, NSError * error) {
//        [SVProgressHUD dismiss];
//        if (completionHandler) {
//            completionHandler(nil, error);
//        }
//        NSLog(@"error %@", error);
//    }];
//    
//}
//
//
//+(NSDictionary *)testUrlString:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(id))failure
//{
//
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
//
//    // 创建一个信号量为0的信号(红灯)
//    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
//
//    NSLog(@"开始请求");
//    __block NSDictionary *returnDict;
//    
//    [manager POST:urlStr parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        NSLog(@"请求成功:allKeysCount:%ld",[responseObject allKeys].count);
//        returnDict = responseObject;
//        // 使信号的信号量+1，这里的信号量本来为0，+1信号量为1(绿灯)
//        dispatch_semaphore_signal(sema);
//
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error%@",error);
//        // 使信号的信号量+1，这里的信号量本来为0，+1信号量为1(绿灯)
//        dispatch_semaphore_signal(sema);
//
//    }];
//    
//
//    // 开启信号等待，设置等待时间为永久，直到信号的信号量大于等于1（绿灯）
//    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//    NSLog(@"请求结束,返回数据");
//
//    return returnDict;
//}
//
//@end
//@implementation WYHttpFile
//
//+ (instancetype)fileWithName:(NSString *)name data:(NSData *)data mimeType:(NSString *)mimeType filename:(NSString *)filename
//{
//    WYHttpFile *file = [[self alloc] init];
//    file.name = name;
//    file.data = data;
//    file.mimeType = mimeType;
//    file.filename = filename;
//    return file;
//}



@end

