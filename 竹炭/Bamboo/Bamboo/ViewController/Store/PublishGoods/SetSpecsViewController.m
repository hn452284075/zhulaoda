//
//  GoodsSpecsViewController.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/1.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "SetSpecsViewController.h"
#import "SetSpecModel.h"
#import "SearchTypeVC.h"
@interface SetSpecsViewController ()

@property (nonatomic, strong) UIScrollView  *bgScrolleView;

@property (nonatomic, strong) NSMutableDictionary   *dataDic;

@property (nonatomic, strong) NSString *selected_goods_name;
@property (nonatomic, strong) NSString *selected_goods_id;

@property (nonatomic, strong) NSString *selcted_lastId;   //最后选中的类别
@property (nonatomic, strong) NSString *selcted_lastSpec;   //最后选中的类别
@property (nonatomic, assign) int apiCount; //用来控制调取哪一个api


@end

@implementation SetSpecsViewController
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _init];
    [self _requestData];
    
    self.apiCount = 0;
    self.selected_goods_name = @"";
    self.selected_goods_id = @"";
    self.selcted_lastSpec = @"";
}


#pragma mark ------------------------Init---------------------------------
-(void)_init{
    //顶部view
    self.title = @"选择商品类目";
    self.bgScrolleView = [[UIScrollView alloc] init];
    [self.view addSubview:self.bgScrolleView];
    UIImageView *seachImg = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, kScreenWidth-2, 42)];
    [seachImg setImage:IMAGE(@"seachTypeImg")];
    seachImg.userInteractionEnabled=YES;
    WEAK_SELF
    [seachImg addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [weak_self jumpSearchTypeVC];
    }];
    [self.view addSubview:seachImg];
    
    
    [self.bgScrolleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weak_self.view);
    }];
    
 
    
}


- (void)_initSpcesTag
{
    for(UIView *v in self.bgScrolleView.subviews)
    {
        [v removeFromSuperview];
    }
    
    int x = 15;
    int y = 45;
    int size_w = (kScreenWidth-2*15-2*10)/3;
    int size_h = 31;
    
    NSArray *temparr = [self.dataDic allKeys];
    int tagCount = 0;
    for(int i=0;i<temparr.count;i++)
    {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, y, kScreenWidth, 50)];
        v.backgroundColor = UIColorFromRGB(0xf7f7f7);
        [self.bgScrolleView addSubview:v];
        
        y+=50;
        y+=22;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 15, 250, 20)];
        label.text = temparr[i];
        label.textColor = UIColorFromRGB(0x9a9a9a);
        label.textAlignment = NSTextAlignmentLeft;
        [v addSubview:label];
        
        SetSpecModel *sm = [self.dataDic objectForKey:temparr[i]];
        NSMutableArray *tagBtnArray = [[NSMutableArray alloc] init];
        for(int j=0;j<sm.subCateGory.count;j++)
        {
            SetSpecModel *_sm = [sm.subCateGory objectAtIndex:j];
            
            UIButton *btn = [self factory_btn:kGetColor(0xf5, 0xf5, 0xf5)
              textColor:kGetColor(0x22, 0x22, 0x22)
            borderColor:kGetColor(0xf5, 0xf5, 0xf5)
                  title:_sm.cateGoryName
               fontsize:14
                 corner:15
                    tag:2];
            btn.tag = ++tagCount;
            [tagBtnArray addObject:btn];
            [self.bgScrolleView addSubview:btn];
        }
                        
        //水平方向宽度固定等间隔
        int row = (int)tagBtnArray.count / 3;
        if(tagBtnArray.count % 3 != 0)
            row +=1;
        int w = size_w;     //_btn.frame.size.width;
        int h = size_h;     //_btn.frame.size.height;
        for(int i=0;i<row;i++)
        {
            int temp = 0;
            for(int j=3*i;j<tagBtnArray.count;j++)
            {
                UIButton *_btn = [tagBtnArray objectAtIndex:j];
                _btn.frame = CGRectMake(x+10*temp+w*temp++, y+h*i, w, h);
                if(temp > 3)
                {
                    y = y+18;
                    break;
                }
            }
        }
        y = y + row*h + (row+1)*8;
        self.bgScrolleView.contentSize = CGSizeMake(kScreenWidth, y);
    }
}

