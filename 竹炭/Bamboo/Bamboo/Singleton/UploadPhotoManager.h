//
//  UploadPhotoManager.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/11.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PhotoBlock)(NSString *dataUrl);

@interface UploadPhotoManager : NSObject
@property (nonatomic,copy)PhotoBlock photoBlock;
@property (nonatomic,strong)NSMutableArray *dataUrlArr;
+ (instancetype)sharedInstance;

- (void)uploadObjectAsyncWith:(NSData *)uploadData withObjectKey:(NSString *)objectKey withPhotoBlock:(PhotoBlock)photoBlock;

@end


