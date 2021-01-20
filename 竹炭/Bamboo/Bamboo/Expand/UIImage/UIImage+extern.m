//
//  UIImage+extern.m
//  YilidiSeller
//
//  Created by yld on 16/3/29.
//  Copyright © 2016年 Dellidc. All rights reserved.
//

#import "UIImage+extern.h"
#import <Photos/Photos.h>
@implementation UIImage (Extern)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size alpha:(float)alpha
{
    @autoreleasepool {
        
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        
        UIGraphicsBeginImageContext(rect.size);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetAlpha(context, alpha);
        CGContextSetFillColorWithColor(context,color.CGColor);
        CGContextFillRect(context, rect);
        
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return img;
        
    }
}

+ (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
- (UIImage *)imageScaledToSize:(CGSize)size
{
    @autoreleasepool {
        //avoid redundant drawing
        if (CGSizeEqualToSize(self.size, size))
        {
            return self;
        }
        
        //create drawing context
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
        
        //draw
        [self drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
        
        //capture resultant image
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //return image
        return image;
    }
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize

{
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}
/**
 保存图片到系统相册
 
 @param image image
 */
+ (void)saveImageWithPhotoLibrary:(UIImage *)image
{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        if (success) {
            //  [STTextHudTool showText:@"已保存至相册" withSecond:1];
        }
        JLog(@"success = %d, error = %@", success, error);
    }];
}

/**
 获取系统相册中所有的缩略图 和原图
 缩略图  尺寸 大约 {32.5，60}   (allSmallImageArray 回调获取到的缩略图 图片数组)
 原图    尺寸 大约 屏幕等大     （allOriginalImageArray 回调获取到的大图 图片数组)
 
 */

+ (void)async_getLibraryPhoto:(void(^)(NSArray <UIImage *> *allSmallImageArray))smallImageCallBack
     allOriginalImageCallBack:(void(^)(NSArray <UIImage *> *allOriginalImageArray))allOriginalImageCallBack
{
    static UIImage *image;image = [UIImage new];
    dispatch_queue_t concurrencyQueue = dispatch_queue_create("getLibiaryAllImage-queue",
                                                              DISPATCH_QUEUE_CONCURRENT);
    // task 1 ：  先获得相册中所有 缩略图
    dispatch_async(concurrencyQueue, ^{
        NSMutableArray *smallPhotoArray = [[NSMutableArray alloc]init];
        [smallPhotoArray addObjectsFromArray:[UIImage getImageWithScaleImage:image isOriginalPhoto:NO]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (smallImageCallBack) {
                smallImageCallBack([smallPhotoArray copy]);
            }
        });
    });
    // task 2 ：  获得相册中所有 原图
   dispatch_async(concurrencyQueue, ^{
        NSMutableArray *allOriginalPhotoArray = [[NSMutableArray alloc]init];
        [allOriginalPhotoArray addObjectsFromArray:[UIImage getImageWithScaleImage:image isOriginalPhoto:YES]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (allOriginalImageCallBack) {
                allOriginalImageCallBack([allOriginalPhotoArray copy]);
            }
        });
        
    });
}
+ (NSArray <UIImage *> *)getImageWithScaleImage:(UIImage *)image isOriginalPhoto:(BOOL)isOriginalPhoto
{
    NSMutableArray *photoArray = [[NSMutableArray alloc]init];
    // 获得所有的自定义相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 遍历所有的自定义相簿
    for (PHAssetCollection *assetCollection in assetCollections) {
        [photoArray addObjectsFromArray:[image enumerateAssetsInAssetCollection:assetCollection original:isOriginalPhoto]];
    }
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    [photoArray addObjectsFromArray:[image enumerateAssetsInAssetCollection:cameraRoll original:isOriginalPhoto]];
    return photoArray;
}


/**
 *  遍历相簿中的所有图片
 *  @param assetCollection 相簿
 *  @param original        是否要原图
 */
