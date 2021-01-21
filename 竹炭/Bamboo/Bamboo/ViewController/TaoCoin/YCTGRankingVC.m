//
//  YCTGRankingVC.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/10/24.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "YCTGRankingVC.h"
#import "TCRankingCell.h"
#import "TCShowPriceView.h"
@interface YCTGRankingVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *ranTable;
@property (nonatomic,strong)NSArray *dataArr;
@end

@implementation YCTGRankingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KViewBgColor;
    self.dataArr = @[@{@"img":@"https://csthm.oss-cn-beijing.aliyuncs.com/category/feiliao0924.png",@"name":@"张三",@"price":@"3201"},@{@"img":@"https://csthm.oss-cn-beijing.aliyuncs.com/category/feiliao0924.png",@"name":@"李四",@"price":@"2031"},@{@"img":@"https://csthm.oss-cn-beijing.aliyuncs.com/category/feiliao0924.png",@"name":@"王五",@"price":@"2021"},@{@"img":@"https://csthm.oss-cn-beijing.aliyuncs.com/category/feiliao0924.png",@"name":@"张三",@"price":@"1041"},@{@"img":@"https://csthm.oss-cn-beijing.aliyuncs.com/category/feiliao0924.png",@"name":@"张三",@"price":@"201"}];
    [self initTableView];
}
- (IBAction)goback:(id)sender {
    [self goBack];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.fd_prefersNavigationBarHidden=YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:animated];
       self.fd_prefersNavigationBarHidden=NO;
}

- (void)initTableView {
    self.ranTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 168+11, kScreenWidth, kScreenHeight-168-61-11) style:UITableViewStylePlain];
    self.ranTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.ranTable];
    self.ranTable.showsVerticalScrollIndicator = NO;
    self.ranTable.backgroundColor = KViewBgColor;
    self.ranTable.dataSource = self;
    self.ranTable.delegate = self;
    [self.ranTable registerClass:[TCRankingCell class] forCellReuseIdentifier:@"TCRankingCell"];
   
}


//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 100;
//
//}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 60;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 13, kScreenWidth-15, 13)];
    label.textColor = UIColorFromRGB(0x999999);
    label.textAlignment=0;
    label.text = @"*供应列表仅展现前8名，超过8名不予展现";
    label.font=CUSTOMFONT(12);
    [footerView addSubview:label];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 34, kScreenWidth-15, 13)];
    label2.textColor = UIColorFromRGB(0x999999);
    label2.textAlignment=0;
    label2.text = @"*排名随出价随时变化，最后更新2020年06月20日 13:25";
    label2.font=CUSTOMFONT(12);
    [footerView addSubview:label2];
    
    
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==self.dataArr.count-1) {
        return 71;
    }
    return 55;
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TCRankingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCRankingCell"];
 
       if(!cell){
           cell = [[TCRankingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TCRankingCell"];
           
       }
    [cell data:self.dataArr[indexPath.row] AndIndex:indexPath.row+1];
   
    if (indexPath.row==self.dataArr.count-1) {
        cell.subView.frame = CGRectMake(15, 0, kScreenWidth-30,71);
    }
    return cell;
    
}


- (IBAction)bottomBtnClick:(id)sender {
    
    TCShowPriceView *priceV = [[TCShowPriceView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) withGoodsPrice:@"100" AndTitle:@"推广限额"];
    [self.view.window addSubview:priceV];
    priceV.priceBlock = ^(NSString *price) {
        NSLog(@"%@",price);
        
    };
}


@end
