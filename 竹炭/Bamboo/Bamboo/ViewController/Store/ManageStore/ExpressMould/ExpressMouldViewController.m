//
//  ExpressMouldViewController.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/4.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "ExpressMouldViewController.h"
#import "SetExpressModel.h"
#import "SetExpressDetailModel.h"
#import "NewETViewController.h"
#import "UIBarButtonItem+BarButtonItem.h"

@interface ExpressMouldViewController ()<UITableViewDelegate,UITableViewDataSource,NewETDelegate>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableDictionary *templateDic;
@property (nonatomic, assign) int editIndex;

@end

@implementation ExpressMouldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageTitle = @"运费模板";
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.editIndex = -1;
    [self getAllFreightTemplate];
    
    
    self.tableview = [[UITableView alloc] init];
    self.tableview.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(6);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.tableFooterView = [[UIView alloc] init];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.tableHeaderView = [self tableheaderview];
    
    UIBarButtonItem *rightItem = [UIBarButtonItem initWithTitle:@"新建"
                                                     titleColor:UIColorFromRGB(0x47c67c)
                                                      titleSize:14
                                                         target:self
                                                         action:@selector(newFucntion:)];
    
    self.navigationItem.rightBarButtonItems = @[[UIBarButtonItem barButtonItemSpace:-10],rightItem];
    
}

#pragma mark ------------------------Init---------------------------------
 

 
#pragma mark ------------------------Api----------------------------------
//获取所有运费模板
-(void)getAllFreightTemplate{
    WEAK_SELF
    [self showHub];
    [AFNHttpRequestOPManager postWithParameters:nil subUrl:@"ShopApi/getAllFreightTemplate" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
            NSArray *arr = resultDic[@"params"];
            weak_self.templateDic = [[NSMutableDictionary alloc] init];
            for (int a=0; a<arr.count; a++) {
                NSMutableArray *infoArr=[[NSMutableArray alloc]init];
                NSDictionary *dic = arr[a];
                SetExpressModel *exModel = [[SetExpressModel alloc]init];
                exModel.templateName = dic[@"freightTemplateName"];
                exModel.unitPrice = dic[@"freightTemplateUnit"];
                for (NSDictionary *detailsDic in dic[@"freightInfoVos"]) {
                    SetExpressDetailModel *dicModel = [[SetExpressDetailModel alloc]init];
                    dicModel.default_price= [NSString stringWithFormat:@"%d",[detailsDic[@"freightFirst"] intValue]];
                    dicModel.add_price= [NSString stringWithFormat:@"%d",[detailsDic[@"freightInc"] intValue]];
                    dicModel.default_weight= [NSString stringWithFormat:@"%d",[detailsDic[@"weightFirst"] intValue]];
                    dicModel.add_weight= [NSString stringWithFormat:@"%d",[detailsDic[@"weightInc"] intValue]];
                    dicModel.areaArray =[NSMutableArray arrayWithObject:detailsDic[@"area"]];
                    [infoArr addObject:dicModel];
                }
                exModel.expressDetailArray=infoArr;
                exModel.tId = [dic[@"templateId"] intValue];
                
                [self.templateDic setValue:exModel forKey:dic[@"templateId"]];
                
            }
            [weak_self.tableview reloadData];
            weak_self.tableview.tableHeaderView = [weak_self tableheaderview];
        }else{
            [weak_self showMessage:resultDic[@"msg"]];
        }
        
    }];
}

#pragma mark ------ 根据模板ID -- 删除模板
- (void)deleteTemplateById:(int)t_id
{
    WEAK_SELF
    [self showHub];
    [AFNHttpRequestOPManager postWithParameters:@{
        @"templateId":[NSNumber numberWithInt:t_id],
    } subUrl:@"ShopApi/deleteFreightTemplateById" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
            
            [self getAllFreightTemplate];
        }else{
            [weak_self showMessage:resultDic[@"msg"]];
        }
        
    }];
}

#pragma mark ------------------------Page Navigate------------------------


#pragma mark ------------------------Private------------------------------
- (UIView *)tableheaderview
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    v.backgroundColor = [UIColor clearColor];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 20)];
    lab.text = [NSString stringWithFormat:@"共%lu个版本",(unsigned long)self.templateDic.allKeys.count];
    lab.textAlignment = NSTextAlignmentLeft;
    lab.textColor = UIColorFromRGB(0x9a9a9a);
    lab.font = CUSTOMFONT(14);
    [v addSubview:lab];
    return v;
}