- (NSArray <UIImage *> *)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;

    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    for (PHAsset *asset in assets) {
        // 是否要原图
        CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            [array addObject:result];
        }];
    }
    return array;
}

- (UIImage *)beginClip
{
    
    CGSize size = self.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    [path addClip];
    [self drawAtPoint:CGPointZero];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //原角化
    UIImage *icon = img;
    UIGraphicsBeginImageContextWithOptions (icon. size, NO, 0.0);//获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext() ;//添加一个圆
    CGRect rect2 = CGRectMake(0, 0, icon. size. width, icon. size. height);
    CGContextAddEllipseInRect (ctx, rect2) ;
    CGContextClip(ctx);
    [icon drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();//关闭上下文
    UIGraphicsEndImageContext();

  
    
    
    return image;
}

 

//压缩图片
+ (UIImage *)compressionImage:(UIImage *)image {
    
    @autoreleasepool {
        JLog(@"原图 -- %@,大小 %ldkb",image,[self lengthOfImage:image]);
//        NSData *data=UIImageJPEGRepresentation(image, 1.0);
//         if (data.length>300*1024) {
//           if (data.length>1024*1024) {//1M以及以上
//             data=UIImageJPEGRepresentation(image, 0.1);
//           }else if (data.length>512*1024) {//0.5M-1M
//             data=UIImageJPEGRepresentation(image, 0.5);
//           }else if (data.length>300*1024) {//0.25M-0.5M
//             data=UIImageJPEGRepresentation(image, 0.9);
//           }
//         }
//        UIImage *newImage  = [UIImage imageWithData:data];
        
   
     
//        // Create a graphics image context
        CGFloat imageCropPercent = 1.0f;
        
        if([self lengthOfImage:image] > 3000){
            imageCropPercent=[self lengthOfImage:image]/1000;
        }else if([self lengthOfImage:image] > 2000){
            imageCropPercent = 3.0f;
        }else if([self lengthOfImage:image] > 1000){
            imageCropPercent = 2.0f;
        }else{
            imageCropPercent = 1.0f;
        }
        CGSize newSize = CGSizeMake(image.size.width/imageCropPercent, image.size.height/imageCropPercent);
        UIGraphicsBeginImageContext(newSize);
        // Tell the old image to draw in this new context, with the desired
        // new size
        [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        // Get the new image from the context
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        JLog(@"压缩后 -- %@,大小 %ldkb",newImage,[self lengthOfImage:newImage]);

        // End the context
        UIGraphicsEndImageContext();
        
        return newImage;
    }
    
}

+(NSData *)imageData:(UIImage *)myimage{
    JLog(@"原图 -- %@,大小 %ldkb",myimage,[self lengthOfImage:myimage]);
    NSData *data=UIImageJPEGRepresentation(myimage, 1.0);
    if (data.length>100*1024) {
    
        if (data.length>1024*1024) {
        //1M以及以上
        data=UIImageJPEGRepresentation(myimage, 0.1);
        
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(myimage, 0.5);
            
        }else if (data.length>200*1024) {//0.25M-0.5M
        data=UIImageJPEGRepresentation(myimage, 0.9);
        }else{
            
        }
    }
    JLog(@"压缩后 -- %lu,大小 kb",[data length]/1024);
    return data;
}

 

+(NSInteger)lengthOfImage:(UIImage *)image {
    
    NSData * imageData = UIImageJPEGRepresentation(image,1);
    
    return [imageData length]/1024;
}


+ (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time{

AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
NSParameterAssert(asset);
AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
assetImageGenerator.appliesPreferredTrackTransform = YES;
assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;

CGImageRef thumbnailImageRef = NULL;
CFTimeInterval thumbnailImageTime = time;
NSError *thumbnailImageGenerationError = nil;
thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];

if(!thumbnailImageRef)
NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);

UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;

return thumbnailImage;
}

@end
