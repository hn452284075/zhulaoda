//
//  PersonDetailModel.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/10.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonDetailModel : NSObject

@property (nonatomic, strong) NSString      *headImg;
@property (nonatomic, strong) NSString      *name;
@property (nonatomic, assign) BOOL          tagFlag;
@property (nonatomic, strong) NSString      *fansNumber;
@property (nonatomic, strong) NSString      *visitorNumber;
@property (nonatomic, strong) NSString      *chatNumber;
@property (nonatomic, strong) NSString      *adressString;
@property (nonatomic, strong) NSString      *hasOpenShopState;
@property (nonatomic, assign) int    collectionState;
@property (nonatomic, assign) int    followState;

@end

NS_ASSUME_NONNULL_END
