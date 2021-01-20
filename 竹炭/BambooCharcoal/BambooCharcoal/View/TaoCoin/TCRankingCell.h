//
//  TCRankingCell.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/10/24.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCRankingCell : UITableViewCell
 
@property (nonatomic,strong)UIImageView *img;
@property (nonatomic,strong)UIImageView *bgimg;
@property (nonatomic,strong)UIView *subView;
@property (nonatomic,strong)UILabel *name;
@property (nonatomic,strong)UILabel *price;
@property (nonatomic,strong)UILabel *index;
-(void)data:(NSDictionary *)dic AndIndex:(NSInteger)num;
@end

NS_ASSUME_NONNULL_END
