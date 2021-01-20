//
//  ShelvesCell.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/31.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SeletecdIndeBlock)(NSInteger index);
@interface ShelvesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordLabel;
@property (nonatomic,copy)SeletecdIndeBlock seletecdIndeBlock;
@property (weak, nonatomic) IBOutlet UIButton *button1;

@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;

@property (nonatomic,strong)NSDictionary *dic;
@end

 
