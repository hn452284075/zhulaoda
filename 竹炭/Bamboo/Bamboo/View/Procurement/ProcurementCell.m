//
//  ProcurementCell.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/26.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "ProcurementCell.h"
#import "UIButton+WebCache.h"
@implementation ProcurementCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setButtonArr:(NSArray *)buttonArr{

         
    for(UIView *view in [self.bottomView subviews])
    {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
         
    }
    
    // 保存前一个button的宽以及前一个button距离屏幕边缘的距
    CGFloat edge =10;
    //设置button 距离父视图的高
    
    self.buttonX.constant = kScreenWidth-buttonArr.count*87-50.5-((buttonArr.count-1)*edge);
 
    for (int i =0; i< buttonArr.count; i++) {
        UIButton *button =[UIButton buttonWithType:UIButtonTypeSystem];
        button.tag =200+i;
        button.backgroundColor =[UIColor whiteColor];
        [button addTarget:self action:@selector(selectClick:) forControlEvents:(UIControlEventTouchUpInside)];
        button.layer.cornerRadius = 15;
       
        //确定文字的字号
        button.titleLabel.font = [UIFont systemFontOfSize:14];

        CGFloat length = 87;
        //为button赋值
        [button setTitle:buttonArr[i] forState:(UIControlStateNormal)];
        if ([button.titleLabel.text isEqualToString:@"付款"]||[button.titleLabel.text isEqualToString:@"确认收货"]||[button.titleLabel.text isEqualToString:@"评价"]){
             [button setTitleColor:[UIColor whiteColor]  forState:(UIControlStateNormal)];
            [button setBackgroundColor:UIColorFromRGB(0x4BC77E)];
        }else{

            button.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
            button.layer.borderWidth = 0.5f;

            [button setTitleColor:UIColorFromRGB(0x666666) forState:(UIControlStateNormal)];
        }
        //设置button的frame
        button.frame =CGRectMake(edge, 13, length, 30);
        
 
        //获取前一个button的尾部位置位置
        edge = button.frame.size.width +button.frame.origin.x+edge;
        
        [self.bottomView addSubview:button];
        
        
    }

}

 
- (void)selectClick:(UIButton *)btn{

    
    emptyBlock(self.buttonTitleBlock,btn.titleLabel.text);
    
}
//
//- (NSString *)findStatusKey:(NSString *)key{
//
//    NSDictionary *dic = @{@"confirm":@"确认收货",@"pay":@"待付款",@"details":@"查看详情",@"cancel_order":@"取消订单",@"delete":@"删除订单",@"delivery":@"待发货",@"again":@"再次购买",@"feedback":@"评价",@"logistics":@"物流",@"remindDelivery":@"提醒发货",@"qufahuo":@"去发货"};
//
//    return dic[key];
//
//}


-(void)setStoreDic:(NSDictionary *)dic{
    
  self.orderStatus.textColor = UIColorFromRGB(0xff3f3f);
    
   //收货状态:0：待发货，1：已发货 ， 2 已收货
     if([dic[@"receiptStatus"]intValue]==0){
         
          [self setButtonArr:@[@"去发货"]];
         
     }else{
         
     }

   
    NSArray *arr = dic[@"orderGoodsVoList"];
    if (!isEmpty(arr)) {
        
    NSDictionary *goodsDic=arr[0];
    self.titleLabel.text =goodsDic[@"goodName"];
    self.contentLabel.text =goodsDic[@"specification"];
    NSString *price = goodsDic[@"unitPrice"];
    [self.orderImage sd_SetImgWithUrlStr:goodsDic[@"picUrl"] placeHolderImgName:@""];
     NSString *priceStr;
     if (isEmpty(goodsDic[@"unit"])) {
        priceStr  = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"￥%@",price]];
     }else{
       priceStr  = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"￥%@/%@",price,goodsDic[@"unit"]]];
     }
    
         NSMutableAttributedString *tempstr = [[NSMutableAttributedString alloc] initWithString:priceStr];
         [tempstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(1,price.length)];
     _orderPrice.attributedText = tempstr;
     _actualQuantity.text = [NSString stringWithFormat:@"x%@%@",goodsDic[@"actualQuantity"],goodsDic[@"unit"]];
     _priceTotal.text=[NSString stringWithFormat:@"合计:%@元",goodsDic[@"subTotal"]];
    }
    
    
    self.orderStatus.text =dic[@"orderStateTitle"];
    self.storeName.text = dic[@"shopName"];
    
    

    [self.storeBtn sd_setImageWithURL:[NSURL URLWithString:dic[@"shopLogo"]] forState:UIControlStateNormal placeholderImage:IMAGE(@"login_logo")];
    _orderCount.text = [NSString stringWithFormat:@"共%@件",dic[@"orderItemsNumber"]];
}

