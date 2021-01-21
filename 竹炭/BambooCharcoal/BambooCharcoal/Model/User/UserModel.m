//
//  UserModel.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/15.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "UserModel.h"
#import "TMCache.h"
static UserModel *_userDataManager = nil;
@implementation UserModel
+ (instancetype)sharedInstance{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _userDataManager = [[UserModel alloc] init];
        
    });
    
    return _userDataManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
         self.userInfo =   (NSMutableDictionary *)  [[TMCache sharedCache]objectForKey:userInfoCacheKey];
        
       
    }
    return self;
}

- (void)clearUserInfo {
    self.userInfo = @{}.mutableCopy;
    [[TMCache sharedCache]removeAllObjects];
    
}

- (NSMutableDictionary *)userInfo {
    
    return _userInfo;
    
}
 
 
-(NSString *)userId{
    
    return [NSString isEmptyForString:_userInfo[@"accid"]];
}
-(NSString *)getTime{
    
    return [NSString isEmptyForString:_userInfo[@"getTime"]];
}
-(NSString *)username{
    
    return [NSString isEmptyForString:_userInfo[@"nickName"]];
}
-(NSString *)phone{
    
    return [NSString isEmptyForString:_userInfo[@"phone"]];;
}
-(NSString *)avatar{
    
    return [NSString isEmptyForString:_userInfo[@"avatar"]];;
}
-(NSString *)token{
    
    return [NSString isEmptyForString:_userInfo[@"token"]];;
}

-(NSString *)verifyStatus{
    
    return [NSString isEmptyForString:_userInfo[@"verifyStatus"]];;
}

-(NSString *)truename{
    
    return [NSString isEmptyForString:_userInfo[@"truename"]];;
}
 
- (void)saveUserInfo:(NSMutableDictionary *)userInfo {
 
   _userInfo = userInfo;
    [[TMCache sharedCache]setObject:_userInfo forKey:userInfoCacheKey];
}


- (BOOL)userIsLogin {
    
    if (isEmpty(self.userInfo)) {
        return NO;
    }else {
        return YES;
    }
}
@end
