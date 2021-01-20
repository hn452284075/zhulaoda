//
//  SearchViewController.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/18.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UITextField *filedText;
@property (strong, nonatomic) IBOutlet UIButton *searchBtn;


@property (nonatomic,strong)NSString *searchStr;
@property (nonatomic,assign)int searchGoodsID;

@property (nonatomic,assign)int searchPlaceID;  //供应大厅进来的产地ID


@end

NS_ASSUME_NONNULL_END