#pragma mark ------------------------Api----------------------------------
-(void)_requestData{

    WEAK_SELF
    [self showHub];
    [AFNHttpRequestOPManager postWithParameters:nil subUrl:@"ShopApi/chooseCategoryFirstTwo" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
            
            weak_self.dataDic = [[NSMutableDictionary alloc] init];
            
            NSMutableArray *rootarray = resultDic[@"params"];
            for(int i=0;i<rootarray.count;i++)
            {
                NSDictionary *tempdic = [rootarray objectAtIndex:i];
                
                SetSpecModel *sm  = [[SetSpecModel alloc] init];
                sm.cateGoryId   = tempdic[@"cateGoryId"];
                sm.cateGoryName = tempdic[@"cateGoryName"];
                sm.subCateGory  = [[NSMutableArray alloc] init];
                
                NSArray *cateArray = tempdic[@"subCateGory"];
                for(int i=0;i<cateArray.count;i++)
                {
                    NSDictionary *_tempdic = [cateArray objectAtIndex:i];
                    
                    SetSpecModel *tempsm  = [[SetSpecModel alloc] init];
                    tempsm.cateGoryId   = _tempdic[@"cateGoryId"];
                    tempsm.cateGoryName = _tempdic[@"cateGoryName"];
                    tempsm.subCateGory  = [[NSMutableArray alloc] init];
                    [sm.subCateGory addObject:tempsm];
                }
             
                [weak_self.dataDic setValue:sm forKey:tempdic[@"cateGoryName"]];
            }
            
            [weak_self _initSpcesTag];

        }else{
            [weak_self showMessage:resultDic[@"msg"]];
        }
    }];
}

-(void)_requestDataWithID:(int)categoryId{

    WEAK_SELF
    [self showHub];
    [AFNHttpRequestOPManager postWithParameters:@{@"categoryId":[NSNumber numberWithInt:categoryId]}  subUrl:@"ShopApi/chooseCategoryThreeFour" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
            
            weak_self.dataDic = [[NSMutableDictionary alloc] init];
            
            NSMutableArray *rootarray = resultDic[@"params"];
            for(int i=0;i<rootarray.count;i++)
            {
                NSDictionary *tempdic = [rootarray objectAtIndex:i];
                
                SetSpecModel *sm  = [[SetSpecModel alloc] init];
                sm.cateGoryId   = tempdic[@"cateGoryId"];
                sm.cateGoryName = tempdic[@"cateGoryName"];
                sm.subCateGory  = [[NSMutableArray alloc] init];
                
                NSArray *cateArray = tempdic[@"subCateGory"];
                for(int i=0;i<cateArray.count;i++)
                {
                    NSDictionary *_tempdic = [cateArray objectAtIndex:i];
                    
                    SetSpecModel *tempsm  = [[SetSpecModel alloc] init];
                    tempsm.cateGoryId   = _tempdic[@"cateGoryId"];
                    tempsm.cateGoryName = _tempdic[@"cateGoryName"];
                    tempsm.subCateGory  = [[NSMutableArray alloc] init];
                    [sm.subCateGory addObject:tempsm];
                }
             
                [weak_self.dataDic setValue:sm forKey:tempdic[@"cateGoryName"]];
            }
            
            [weak_self _initSpcesTag];

        }else{
            [weak_self showMessage:resultDic[@"msg"]];
        }
        
    }];
    
}

-(void)_requestDataWithProductID:(NSString *)productId{

    WEAK_SELF
    [self showHub];
    [AFNHttpRequestOPManager postWithParameters:@{@"categoryId":productId}  subUrl:@"ShopApi/chooseGoodsProduct" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
            
            weak_self.dataDic = [[NSMutableDictionary alloc] init];
            
            SetSpecModel *sm  = [[SetSpecModel alloc] init];
            sm.cateGoryId   = self.selcted_lastId;
            sm.cateGoryName = self.selcted_lastSpec;
            sm.subCateGory  = [[NSMutableArray alloc] init];
            NSMutableArray *rootarray = resultDic[@"params"];
            for(int i=0;i<rootarray.count;i++)
            {
                NSDictionary *tempdic = [rootarray objectAtIndex:i];
                SetSpecModel *_tmp  = [[SetSpecModel alloc] init];
                _tmp.cateGoryId   = tempdic[@"productId"];
                _tmp.cateGoryName = tempdic[@"productName"];
                [sm.subCateGory addObject:_tmp];
            }
            [weak_self.dataDic setValue:sm forKey:sm.cateGoryName];
            
            [weak_self _initSpcesTag];

        }else{
            [weak_self showMessage:resultDic[@"msg"]];
        }
        
    }];
    
}

