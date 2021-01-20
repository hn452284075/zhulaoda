//
//  TCTGViewController.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/10/21.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "TCTGViewController.h"
#import "TCTGCell.h"
#import "TCTGModel.h"
#import "TCSupplyVCon.h"

@interface TCTGViewController ()<UITableViewDelegate,UITableViewDataSource,TCTGCellDelegate>

@property (nonatomic, strong) UITableView       *detailTable;
@property (nonatomic, strong) NSMutableArray    *dataSourceArray;

@property (nonatomic, strong) UIButton          *TGBtn;

@end

@implementation TCTGViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.pageTitle = @"精准推广";
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
    
    //test data
    self.dataSourceArray = [[NSMutableArray alloc] init];
    for(int i=0;i<10;i++)
    {
        TCTGModel *model = [[TCTGModel alloc] init];
        if(i%2 == 0)
        {
            model.statusFlag = 1;
            model.priceStr = @"10.08";
            model.unitStr = @"斤";
            model.contentStr = @"9月16日上午，“畅想下一个共享风口”——充充共享充电平台马场创业街分享会在扬州市生态科技新城马场创业街9号楼马场创业街分享会在扬州市生态科技新城马场创业街9号楼2楼";
            model.numer1_Str = @"123";
            model.numer2_Str = @"234";
            model.numer3_Str = @"345";
        }
        else
        {
            model.statusFlag = 0;
            model.priceStr = @"8.88";
            model.unitStr = @"公斤";
            model.contentStr = @"广州地区的每一棵洋紫荆都是这么繁茂";
            model.numer1_Str = @"1";
            model.numer2_Str = @"2";
            model.numer3_Str = @"3";
        }
        
        [self.dataSourceArray addObject:model];
    }
    
    
    [self _initTable];
    [self _initButtomView];
}


#pragma mark ------------------------init----------------------------------
- (UIView *)_tablviewHeaderView
{
    UIView *topview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 145)];
    topview.backgroundColor = UIColorFromRGB(0x46C67B);
    
    
    UILabel *timeLab = [[UILabel alloc] init];
    [topview addSubview:timeLab];
    [self customLabBy:timeLab text:@"2020年08月28日" textcolor:[UIColor whiteColor]];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topview.mas_top).offset(19);
        make.left.equalTo(topview.mas_left).offset(15);
    }];
    
    UILabel *msgLab = [[UILabel alloc] init];
    [topview addSubview:msgLab];
    [self customLabBy:msgLab text:@"可用淘币" textcolor:[UIColor whiteColor]];
    [msgLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topview.mas_top).offset(19);
        make.left.equalTo(topview.mas_left).offset(kScreenWidth/3*2);
        make.width.mas_equalTo(kScreenWidth/3);
    }];
    msgLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *btn1 = [[UIButton alloc] init];
    [self customBtnBy:btn1 title:@"18.80" textcolor:[UIColor whiteColor] tag:1];
    [topview addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topview.mas_left);
        make.centerY.equalTo(topview.mas_centerY);
        make.width.mas_equalTo(kScreenWidth/3);
        make.height.mas_equalTo(30);
    }];
    UIButton *btn2 = [[UIButton alloc] init];
    [self customBtnBy:btn2 title:@"22" textcolor:[UIColor whiteColor] tag:2];
    [topview addSubview:btn2];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn1.mas_right);
        make.centerY.equalTo(topview.mas_centerY);
        make.width.mas_equalTo(kScreenWidth/3);
        make.height.mas_equalTo(30);
    }];
    UIButton *btn3 = [[UIButton alloc] init];
    [self customBtnBy:btn3 title:@"2088.98" textcolor:[UIColor whiteColor] tag:3];
    [topview addSubview:btn3];
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn2.mas_right);
        make.centerY.equalTo(topview.mas_centerY);
        make.width.mas_equalTo(kScreenWidth/3);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *btn1_lab = [[UILabel alloc] init];
    [topview addSubview:btn1_lab];
    [self customLabBy:btn1_lab text:@"今日花费" textcolor:UIColorFromRGB(0x80F3AF)];
    [btn1_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn1.mas_bottom).offset(11);
        make.centerX.equalTo(btn1.mas_centerX);
    }];
    UILabel *btn2_lab = [[UILabel alloc] init];
    [topview addSubview:btn2_lab];
    [self customLabBy:btn2_lab text:@"今日点击" textcolor:UIColorFromRGB(0x80F3AF)];
    [btn2_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn2.mas_bottom).offset(11);
        make.centerX.equalTo(btn2.mas_centerX);
    }];
    
    UIButton *moneyBtn = [[UIButton alloc] init];
    [topview addSubview:moneyBtn];
    [moneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btn3.mas_centerX);
        make.centerY.equalTo(btn2_lab.mas_centerY);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(25);
    }];
    moneyBtn.tag = 3;
    [moneyBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    moneyBtn.layer.cornerRadius = 12;
    moneyBtn.layer.masksToBounds = YES;
    [moneyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [moneyBtn setTitle:@"续费" forState:UIControlStateNormal];
    moneyBtn.backgroundColor = UIColorFromRGB(0xff9737);
    moneyBtn.titleLabel.font = CUSTOMFONT(12);
    
    UIView *sepeLine = [[UIView alloc] init];
    [topview addSubview:sepeLine];
    [sepeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topview.mas_top).offset(15);
        make.bottom.equalTo(topview.mas_bottom).offset(-15);
        make.left.equalTo(topview.mas_left).offset(kScreenWidth/3*2);
        make.width.mas_equalTo(0.8);
    }];
    sepeLine.backgroundColor = [UIColor whiteColor];
    sepeLine.alpha = 0.22;
    
    return topview;
}

