//
//  TCTGModel.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/10/21.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCTGModel : NSObject

//精准推广
@property (nonatomic, assign) int statusFlag;
@property (nonatomic, strong) NSString *contentStr;
@property (nonatomic, strong) NSString *priceStr;
@property (nonatomic, strong) NSString *unitStr;
@property (nonatomic, strong) NSString *numer1_Str;
@property (nonatomic, strong) NSString *numer2_Str;
@property (nonatomic, strong) NSString *numer3_Str;


@end

NS_ASSUME_NONNULL_END
