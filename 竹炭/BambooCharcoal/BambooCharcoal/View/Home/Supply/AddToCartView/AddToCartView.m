//
//  AddToCartView.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/8/28.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "AddToCartView.h"

@interface AddToCartView()

@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, strong) NSArray   *specArray;

@end

@implementation AddToCartView
@synthesize delegate;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//- (void)_initCartViewInfo:(UIImage *)image price:(NSString *)price msg:(NSString *)msg specArr:(NSArray *)specarr
- (void)_initCartViewInfo:(NSString *)imageurl price:(NSString *)price msg:(NSString *)msg specArr:(NSArray *)specarr
{
    self.selectedIndex = 0;
    self.specArray = specarr;
    
    UIImageView *imgview = (UIImageView *)[self viewWithTag:1];
    [imgview sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage:IMAGE(@"supply_goodsimg")];
    imgview.layer.cornerRadius = 5.0;
    imgview.layer.masksToBounds = YES;
    
    UILabel *pricelab = (UILabel *)[self viewWithTag:2];
    pricelab.text = price;
    
    UILabel *msglab = (UILabel *)[self viewWithTag:3];
    msglab.text = msg;
    
    int x = 15;
    int y = 185;
    BOOL flag = NO;
    for(int i=0;i<specarr.count;i++)
    {
        SupplyGDSpceModel *mm = [specarr objectAtIndex:i];
        
        UIButton *tagbtn = [[UIButton alloc]init];
        
        [tagbtn setTitle:mm.gs_name  forState:UIControlStateNormal];
               
        tagbtn.layer.cornerRadius = 3.0;
        tagbtn.tag = 10+i;
        if ([mm.gs_selected integerValue]==1) {
          flag=YES;
          tagbtn.layer.borderColor = kGetColor(0x47, 0xc6, 0x7c).CGColor;
          [tagbtn setTitleColor:kGetColor(0x47, 0xc6, 0x7c) forState:UIControlStateNormal];
          tagbtn.layer.borderWidth = 1.0;
          tagbtn.backgroundColor = [UIColor clearColor];
            self.selectedIndex=i;
        }else{
            tagbtn.layer.borderWidth = 0;
           [tagbtn setTitleColor:kGetColor(0x22, 0x22, 0x22) forState:UIControlStateNormal];
           tagbtn.backgroundColor = kGetColor(0xf5, 0xf5, 0xf5);
            tagbtn.layer.borderColor = [UIColor clearColor].CGColor;
        }
        
        CGSize ze = [self sizeWithText:mm.gs_name font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(200, 31)];
        
        if(x + ze.width + 50 > kScreenWidth)  //超过屏幕宽度，另起i一行
        {
            x = 15;
            y = y + 31 + 15;
        }
        
        tagbtn.frame = CGRectMake(x, y, ze.width+12, 31);
        tagbtn.titleLabel.font = [UIFont systemFontOfSize:12];
        x +=30;
        x +=ze.width;
        [self addSubview:tagbtn];
        [tagbtn addTarget:self action:@selector(tagBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    if(flag==NO)
    {
        UIButton *btn = [self viewWithTag:10];
        btn.layer.borderColor = kGetColor(0x47, 0xc6, 0x7c).CGColor;
        [btn setTitleColor:kGetColor(0x47, 0xc6, 0x7c) forState:UIControlStateNormal];
        btn.layer.borderWidth = 1.0;
        btn.backgroundColor = [UIColor clearColor];
    }
    
//    SupplyGDSpceModel *mm = [self.specArray objectAtIndex:self.selectedIndex];
//    UILabel *pricelab2 = (UILabel *)[self viewWithTag:2];
//    pricelab2.text = mm.gs_unit_price;

}


- (void)tagBtnClicked:(id)sender
{
    for(UIView *v in self.subviews)
    {
        if([v isKindOfClass:[UIButton class]] && v.tag!= 100 && v.tag != 101)
        {
            UIButton *btn = (UIButton *)v;
            btn.layer.borderWidth = 0;
            [btn setTitleColor:kGetColor(0x22, 0x22, 0x22) forState:UIControlStateNormal];
            btn.backgroundColor = kGetColor(0xf5, 0xf5, 0xf5);
        }
    }
    
    UIButton *btn = (UIButton *)sender;
    btn.layer.borderColor = kGetColor(0x47, 0xc6, 0x7c).CGColor;
    [btn setTitleColor:kGetColor(0x47, 0xc6, 0x7c) forState:UIControlStateNormal];
    btn.layer.borderWidth = 1.;
    btn.backgroundColor = [UIColor clearColor];
    self.selectedIndex = (int)btn.tag - 10;
    
    SupplyGDSpceModel *mm = [self.specArray objectAtIndex:self.selectedIndex];
    UILabel *pricelab = (UILabel *)[self viewWithTag:2];
    pricelab.text = mm.gs_unit_price;
    
}
    



- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {

    NSDictionary *attrs = @{NSFontAttributeName : font};

    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;

}



- (IBAction)closeCartView:(id)sender
{
    [self.delegate addToCart_Cancel];
}

- (IBAction)addToCart:(id)sender
{
    
    SupplyGDSpceModel *model = [self.specArray objectAtIndex:self.selectedIndex];
    emptyBlock(_seletecdSpecBlock,model.gs_specificationId);
    if ([self.delegate respondsToSelector:@selector(addToCart_Ok:)]) {
    [self.delegate addToCart_Ok:self.selectedIndex];
    }
    
}
@end
