//
//  UploadPhotoManager.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/11.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "UploadPhotoManager.h"
NSString * const endPoint = @"https://oss-cn-beijing.aliyuncs.com";
OSSClient * client;

@interface UploadPhotoManager ()
@end
@implementation UploadPhotoManager
+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark ===开启上传环境====
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupEnvironment];
    }
    return self;
}

- (void)setupEnvironment {
    // 打开调试log
    [OSSLog enableLog];
    
    // 初始化sdk
    [self initOSSClient];
    
}

#pragma maek ===  初始化阿里云sdk====
- (void)initOSSClient{
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:@"LTAI4GJxrUzjbgfH6ye32kkf" secretKey:@"79y6zC8bfdtcpOyawDtjZkp1WW0b68"];
    client = [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:credential];
}

#pragma mark ==== 同步上传=====
- (void)uploadObjectAsyncWith:(NSData *)uploadData withObjectKey:(NSString *)objectKey withPhotoBlock:(PhotoBlock)photoBlock{
    
    _photoBlock = photoBlock;
    //上传请求类
    OSSPutObjectRequest * request = [OSSPutObjectRequest new];
    //文件夹名 后台给出
    request.bucketName = @"csthm";
    //objectKey为文件名 一般自己拼接
    request.objectKey = objectKey;
    //上传数据类型为NSData
    request.uploadingData = uploadData;
    WEAK_SELF
    OSSTask * putTask = [client putObject:request];
    [putTask continueWithBlock:^id(OSSTask *task) {
        
        if (!task.error) {
            
            //每次上传完一个文件都要回调
            NSLog(@"上传成功!");
            NSLog(@"打印:%@",task);
            NSLog(@"requestKEY:%@",request.objectKey);
            NSString * publicURL = nil;
            task = [client presignPublicURLWithBucketName:@"csthm"
                                            withObjectKey:request.objectKey];
            if (!task.error) {
                publicURL = task.result;
                
                NSLog(@"publicURL：%@",publicURL);
                emptyBlock(weak_self.photoBlock,publicURL);
            } else {
                NSLog(@"sign url error: %@", task.error);
            }
        } else {
            
            //每上传失败一个文件后都要回调
            NSLog(@"upload object failed, error: %@" ,task.error);
          
            
        }
        return nil;
    }];
    
       //同步上传（去掉就是异步）因为我上传的文件有多种包括音视频,图片。而且OSS这边是每上传成功一个文件都要回调一次。比如我成功上传5张图片，那么就要回调5次。所以这个时候我就无法判断文件是否都上传完成。所以我就把这些上传的文件放在调度组里面，这样所有文件上传成功后我这边就知道了。如果上传放在调度组里，那么这里的同步上传就必须加上。
    [putTask waitUntilFinished];
    
//    //上传进度
//    request.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
//
//        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
//
//    };
}

 

-(void)deleteObjectImageKey:(NSString *)objectKey{
    OSSDeleteObjectRequest * delete = [OSSDeleteObjectRequest new];
    delete.bucketName = @"csthm";
    //objectKey等同于objectName，表示从OSS删除文件时需要指定包含文件后缀在内的完整路径，例如abc/efg/123.jpg
    delete.objectKey = objectKey;

    OSSTask * deleteTask = [client deleteObject:delete];

    [deleteTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"打印:%@",task);
        }
        return nil;
    }];
    [deleteTask waitUntilFinished];
}

@end
