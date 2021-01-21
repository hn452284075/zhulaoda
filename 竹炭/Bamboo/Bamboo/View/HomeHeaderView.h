//
//  HomeHeaderView.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/25.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

typedef void(^SeletecdIndexBlock)(NSInteger index);


@interface HomeHeaderView : UICollectionReusableView<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet SDCycleScrollView *headCycleView;
@property (nonatomic,strong)NSArray *array;
@property (nonatomic,copy)SeletecdIndexBlock seletecdIndexBlock;

@property (weak, nonatomic) IBOutlet UIView *typeBgView;
@property (weak, nonatomic) IBOutlet UIView *typeBgView2;


@property (weak, nonatomic) IBOutlet UIButton *cate_btn1;
@property (weak, nonatomic) IBOutlet UIButton *cate_btn2;
@property (weak, nonatomic) IBOutlet UIButton *cate_btn3;
@property (weak, nonatomic) IBOutlet UIButton *cate_btn4;
@property (weak, nonatomic) IBOutlet UIButton *cate_btn5;
@property (weak, nonatomic) IBOutlet UIButton *cate_btn6;
@property (weak, nonatomic) IBOutlet UIButton *cate_btn7;
@property (weak, nonatomic) IBOutlet UIButton *cate_btn8;

@property (weak, nonatomic) IBOutlet UIImageView *iconImg1;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg2;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg3;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg4;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg5;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg6;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg7;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg8;



@property (weak, nonatomic) IBOutlet UIImageView *openStoreImg;





@end