-(void)setMeOrderDic:(NSDictionary *)meOrderDic{
    self.orderStatus.textColor = UIColorFromRGB(0xff3f3f);
    
       NSArray *arr = meOrderDic[@"orderGoodsVoList"];
    if (!isEmpty(arr)) {

       NSDictionary *goodsDic=arr[0];
      NSString *price = goodsDic[@"unitPrice"];
        if (arr.count==1) {
          //只有一个产品
           self.titleLabel.text =goodsDic[@"goodName"];
           self.contentLabel.text =goodsDic[@"specification"];
           [self.orderImage sd_SetImgWithUrlStr:goodsDic[@"picUrl"] placeHolderImgName:@""];
            if ([goodsDic[@"unit"] containsString:@"起批"]) {
                NSString *s = [goodsDic[@"unit"] stringByReplacingOccurrencesOfString:@"起批" withString:@""];
                NSString *priceStr = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"￥%@/%@",price,s]];
                NSMutableAttributedString *tempstr = [[NSMutableAttributedString alloc] initWithString:priceStr];
                              [tempstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(1,price.length)];
                          _orderPrice.attributedText = tempstr;
                
            }else{
                NSString *priceStr = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"￥%@/%@",price,goodsDic[@"unit"]]];
                NSMutableAttributedString *tempstr = [[NSMutableAttributedString alloc] initWithString:priceStr];
                              [tempstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(1,price.length)];
                          _orderPrice.attributedText = tempstr;
            }
            
           
              
           _actualQuantity.text = [NSString stringWithFormat:@"x%@%@",goodsDic[@"actualQuantity"],goodsDic[@"unit"]];
              
          
              self.imageViewBg.hidden=YES;
          }else{
              //多个产品
              self.imageViewBg.hidden=NO;
               NSDictionary *goodsDic=arr[0];
              [self.orderImage sd_SetImgWithUrlStr:goodsDic[@"picUrl"] placeHolderImgName:@""];
               NSDictionary *goodsDic2=arr[1];
              
               [self.orderImage2 sd_SetImgWithUrlStr:goodsDic2[@"picUrl"] placeHolderImgName:@""];
              
              if(arr.count>2){
                  NSDictionary *goodsDic3=arr[2];
                  self.orderImage3.hidden=NO;
                  if(!isEmpty(goodsDic3)){
                     [self.orderImage3 sd_SetImgWithUrlStr:goodsDic3[@"picUrl"] placeHolderImgName:@""];
                  }
              }else{
                  self.orderImage3.hidden=YES;
              }
    
          }
    
    }
    
      self.orderStatus.text =meOrderDic[@"orderStateTitle"];
      self.storeName.text = meOrderDic[@"shopName"];
     [self.storeBtn sd_setImageWithURL:[NSURL URLWithString:meOrderDic[@"shopLogo"]] forState:UIControlStateNormal placeholderImage:IMAGE(@"login_logo")];
    _priceTotal.text=[NSString stringWithFormat:@"合计:%@元",meOrderDic[@"orderPrice"]];
    _orderCount.text = [NSString stringWithFormat:@"共%@件",meOrderDic[@"orderItemsNumber"]];
    
       
       
    
    //订单状态:0：正常，1：已失效
    if ([meOrderDic[@"orderStatus"]intValue]==1) {
         [self setButtonArr:@[@"删除"]];
        return;
    }
    if ([meOrderDic[@"orderStateTitle"] isEqualToString:@"交易已关闭"]) {
        [self setButtonArr:@[@"删除"]];
        return;
       }
    
     
     
     
     //付款状态:0:待付款，1：已付款
     if([meOrderDic[@"payStatus"]intValue]==0){
         
          [self setButtonArr:@[@"取消订单",@"付款"]];
         
     }if([meOrderDic[@"payStatus"]intValue]==1){
             
         //收货状态:0：待发货 1：已发货 2 已收货
         if ([meOrderDic[@"receiptStatus"]intValue]==0) {
             [self setButtonArr:@[@"提醒发货"]];
         }else if ([meOrderDic[@"receiptStatus"]intValue]==1) {
             [self setButtonArr:@[@"查看物流",@"确认收货"]];
         }else{
             //评价还没做先隐藏
//             [self setButtonArr:@[@"查看物流",@"评价"]];
         }
         
     }else{
      
     }
}
@end