- (UIView *)getTemplateRowViewTag:(int)tag
{
    UIView *rowbgv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-30, 80)];
    rowbgv.tag = tag;
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rowbgv addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rowbgv.mas_top).offset(0);
        make.right.equalTo(rowbgv.mas_right).offset(0);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(35);
    }];
    closeBtn.tag = 1;
    [closeBtn setImage:IMAGE(@"storecloseicon") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *namelab = [[UILabel alloc] init];
    namelab.tag = 2;
    [rowbgv addSubview:namelab];
    [namelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rowbgv.mas_top).offset(10);
        make.left.equalTo(rowbgv.mas_left).offset(10);
        make.right.equalTo(rowbgv.mas_right).offset(-10);
        make.height.mas_equalTo(18);
    }];
    namelab.font = [UIFont boldSystemFontOfSize:16];
    namelab.textColor = UIColorFromRGB(0x222222);
    namelab.textAlignment = NSTextAlignmentLeft;
    
    UILabel *msglab = [[UILabel alloc] init];
    msglab.tag = 3;
    [rowbgv addSubview:msglab];
    [msglab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(namelab.mas_bottom).offset(8);
        make.left.equalTo(namelab.mas_left).offset(0);
        make.right.equalTo(rowbgv.mas_right).offset(-14);
        make.height.mas_offset(40);
    }];
    msglab.numberOfLines = 0;
    msglab.lineBreakMode = NSLineBreakByCharWrapping;
    
    msglab.font = CUSTOMFONT(12);
    msglab.textColor = UIColorFromRGB(0x999999);
    msglab.textAlignment = NSTextAlignmentLeft;
    return rowbgv;
}

- (void)configTeplateRowData:(SetExpressModel *)em rowView:(UIView *)v
{
    UILabel *namelab = [v viewWithTag:2];
    UILabel *msglab  = [v viewWithTag:3];
    
    namelab.text = em.templateName;
    
    if(em.expressDetailArray.count > 0)
    {
        SetExpressDetailModel *_dm = [em.expressDetailArray firstObject];
        NSString *resultStr = @"";
        NSString *areastr = _dm.areaArray[0];
        NSArray *_areaarr = [areastr componentsSeparatedByString:@"_"];
        if(_areaarr.count < 3)
        {
            resultStr = _areaarr[0];
            for(int i=1;i<_areaarr.count;i++)
            {
                resultStr = [NSString stringWithFormat:@"%@、%@",resultStr,_areaarr[i]];
            }
        }
        else
        {
            resultStr = _areaarr[0];
            for(int i=1;i<3;i++)
            {
                resultStr = [NSString stringWithFormat:@"%@、%@",resultStr,_areaarr[i]];
            }
            resultStr = [NSString stringWithFormat:@"%@等%d省市",resultStr,(int)_areaarr.count];
        }
        NSString *_pricestr = [NSString stringWithFormat:@"首重%@公斤内%@元，续重每%@公斤%@元",_dm.default_weight,_dm.default_price,_dm.add_weight,_dm.add_price];
        msglab.text = [NSString stringWithFormat:@"%@:%@",resultStr,_pricestr];
    }
}

#pragma mark ------------------------View Event---------------------------
#pragma mark ------------------ 新建模板
- (void)newFucntion:(id)sender
{
    self.editIndex = -1;
    SetExpressModel *em = [[SetExpressModel alloc] init];
    em.tId = -1;
    NewETViewController *vc = [[NewETViewController alloc] init];
    vc.modelData = em;
    vc.delegate = self;
    em.expressDetailArray = [[NSMutableArray alloc] init];
    [self navigatePushViewController:vc animate:YES];
}

#pragma mark ------------------ 删除某一个模板
- (void)closeBtnClicked:(id)sender event:(id)event
{
    [self showAlertWithTitle:@"提示" message:@"确定要删除该模板吗" sureTitle:@"确定" cancelTitle:@"取消" sureAction:^(UIAlertAction *action) {
        NSSet * touches =[event allTouches];
        UITouch * touch =[touches anyObject];
        CGPoint currentTouchPosition = [touch locationInView:self.tableview];
        NSIndexPath * indexPath = [self.tableview indexPathForRowAtPoint:currentTouchPosition];
        if (indexPath!= nil)
        {
            NSArray *keyarr = [self.templateDic allKeys];
            NSString *keystr = [keyarr objectAtIndex:indexPath.row];
            [self deleteTemplateById:[keystr intValue]];
        }
    } cancelAction:^(UIAlertAction *action) {
        
    }];
}


#pragma mark ------------------------Notification-------------------------

#pragma mark ------------------------Getter / Setter----------------------



#pragma mark ------------------------Delegate-----------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.editIndex = (int)indexPath.row;
    NSArray *allkeys = [self.templateDic allKeys];
    SetExpressModel *em = [self.templateDic objectForKey:allkeys[indexPath.row]];
    NewETViewController *vc = [[NewETViewController alloc] init];
    vc.modelData = em;
    vc.delegate = self;
    [self navigatePushViewController:vc animate:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.templateDic.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"supplygoodscell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] init];
        UIView *v = [self getTemplateRowViewTag:100];
        [cell addSubview:v];
        v.backgroundColor = [UIColor whiteColor];
        v.layer.cornerRadius = 5.;
        v.frame = CGRectMake(15, 5, kScreenWidth-30, 80);
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    UIView *tv = [cell viewWithTag:100];
    NSArray *allkeys = [self.templateDic allKeys];
    SetExpressModel *_em = [self.templateDic objectForKey:allkeys[indexPath.row]];
    [self configTeplateRowData:_em rowView:tv];
    
    return cell;
}



- (void)expressTemplateChanged:(SetExpressModel *)em
{
    [self getAllFreightTemplate];            
}

@end