- (void)_initTable
{
    int bottomH = 61;
    if(IS_Iphonex_Series)
        bottomH = 81;
    
    self.detailTable = [[UITableView alloc] init];
    self.detailTable.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self.view addSubview:self.detailTable];
    [self.detailTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-bottomH);
    }];
    self.detailTable.delegate = self;
    self.detailTable.dataSource = self;
    self.detailTable.tableFooterView = [[UIView alloc] init];
    self.detailTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.detailTable.tableHeaderView = [self _tablviewHeaderView];
}

- (void)_initButtomView
{
    int vheight = IS_Iphonex_Series ? 61+20 : 61;
    //添加发布新推广按钮
    UIView *btnview = [[UIView alloc] init];
    btnview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:btnview];
    [btnview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.height.mas_equalTo(vheight);
    }];
    
    self.TGBtn = [[UIButton alloc] init];
    [btnview addSubview:self.TGBtn];
    [self.TGBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnview.mas_top).offset(11);
        make.left.equalTo(btnview.mas_left).offset(BtnLeftRightGap);
        make.right.equalTo(btnview.mas_right).offset(-BtnLeftRightGap);
        make.height.mas_equalTo(40);
    }];
    [self factory_btn:self.TGBtn
           backColor:KCOLOR_Main
           textColor:[UIColor whiteColor]
         borderColor:KCOLOR_Main
               title:@"发布新推广"
            fontsize:18
              corner:20
                 tag:4];
}


#pragma mark ------------------------view event----------------------------
- (void)btnClicked:(UIButton *)sender
{
    switch (sender.tag) {
        case 3:
        {
            //续费
        }
            break;
        case 4:
        {
            //发布新推广
            TCSupplyVCon *vc = [[TCSupplyVCon alloc] init];
            [self navigatePushViewController:vc animate:YES];
            
        }
            break;
            
        default:
            break;
    }
}


#pragma mark ------------------------private----------------------------------
- (void)factory_btn:(UIButton *)btn backColor:(UIColor *)bcolor textColor:(UIColor *)tcolor borderColor:(UIColor *)dcolor title:(NSString *)title fontsize:(int)fsize corner:(float)csize
                tag:(int)tag;
{
    btn.backgroundColor = bcolor;
    btn.layer.borderColor = dcolor.CGColor;
    [btn setTitleColor:tcolor forState:UIControlStateNormal];
    btn.layer.borderWidth = 1.;
    btn.layer.cornerRadius = csize;
    btn.titleLabel.font = CUSTOMFONT(fsize);
    [btn setTitle:title forState:UIControlStateNormal];
    btn.tag = tag;
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)customLabBy:(UILabel *)lab text:(NSString *)text textcolor:(UIColor *)color
{
    lab.text = text;
    lab.font = CUSTOMFONT(12);
    lab.textColor = color;
}

- (void)customBtnBy:(UIButton *)btn title:(NSString *)title textcolor:(UIColor *)color tag:(int)tag
{
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    btn.tag = tag;
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark ------------------------delegate------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 145.;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TCTGModel *m = [self.dataSourceArray objectAtIndex:indexPath.row];
    
    NSDictionary *attrs = @{NSFontAttributeName : CUSTOMFONT(16.5)};

    CGSize size = [m.contentStr boundingRectWithSize:CGSizeMake(kScreenWidth-60, 500) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
    return 145+size.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifystr = @"TCTGCell";
    
    TCTGCell *cell=[tableView dequeueReusableCellWithIdentifier:identifystr];
    
    if(!cell){
        cell = [[TCTGCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifystr];
        cell.delegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    TCTGModel *m = [self.dataSourceArray objectAtIndex:indexPath.row];
    
    [cell configCellDataBy:m];
    
    
    return cell;
}


- (void)statusBtnChanged:(int)status
{
    //status 1--停止  2--重启
}


#pragma mark ------------------------Api----------------------------------






@end