#pragma mark ------------------------Page Navigate------------------------
-(void)jumpSearchTypeVC{
    SearchTypeVC *vc = [[SearchTypeVC alloc]init];
    [self navigatePushViewController:vc animate:YES];

}
#pragma mark ------------------------View Event---------------------------



- (UIButton *)factory_btn:(UIColor *)bcolor textColor:(UIColor *)tcolor borderColor:(UIColor *)dcolor title:(NSString *)title fontsize:(int)fsize corner:(float)csize
                tag:(int)tag;
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = bcolor;
    btn.layer.borderColor = dcolor.CGColor;
    [btn setTitleColor:tcolor forState:UIControlStateNormal];
    btn.layer.borderWidth = 1.;
    btn.layer.cornerRadius = csize;
    btn.titleLabel.font = CUSTOMFONT(fsize);
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.tag = tag;
    return btn;
}


- (void)btnClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    for(UIView *vv in self.bgScrolleView.subviews)
    {
        if([vv isKindOfClass:[UIButton class]])
        {
            UIButton *_btn = (UIButton *)vv;
            _btn.backgroundColor = kGetColor(0xf5, 0xf5, 0xf5);
            _btn.layer.borderColor = kGetColor(0xf5, 0xf5, 0xf5).CGColor;
            [_btn setTitleColor:kGetColor(0x22, 0x22, 0x22) forState:UIControlStateNormal];
        }
    }
    btn.backgroundColor = kGetColor(0xff, 0xff, 0xff);
    btn.layer.borderColor = KCOLOR_Main.CGColor;
    [btn setTitleColor:KCOLOR_Main forState:UIControlStateNormal];
    
    NSString *str = btn.titleLabel.text;
    NSArray *temparr = [self.dataDic allKeys];
    
    if(self.apiCount == 2)
    {
        SetSpecModel *mm = [self.dataDic objectForKey:self.selcted_lastSpec];
        for(SetSpecModel *_tmp in mm.subCateGory)
        {
            if([_tmp.cateGoryName isEqualToString:str])
            {
                self.selected_goods_name = [self.selected_goods_name stringByAppendingFormat:@"%@",_tmp.cateGoryName];
                self.selected_goods_id = [self.selected_goods_id stringByAppendingFormat:@"%@",_tmp.cateGoryId];
                NSLog(@"选中类目 = %@，类目ID = %@",self.selected_goods_name,self.selected_goods_id);
                [self.delegate specsConfirmInfo:self.selected_goods_name idstring:self.selected_goods_id];
                [self.navigationController popViewControllerAnimated:YES];
                break;
            }
        }
    }
    
    for(int i=0;temparr.count;i++)
    {
        SetSpecModel *sm = [self.dataDic objectForKey:temparr[i]];
        for(SetSpecModel *mm in sm.subCateGory)
        {
            if([mm.cateGoryName isEqualToString:str])
            {
                if(self.apiCount == 0)
                {
                    [self _requestDataWithID:[mm.cateGoryId intValue]];
                    self.apiCount = 1;
                    self.selected_goods_name = [self.selected_goods_name stringByAppendingFormat:@"%@/%@/",sm.cateGoryName,mm.cateGoryName];
                                    
                    self.selected_goods_id = [self.selected_goods_id stringByAppendingFormat:@"%@/%@/",sm.cateGoryId,mm.cateGoryId];
                }
                else if(self.apiCount == 1)
                {
                    self.selcted_lastId    = mm.cateGoryId;
                    self.selcted_lastSpec  = mm.cateGoryName;
                    [self _requestDataWithProductID:mm.cateGoryId];
                    self.apiCount = 2;
                    self.selected_goods_name = [self.selected_goods_name stringByAppendingFormat:@"%@/%@/",sm.cateGoryName,mm.cateGoryName];
                                    
                    self.selected_goods_id = [self.selected_goods_id stringByAppendingFormat:@"%@/%@/",sm.cateGoryId,mm.cateGoryId];
                }
                NSLog(@"选中类目 = %@，类目ID = %@",self.selected_goods_name,self.selected_goods_id);
                
                return;
            }
        }
    }
    
}


#pragma mark ------------------------ 返回上级页面
- (void)backFrontController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark ------------------------Delegate-----------------------------

@end
