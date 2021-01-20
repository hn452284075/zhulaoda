//
//  ChatOnceViewController.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/8.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "ChatOnceViewController.h"
#import "ChatOnceCell.h"

@interface ChatOnceViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@end

@implementation ChatOnceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pageTitle = @"访客记录";
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
    [self _initTableView];
}

- (void)_initTableView
{
    self.tableview = [[UITableView alloc] init];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.mas_equalTo(kScreenWidth);
    }];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = [UIColor clearColor];
}


#pragma mark ------------------------Api----------------------------------
#pragma mark ------------------------Page Navigate------------------------

#pragma mark ------------------------View Event---------------------------
- (void)btnClicked:(UIButton *)btn
{
    switch (btn.tag) {
        case 4:
        {
//            CustomManageViewController *vc = [[CustomManageViewController alloc] init];
//            [self navigatePushViewController:vc animate:YES];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark ------------------------Delegate-----------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 41;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ChatOnceCell";
    ChatOnceCell *cell = (ChatOnceCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ChatOnceCell" owner:nil options:nil] firstObject];
        cell.bgview.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        
        cell.headImg.layer.cornerRadius = 20;
        
        cell.lable_2.backgroundColor = [UIColor clearColor];
        cell.lable_2.layer.borderColor = [UIColor orangeColor].CGColor;
        cell.lable_2.textColor = [UIColor orangeColor];
        cell.lable_2.layer.borderWidth = 1.;
        cell.lable_2.layer.cornerRadius = 5.;
        
        cell.label_3.backgroundColor = [UIColor clearColor];
        cell.label_3.layer.borderColor = [UIColor greenColor].CGColor;
        cell.label_3.textColor = [UIColor greenColor];
        cell.label_3.layer.borderWidth = 1.;
        cell.label_3.layer.cornerRadius = 5.;
        
        cell.label_4.backgroundColor = [UIColor clearColor];
        cell.label_4.layer.borderColor = [UIColor redColor].CGColor;
        cell.label_4.textColor = [UIColor redColor];
        cell.label_4.layer.borderWidth = 1.;
        cell.label_4.layer.cornerRadius = 5.;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.headImg.image  = IMAGE(@"supply_goodsimg");
    cell.label_1.text   = @"冰糖心苹果";
    cell.lable_2.text   = @" 实名 ";
    cell.label_3.text   = @" 开店宝 ";
    cell.label_4.text   = @" 竹商 ";
    cell.label_5.text   = @"新疆阿克苏";
    cell.label_6.text   = @"聊过1000次";
    
    if(indexPath.row == 0)
    {
        //创建 layer
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = cell.bgview.bounds;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: maskLayer.frame = cell.bgview.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5,5)];
        maskLayer.frame = cell.bgview.bounds;
        //赋值
        maskLayer.path = maskPath.CGPath;
        cell.bgview.layer.mask = maskLayer;
    }
    else if(indexPath.row == 40)
    {
        cell.lineview.hidden = YES;
        //创建 layer
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = cell.bgview.bounds;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: maskLayer.frame = cell.bgview.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5,5)];
        maskLayer.frame = cell.bgview.bounds;
        //赋值
        maskLayer.path = maskPath.CGPath;
        cell.bgview.layer.mask = maskLayer;
    }
    else
    {
        //创建 layer
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = cell.bgview.bounds;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: maskLayer.frame = cell.bgview.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(0,0)];
        maskLayer.frame = cell.bgview.bounds;
        //赋值
        maskLayer.path = maskPath.CGPath;
        cell.bgview.layer.mask = maskLayer;
    }
    
    
    
    return cell;
}

#pragma mark ------------------------Notification-------------------------

#pragma mark ------------------------Getter / Setter----------------------

@end
