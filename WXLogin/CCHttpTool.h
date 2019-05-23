//
//  CCHttpTool.h
//  goTele
//
//  Created by 橙子 on 2017/4/5.
//  Copyright © 2017年 刘成城. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCHttpTool : NSObject
/**
 *发送get请求
 * urlstring 请求的基本的url
 *parameters 请求的参数字典
 * success 请求成功的回调
 *failure 请求失败的回调
 */
+(void)GET:(NSString *)URLString
parameters:(id)parameters
   success:(void (^)( id responseObject))success
   failure:(void (^)( id error))failure;


//Tan通用get
+(void)TanGET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(id))failure;
//Tan通用post
+(void)TanPOST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(id))failure;
/**
 *发送post请求
 * urlstring 请求的基本的url
 *parameters 请求的参数字典
 * success 请求成功的回调
 *failure 请求失败的回调
 */
+(void)POST:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)( id responseObject))success
    failure:(void (^)( id error))failure;



/**
 *发送给Liucc服务器的post请求
 * urlstring 请求的基本的url
 *parameters 请求的参数字典
 * success 请求成功的回调
 *failure 请求失败的回调
 */
+(void)LiuccPOST:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)( id responseObject))success
    failure:(void (^)( id error))failure;

/**
 *OSS服务器上传图片
 * urlstring 请求的基本的url
 *parameters 请求的参数字典
 * success 请求成功的回调
 *failure 请求失败的回调
 */

//+ (void)postOSSImageKeybucketName:(NSString *)oss_access_key_id url:(NSString *)urlstr policy:(NSString *)policy Signature:(NSString *)signature;

/**
 post方法上传文件到OSS服务器

 @param url OSSHost
 @param fileName 组装完成的文件名
 @param filePath 本地文件路径
 @param success 成功回调
 @param fail 失败回调
 */
+(void)postOSSFileWithUrl:(NSString*)url fileName:(NSString*)fileName filePath:(NSString*)filePath fileData:(NSData*)fileData success:(void (^)(id obj))success fail:(void (^)(NSError *error))fail;
//+(void)


/**
 获得文件mimeType类型

 @param PathExtension 文件后缀
 @return 返回类型
 */
+ (NSString *)mimeTypeForFileAtPathExtension:(NSString *)PathExtension;


/**
 上传ZIP文件

 @param URLString url
 @param parameters 路径
 @param completionHandler 结果回调
 */
+ (void)upLoadZIPDataWithUrlString:(NSString *)URLString ZipName:(NSString *)zipName zipPath:(NSString*)zipPath parameters:(id)parameters completionHandler:(void (^)(id responseObject, NSError *error))completionHandler;


+(NSDictionary *)testUrlString:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(id))failure;

#pragma mark - 检测网路状态

@end


@interface WYHttpFile : NSObject

/** 文件参数名 */
@property (nonatomic, copy) NSString *name;
/** 文件数据 */
@property (nonatomic, strong) NSData *data;
/** 文件类型 */
@property (nonatomic, copy) NSString *mimeType;
/** 文件名 */
@property (nonatomic, copy) NSString *filename;

+ (instancetype)fileWithName:(NSString *)name data:(NSData *)data mimeType:(NSString *)mimeType filename:(NSString *)filename;

@end

