//
//  NSString+MD5.m
//  DIC
//
//  Created by 曾勇兵 on 17/7/26.
//  Copyright © 2017年 zengyongbing. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5)
+ (NSString*)_encryptionMD5:(NSString*)str{
  
    
   
    //KwZp_2maUOYBOprPyh
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    [result appendFormat:@"%02x", digest[i]];
        
    return result;
    
}
@end
