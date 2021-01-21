//
//  GoodsSpecsViewController.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/1.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "SetSpecsViewController.h"

@interface SetSpecsViewController ()

@property (nonatomic, strong) UIScrollView  *bgScrolleView;

@property (nonatomic, strong) NSMutableDictionary   *testDic;

@end

@implementation SetSpecsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //test data
    NSArray *arr_1 = [[NSArray alloc] initWithObjects:@"农产品1",@"农产品2",@"农产品3",@"农产品4",@"农产品5",@"农产品6",@"农产品7", nil];
    
    NSArray *arr_2 = [[NSArray alloc] initWithObjects:@"鱼苗1",@"鱼苗2",@"鱼苗5",@"鱼苗6",@"鱼苗7", nil];
    
    NSArray *arr_3 = [[NSArray alloc] initWithObjects:@"农机1",@"农机2",@"农机3",@"农机4",@"农机5",@"农机7", nil];
    
    NSArray *arr_4 = [[NSArray alloc] initWithObjects:@"野猪1",@"野猪2",@"野猪3",@"野猪4",@"野猪5",@"野猪7", nil];
    
    NSArray *arr_5 = [[NSArray alloc] initWithObjects:@"山鸡1",@"山鸡2",@"山鸡3",@"山鸡4",@"山鸡5",@"山鸡7", nil];
    
    self.testDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:arr_1,@"农产品",arr_2,@"农机",arr_3,@"鱼苗",arr_4,@"野猪",arr_5,@"山鸡", nil];
    
    
    //顶部view
    self.title = @"选择商品类目";
    
    self.bgScrolleView = [[UIScrollView alloc] init];
    [self.view addSubview:self.bgScrolleView];
    [self.bgScrolleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self _initSpcesTag];
    });
    
}


#pragma mark ------------------------Init---------------------------------
- (void)_initSpcesTag
{
    int x = 15;
    int y = 15;
    int size_w = (kScreenWidth-2*15-2*10)/3;
    int size_h = 31;
    
    NSArray *temparr = [self.testDic allKeys];
    int tagCount = 0;
    for(int i=0;i<temparr.count;i++)
    {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, y, kScreenWidth, 50)];
        v.backgroundColor = UIColorFromRGB(0xf7f7f7);
        [self.bgScrolleView addSubview:v];
        
        y+=50;
        y+=20;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 15, 250, 20)];
        label.text = temparr[i];
        label.textColor = UIColorFromRGB(0x9a9a9a);
        label.textAlignment = NSTextAlignmentLeft;
        [v addSubview:label];
        
        NSArray *valueArray = [self.testDic objectForKey:temparr[i]];
        NSMutableArray *tagBtnArray = [[NSMutableArray alloc] init];
        for(int j=0;j<valueArray.count;j++)
        {
            UIButton *btn = [self factory_btn:kGetColor(0xf5, 0xf5, 0xf5)
              textColor:kGetColor(0x22, 0x22, 0x22)
            borderColor:kGetColor(0xf5, 0xf5, 0xf5)
                  title:[valueArray objectAtIndex:j]
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
                    y = y+15;
                    break;
                }
            }
        }
        y = y + row*h + (row+1)*8;
        self.bgScrolleView.contentSize = CGSizeMake(kScreenWidth, y);
    }
}

#pragma mark ------------------------Api----------------------------------
#pragma mark ------------------------Page Navigate------------------------

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
    btn.layer.borderColor = kGetColor(0x46, 0xc6, 0x7c).CGColor;
    [btn setTitleColor:kGetColor(0x46, 0xc6, 0x7c) forState:UIControlStateNormal];
    
    NSString *str = btn.titleLabel.text;
    NSArray *temparr = [self.testDic allKeys];
    for(int i=0;temparr.count;i++)
    {
        NSArray *_arr = [self.testDic objectForKey:temparr[i]];
        if([_arr containsObject:str])
        {
            
            NSLog(@"选中的类目 = %@，子类别 = %@",temparr[i],str);
            
            break;
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
