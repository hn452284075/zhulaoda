//
//  PublishGoodsVC.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/2.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "PublishGoodsVC.h"
#import "PublishGoodsHeaderView.h"
#import "PublishGoodsFooterView.h"
#import "SetPriceViewController.h"
#import "SetSpecsViewController.h"
#import "SetExpressViewController.h"
#import "SetDetailInfoViewController.h"
#import "SetPriceModel.h"
#import "UploadPhotoManager.h"
#import "HXPhotoPicker.h"
#import "UIView+Frame.h"
#import "IQKeyboardManager.h"
#import "JWAddressPickerView.h"
@interface PublishGoodsVC ()<HXPhotoViewDelegate,SetPriceCompelteDelegate,SetSpecsInfoDelegate,SetExpressDelegate,SetDetailInfoDelegate,HXPhotoViewCellCustomProtocol>

@property (nonatomic, strong)NSMutableArray *dataArr;//图片和视频数据流
@property (nonatomic, strong)NSMutableArray *dataUrlArr;//图片和视频地址
@property (nonatomic,strong)NSMutableArray *priceArray;//价格数组
@property (strong, nonatomic)HXPhotoView *photoView;
@property (strong, nonatomic)HXPhotoManager *manager;
@property (assign, nonatomic)CGRect photoViewFrame;
@property (strong, nonatomic)UIScrollView *scrollView;
@property (nonatomic,strong)PublishGoodsHeaderView *header;
@property (nonatomic,strong)PublishGoodsFooterView *footer;
@property (nonatomic,strong)NSString *categoryId;//类目ID(第四级)
@property (nonatomic,strong)NSString *productId;//品类ID(第四级)
@property (nonatomic,strong)NSString *quantity;//起批量
@property (nonatomic,strong)NSString *unit;//起批量
@property (nonatomic,strong)NSString *templateId;//模板id
@property (nonatomic,strong)NSString *expressname;//物流名称
@property (nonatomic,strong)NSString *templateName;//模板名称
@property (nonatomic,strong)NSString *saveOrShelves;//上架还是保存
@property (nonatomic,strong)NSArray  *tmpPriceArray;  //用来临时装设置价格页面返回的数据
@property (nonatomic,assign)NSInteger currentPhotoIndex;

//详情选取的图片
@property (nonatomic, strong)NSMutableArray *dataDetailsArr;//图片和视频数据流
@property (nonatomic, strong)NSMutableArray *dataDetailsUrlArr;//图片和视频地址
@property (nonatomic,strong)UILabel *photoDetailsLabel;
@property (strong, nonatomic)HXPhotoView *photoDetailsView;
@property (strong, nonatomic)HXPhotoManager *managerDetails;
@property (assign, nonatomic)CGRect photoDetailsFrame;


@end

@implementation PublishGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initUI];
    
    [kNotification addObserver:self selector:@selector(type:) name:@"goodsType" object:nil];
    
    if (!isEmpty(self.goodsId)) {//修改页面进来
        [self _requestGoodsInfo];
        self.pageTitle=@"编辑商品";
    }else{
        self.pageTitle=@"发布商品";
    }
    
    self.dataDetailsUrlArr=[[NSMutableArray alloc]init];
}

-(void)dealloc{
    [kNotification removeObserver:self];
}

- (void)type:(NSNotification *)info {
    NSDictionary *dic = info.object;
    _header.typeLabel.text = [NSString stringWithFormat:@"%@/%@",dic[@"categoryName"],dic[@"name"]];
    _header.typeLabel.textColor = UIColorFromRGB(0x111111);
    _categoryId = [NSString stringWithFormat:@"%@",dic[@"categoryId"]];
    _productId  = [NSString stringWithFormat:@"%@",dic[@"id"]];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //写入这个方法后,这个页面将没有这种效果
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //最后还设置回来,不要影响其他页面的效果
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}


#pragma mark ------------------------Init---------------------------------
-(void)_initUI{

        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
       _scrollView.backgroundColor = [UIColor whiteColor];
          _scrollView.alwaysBounceVertical = YES;
          [self.view addSubview:_scrollView];
       [_scrollView addSubview:self.header];
            
 
    CGFloat bottomH=56;
    if (IS_Iphonex_Series) {
        bottomH = 100;
    }
    
    //底部的确定按钮
    UIView *bootView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kStatusBarAndNavigationBarHeight-bottomH, kScreenWidth, bottomH)];
    bootView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bootView];
    if (isEmpty(self.goodsId)) {
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(14, 10, kScreenWidth-28, 40)];
    [bootView addSubview:okBtn];
    [self factory_btn:okBtn
           backColor:KCOLOR_Main
           textColor:[UIColor whiteColor]
         borderColor:KCOLOR_Main
               title:@"确认发布"
            fontsize:18
              corner:20
                 tag:2];
    }else{//编辑商品bottom
        
        UIButton *shelvesBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-100-14, 10, 100, 40)];
        [bootView addSubview:shelvesBtn];
        [shelvesBtn setTitle:@"保存并上架" forState:UIControlStateNormal];
        shelvesBtn.titleLabel.font=CUSTOMFONT(16);
        [shelvesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [shelvesBtn addTarget:self action:@selector(saveWithShelvesClick:) forControlEvents:UIControlEventTouchUpInside];
        [shelvesBtn setBackgroundColor:KCOLOR_Main];
        shelvesBtn.tag=1;
        //创建 layer
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
          maskLayer.frame = shelvesBtn.bounds;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: maskLayer.frame = shelvesBtn.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(20,20)];
        maskLayer.frame = shelvesBtn.bounds;
        maskLayer.path = maskPath.CGPath;
        shelvesBtn.layer.mask = maskLayer;
        
        
        UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-100-100-14, 10, 100, 40)];
        [bootView addSubview:saveBtn];
        [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        saveBtn.titleLabel.font=CUSTOMFONT(16);
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        saveBtn.tag=0;
        [saveBtn addTarget:self action:@selector(saveWithShelvesClick:) forControlEvents:UIControlEventTouchUpInside];
        [saveBtn setBackgroundColor:UIColorFromRGB(0xFFB400)];
        //创建 layer
        CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
          maskLayer2.frame = saveBtn.bounds;
        UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect: maskLayer2.frame = saveBtn.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(20,20)];
        maskLayer2.frame = saveBtn.bounds;
        maskLayer2.path = maskPath2.CGPath;
        saveBtn.layer.mask = maskLayer2;
        
        
        UIButton *deleBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        deleBtn.frame = CGRectMake(13, 0, 50, 56);
        [deleBtn setTitle:@"删除" forState:UIControlStateNormal];
        deleBtn.titleLabel.font=CUSTOMFONT(14);
        [deleBtn setTitleColor:UIColorFromRGB(0x9a9a9a) forState:UIControlStateNormal];
        [deleBtn addTarget:self action:@selector(deleteGoods) forControlEvents:UIControlEventTouchUpInside];
        [bootView addSubview:deleBtn];
        
        
    }
    

    
        HXPhotoView *photoView = [HXPhotoView photoManager:self.manager scrollDirection:UICollectionViewScrollDirectionVertical];
        photoView.frame = CGRectMake(0, self.header.bottom, kScreenWidth, 0);
        
        photoView.backgroundColor = [UIColor whiteColor];
        photoView.collectionView.contentInset = UIEdgeInsetsMake(5, 12, 0, 12);
        photoView.spacing = 12;
        photoView.delegate = self;
        photoView.lineCount=4;
        photoView.outerCamera = YES;
        photoView.showAddCell = YES;
        [photoView.collectionView reloadData];
        [_scrollView addSubview:photoView];
        self.photoView = photoView;
        self.photoView.tag=100;
        
        [_scrollView addSubview:self.photoDetailsLabel];
    
       HXPhotoView *photoView2 = [HXPhotoView photoManager:self.managerDetails scrollDirection:UICollectionViewScrollDirectionVertical];
       photoView2.frame = CGRectMake(0,self.header.bottom+120, kScreenWidth, 0);
       
       photoView2.backgroundColor = [UIColor whiteColor];
       photoView2.collectionView.contentInset = UIEdgeInsetsMake(5, 12, 0, 12);
       photoView2.spacing = 12;
       photoView2.delegate = self;
       photoView2.lineCount=4;
       photoView2.outerCamera = YES;
       photoView2.showAddCell = YES;
       [photoView2.collectionView reloadData];
       [_scrollView addSubview:photoView2];
       self.photoDetailsView = photoView2;
       self.photoDetailsView.tag=200;
    
        [_scrollView addSubview:self.footer];
        
}


 

#pragma mark ------------------------View Event---------------------------
-(void)saveWithShelvesClick:(UIButton *)btn{
    _saveOrShelves = [NSString stringWithFormat:@"%ld",btn.tag];
    [self confirmBtnClick];
}
#pragma mark ------------------------Private------------------------------
- (void)factory_btn:(UIButton *)btn backColor:(UIColor *)bcolor textColor:(UIColor *)tcolor borderColor:(UIColor *)dcolor title:(NSString *)title fontsize:(int)fsize corner:(float)csize
                tag:(int)tag;
{
    btn.backgroundColor = bcolor;
    btn.layer.borderColor = dcolor.CGColor;
    [btn setTitleColor:tcolor forState:UIControlStateNormal];
    btn.layer.borderWidth = 1.;
    btn.layer.cornerRadius = csize;
    btn.titleLabel.font = CUSTOMFONT(fsize);
    [btn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.tag = tag;
}

#pragma mark ------------------------Api----------------------------------
#pragma mark--查询商品信息
-(void)_requestGoodsInfo{
    
    WEAK_SELF
    [self showHub];
    __block NSMutableArray *pricearr=[[NSMutableArray alloc]init];
    
    [AFNHttpRequestOPManager postWithParameters:@{@"goodsId":self.goodsId} subUrl:@"ShopApi/getGoodsById" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
            weak_self.categoryId = resultDic[@"params"][@"categoryId"];
        weak_self.footer.detailsLabel.text=resultDic[@"params"][@"detail"];
            weak_self.footer.detailsLabel.textColor = UIColorFromRGB(0x111111);
        weak_self.footer.originField.text=resultDic[@"params"][@"place"];
            weak_self.unit=resultDic[@"params"][@"unit"];
            weak_self.quantity =[NSString stringWithFormat:@"%@",resultDic[@"params"][@"quantity"]];
            weak_self.templateId=[NSString stringWithFormat:@"%@",resultDic[@"params"][@"templateId"]];
            weak_self.header.titleField.text = resultDic[@"params"][@"name"];
            weak_self.header.typeLabel.textColor = UIColorFromRGB(0x111111);
            weak_self.header.typeLabel.text =resultDic[@"params"][@"categoryName"];
            weak_self.expressname =resultDic[@"params"][@"materials"];
            weak_self.templateName=resultDic[@"params"][@"templateName"];
            weak_self.footer.logisticsLabel.text=[NSString stringWithFormat:@"%@%@",weak_self.expressname,weak_self.templateName];
            weak_self.footer.logisticsLabel.textColor = UIColorFromRGB(0x111111);
            weak_self.productId=resultDic[@"params"][@"productId"];
            weak_self.dataUrlArr=[NSMutableArray arrayWithArray:resultDic[@"params"][@"picUrls"]];
            weak_self.dataDetailsUrlArr=[NSMutableArray arrayWithArray:resultDic[@"params"][@"detailsPicsUrls"]];
            
            NSArray *arr=resultDic[@"params"][@"goodsSpecifications"];
            for (int a=0; a<arr.count; a++) {
                NSDictionary *dic = arr[a];
                SetPriceModel *pmodel = [[SetPriceModel alloc]init];
                pmodel.priceSpec=[NSString stringWithFormat:@"%@",dic[@"specification"]];
                pmodel.pricevalue=[NSString stringWithFormat:@"%@",dic[@"unit_price"]];
                [pricearr addObject:pmodel];
            }
             
            [weak_self priceView:pricearr];
        
            //编辑商品轮播图赋值
            if (weak_self.dataUrlArr.count>0) {
        
            NSMutableArray *assets = @[].mutableCopy;
          for (NSString *url in weak_self.dataUrlArr) {
              
              if ([url containsString:@"mp4"]) {
              HXCustomAssetModel *assetVideo = [HXCustomAssetModel assetWithLocalVideoURL:[NSURL URLWithString:url] selected:YES];
                  [assets addObject:assetVideo];
              }else{
                  HXCustomAssetModel *asset = [HXCustomAssetModel assetWithNetworkImageURL:[NSURL URLWithString:url] selected:YES];
                  [assets addObject:asset];
              }
              
              
            }
                [weak_self.manager addCustomAssetModel:assets];
                [weak_self.photoView refreshView];
            }
            
            //编辑商品详情图赋值
                if (weak_self.dataDetailsUrlArr.count>0) {
            
                NSMutableArray *assets = @[].mutableCopy;
              for (NSString *url in weak_self.dataDetailsUrlArr) {
                  
                  if ([url containsString:@"mp4"]) {
                  HXCustomAssetModel *assetVideo = [HXCustomAssetModel assetWithLocalVideoURL:[NSURL URLWithString:url] selected:YES];
                      [assets addObject:assetVideo];
                  }else{
                      HXCustomAssetModel *asset = [HXCustomAssetModel assetWithNetworkImageURL:[NSURL URLWithString:url] selected:YES];
                      [assets addObject:asset];
                  }
                  
                  
                }
                    [weak_self.managerDetails addCustomAssetModel:assets];
                    [weak_self.photoDetailsView refreshView];
                }
            
            
        }else{
            [weak_self goBack];
            [weak_self showMessage:resultDic[@"desc"]];
            
        }
        
    }];
    
}
#pragma mark--提交所有图片
-(void)confirmBtnClick{
    
    NSLog(@"%@",_categoryId);
    if(_categoryId == nil || _footer.detailsLabel.text == nil ||
       _header.titleField.text == nil || _footer.originField.text == nil ||
       self.quantity == nil || self.unit==nil)
    {
        [self showMessage:@"所有选项都必须填写"];
        return;
    }
   [self showWithStatus:@"发布中..."];
    WEAK_SELF
    if (_dataArr.count>0) {//轮播图
    
    self.dataUrlArr=[[NSMutableArray alloc]init];
   dispatch_semaphore_t signal = dispatch_semaphore_create(1);
        
    for (NSDictionary *dic in self.dataArr) {
    
        if (!isEmpty(dic[@"dataUrl"])) {//dataUrl 是存放的之前上传的资源url，没有就需要上传data生成新的阿里云地址
            [weak_self.dataUrlArr addObject:dic[@"dataUrl"]];
             dispatch_semaphore_signal(signal);
        }else{
        //用日期给文件命名
         NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
         formatter.dateFormat = @"yyyyMMddHHmmss";
         NSString *fileName = [formatter stringFromDate:[NSDate date]];
        NSString *objectKey;
        int num = (arc4random() % 1000000);
        NSString *randomNumber = [NSString stringWithFormat:@"%.6d",num];
        if ([dic[@"type"]isEqualToString:@"image"]) {
            objectKey = [NSString stringWithFormat:@"ios/%@/%@.png",fileName,randomNumber];
        }else{
            objectKey = [NSString stringWithFormat:@"ios/%@/%@.mp4",fileName,randomNumber];
        }
        NSData *data = (NSData *)dic[@"data"];
        [[UploadPhotoManager sharedInstance]uploadObjectAsyncWith:data withObjectKey:objectKey withPhotoBlock:^(NSString *dataUrl) {

            [weak_self.dataUrlArr addObject:dataUrl];
              dispatch_semaphore_signal(signal);
        }];
     }
        dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    }
        
        
        //是否有详情图
        if (_dataDetailsArr.count>0) {
            
             self.dataDetailsUrlArr=[[NSMutableArray alloc]init];
             dispatch_semaphore_t signal = dispatch_semaphore_create(1);
                  
              for (NSDictionary *dic in self.dataDetailsArr) {
              
                  if (!isEmpty(dic[@"dataUrl"])) {//dataUrl 是存放的之前上传的资源url，没有就需要上传data生成新的阿里云地址
                      [weak_self.dataDetailsUrlArr addObject:dic[@"dataUrl"]];
                       dispatch_semaphore_signal(signal);
                  }else{
                  //用日期给文件命名
                   NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                   formatter.dateFormat = @"yyyyMMddHHmmss";
                   NSString *fileName = [formatter stringFromDate:[NSDate date]];
                  NSString *objectKey;
                  int num = (arc4random() % 1000000);
                  NSString *randomNumber = [NSString stringWithFormat:@"%.6d",num];
                  if ([dic[@"type"]isEqualToString:@"image"]) {
                      objectKey = [NSString stringWithFormat:@"ios/%@/%@.png",fileName,randomNumber];
                  }else{
                      objectKey = [NSString stringWithFormat:@"ios/%@/%@.mp4",fileName,randomNumber];
                  }
                  NSData *data = (NSData *)dic[@"data"];
                  [[UploadPhotoManager sharedInstance]uploadObjectAsyncWith:data withObjectKey:objectKey withPhotoBlock:^(NSString *dataUrl) {

                      [weak_self.dataDetailsUrlArr addObject:dataUrl];
                        dispatch_semaphore_signal(signal);
                  }];
               }
                  dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
              }
        }
        NSLog(@"dataUrl:%@",self.dataUrlArr);
        NSLog(@"dataDetailsUrlArr:%@",self.dataDetailsUrlArr);
        [self submitData];
    }else{
        [self showMessage:@"请选择轮播图片/视频"];
    }
    
}
#pragma mark--提交所有参数
-(void)submitData{
    
    NSString *urlStr;
    NSString *goodsid;
    if (isEmpty(self.goodsId)) {
        urlStr=@"ShopApi/publishGoods";
        goodsid =@"";
    }else{
        urlStr =[NSString stringWithFormat:@"ShopApi/saveGoods/%@",_saveOrShelves];
        goodsid = self.goodsId;
    }
 
    if (isEmpty(self.dataUrlArr)) {
        [self showMessage:@"图片/视频上传失败"];
        return;
    }
    
    NSDictionary *params;
    NSString *details;
    if ([_footer.detailsLabel.text isEqualToString:@"请填写详情"]) {
        details=@"";
    }else{
        details=_footer.detailsLabel.text;
    }
    if (isEmpty(_expressname)) {
         params=@{@"categoryId":_categoryId,@"detail":details,@"goodsSpecifications":self.priceArray,@"materials":@"运费待商议",@"name":_header.titleField.text,@"picUrls":self.dataUrlArr,@"place":_footer.originField.text,@"quantity":self.quantity,@"unit":self.unit,@"productId":_productId,@"goodsId":goodsid,@"detailsPicsUrls":self.dataDetailsUrlArr,};
        
    }else{
        params=@{@"categoryId":_categoryId,@"detail":details,@"goodsSpecifications":self.priceArray,@"templateName":[NSString isEmptyForString:_templateName],@"materials":[NSString isEmptyForString:_expressname],@"name":_header.titleField.text,@"picUrls":self.dataUrlArr,@"detailsPicsUrls":self.dataDetailsUrlArr,@"place":_footer.originField.text,@"quantity":self.quantity,@"templateId":[NSString isEmptyForString:self.templateId],@"unit":self.unit,@"productId":_productId,@"goodsId":goodsid};
    }
    
    
    WEAK_SELF
    [AFNHttpRequestOPManager postBodyParameters:params subUrl:urlStr block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
          NSLog(@"resultDic:%@",resultDic);
          if ([resultDic[@"code"] integerValue]==200) {
              [weak_self showSuccessInfoWithStatus:@"发布成功"];
              emptyBlock(weak_self.goBackBlock);
              [weak_self goBack];
          }else{
              [weak_self showMessage:resultDic[@"desc"]];
          }

      }];
}


-(void)deleteGoods{
    
    
    WEAK_SELF
    
    [self showSimplyAlertWithTitle:@"提示" message:@"确定删除此商品吗?" sureAction:^(UIAlertAction *action) {
        [weak_self showHub];
           [AFNHttpRequestOPManager postWithParameters:@{@"goodsId":self.goodsId} subUrl:@"ShopApi/delGoodsById" block:^(NSDictionary *resultDic, NSError *error) {
                   
                   NSLog(@"resultDic:%@",resultDic);
                   if ([resultDic[@"code"] integerValue]==200) {
                       [weak_self showSuccessInfoWithStatus:@"删除成功"];
                       
                       emptyBlock(weak_self.goBackBlock);
                       [weak_self goBack];
                       
                       
                   }else{
                       [weak_self showMessage:resultDic[@"desc"]];
                   }
                   
               }];
           
        
    } cancelAction:^(UIAlertAction *action) {
        
    }];
   
}
#pragma mark ------------------------Page Navigate------------------------
-(void)jumoPageIndex:(NSInteger)index{
        
            
            switch (index) {
                case 0://类目
                    {
                      SetSpecsViewController *vc = [[SetSpecsViewController alloc] init];
                        vc.delegate=self;
                      [self navigatePushViewController:vc animate:YES];
                    }
                    break;
                    
                case 1://价格
                    {
                        if (isEmpty(self.categoryId)) {
                            [self showMessage:@"请先选择类目~"];
                            return;
                        }
                        
                        SetPriceViewController *priceCon = [[SetPriceViewController alloc] init];
                        priceCon.categateID = [self.categoryId intValue];
                        priceCon.delegate = self;
                        if(_unit.length>0)
                        {
                            priceCon.defaultUnit  = _unit;
                            priceCon.defaultSunit = _quantity;
                            priceCon.defaultArr   = self.tmpPriceArray;
                        }
                        else
                        {
                            priceCon.defaultUnit  = @"";
                            priceCon.defaultSunit = @"";
                            priceCon.defaultArr   = self.tmpPriceArray;
                        }
                        
                        [self navigatePushViewController:priceCon animate:YES];
                    }
                    break;
                    
                case 2://物流
                    {
                       SetExpressViewController *vc = [[SetExpressViewController alloc] init];
                        vc.delegate = self;
                       [self navigatePushViewController:vc animate:YES];
                    }
                    break;
                    
                case 3://详情
                    {
                        SetDetailInfoViewController *vc = [[SetDetailInfoViewController alloc] init];
                        vc.delegate = self;
                        vc.desc=[self.footer.detailsLabel.text isEqualToString:@"请填写详情"]?@"":self.footer.detailsLabel.text;
                        [self navigatePushViewController:vc animate:YES];
                    }
                    break;
                        
              
                    
                
     
                default:
                    break;
            }
            
 
}

#pragma mark ------------------------Getter / Setter----------------------
- (UILabel *)photoDetailsLabel{
    if (!_photoDetailsLabel) {
        _photoDetailsLabel=[[UILabel alloc]init];
        _photoDetailsLabel.text = @"详情图（选填）";
        _photoDetailsLabel.font=[UIFont systemFontOfSize:14];
        _photoDetailsLabel.textAlignment=NSTextAlignmentLeft;
    }
    return _photoDetailsLabel;
}
- (PublishGoodsHeaderView *)header{
    if (!_header) {
        _header = BoundNibView(@"PublishGoodsHeaderView", PublishGoodsHeaderView);
        _header.frame = CGRectMake(0, 0, kScreenWidth, 148);
        [_header.categoryBtn addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [self jumoPageIndex:0];
        }];
       }
       return _header;
}

- (PublishGoodsFooterView *)footer {

    if (!_footer) {
        _footer = BoundNibView(@"PublishGoodsFooterView", PublishGoodsFooterView);
        _footer.frame=CGRectMake(0, _photoDetailsView.bottom, kScreenWidth,_footer.height);
        
        WEAK_SELF
        _footer.seletecdIndexBlock = ^(NSInteger index) {
            [weak_self jumoPageIndex:index];
        };
        [_footer.priceBgView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [weak_self jumoPageIndex:1];
        }];
        
        [_footer.originBtn addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [weak_self.view endEditing:YES];
            JWAddressPickerView *tmppick = [JWAddressPickerView showWithAddressBlock:^(NSString *province, NSString *city, NSString *area) {
                   
                weak_self.footer.originField.text =[NSString stringWithFormat:@"%@-%@-%@",province,city,area];
            }];
            if([weak_self.footer.originField.text rangeOfString:@"-"].location != NSNotFound)
            {
                NSArray *tmpArray = [weak_self.footer.originField.text componentsSeparatedByString:@"-"];
                [tmppick setDefaultPro:tmpArray[0] city:tmpArray[1] town:tmpArray[2]];
            }
            
        }];
      
        
    }
    return _footer;
}
 


- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _manager.configuration.saveSystemAblum = YES;
        _manager.configuration.videoMaximumDuration=30;
        _manager.configuration.type = HXConfigurationTypeWXChat;
    }
    return _manager;
}

- (HXPhotoManager *)managerDetails{
    if (!_managerDetails) {
        _managerDetails = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _managerDetails.configuration.saveSystemAblum = YES;
        _managerDetails.configuration.photoMaxNum = 9;
        _managerDetails.configuration.maxNum=9;
        _managerDetails.configuration.videoMaxNum=0;
//        _manager.configuration.type = HXConfigurationTypeWXChat;
    }
    return _managerDetails;
}


#pragma mark ------------------------Delegate-----------------------------
 
#pragma mark ------------ 选取图片和视频
- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    WEAK_SELF
    self.currentPhotoIndex =photoView.tag;
    if (self.currentPhotoIndex==100) {//轮播图资源
        self.dataArr = [[NSMutableArray alloc]init];
        self.dataUrlArr = [[NSMutableArray alloc]init];
    }else{//详情
        self.dataDetailsUrlArr = [[NSMutableArray alloc]init];
        self.dataDetailsArr = [[NSMutableArray alloc]init];
    }
    
    
    NSLog(@"%@",allList);
    NSLog(@"%ld",photoView.tag);
 // 1.创建一个串行队列，保证for循环依次执行
    dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    // 2.异步执行任务
    dispatch_async(serialQueue, ^{
    // 3.创建一个数目为1的信号量，用于“卡”for循环，等上次循环结束在执行下一次的for循环
    dispatch_semaphore_t sema = dispatch_semaphore_create(1);
            
        
    for (HXPhotoModel *model in allList) {
        
       
               printf("信号量等待中\n");
        //地址不为空,处理逻辑是有图片url就直接存，当增加了图片就去取资源--编辑商品图片逻辑
        if (!isEmpty(model.networkPhotoUrl)) {
            if (weak_self.currentPhotoIndex==100){
            [weak_self.dataArr addObject:@{@"dataUrl":model.networkPhotoUrl.absoluteString}];
            }else{
            [weak_self.dataDetailsArr addObject:@{@"dataUrl":model.networkPhotoUrl.absoluteString}];
            }
            
            self.manager.configuration.photoCanEdit = NO;
            self.manager.configuration.videoCanEdit = NO;
            self.managerDetails.configuration.photoCanEdit = NO;
            self.managerDetails.configuration.videoCanEdit = NO;
            dispatch_semaphore_signal(sema);
            
        }
        
        //地址不为空,处理逻辑是有视频url就直接存，当增加了视频就去取资源--编辑商品视频逻辑
        if (!isEmpty(model.videoURL)){
            //model.videoURL 编辑后就有值，判断是否是网络视频地址
            if ([model.videoURL.absoluteString containsString:@"http"]) {
                if (weak_self.currentPhotoIndex==100){
                [weak_self.dataArr addObject:@{@"dataUrl":model.videoURL.absoluteString}];
                }
                self.manager.configuration.videoCanEdit = NO;
                self.manager.configuration.photoCanEdit = NO;
                self.managerDetails.configuration.photoCanEdit = NO;
                self.managerDetails.configuration.videoCanEdit = NO;
                dispatch_semaphore_signal(sema);
                
            }
             
        }
        
        
        
        
        //取视频资源
        if (model.subType==1) {//视频
            NSLog(@"%@",model.videoURL);
            NSLog(@"%@",model.asset);
          
            if (model.videoURL) {//编辑后才有的路径
            NSData* videoData = [NSData dataWithContentsOfURL:model.videoURL];
                if (weak_self.currentPhotoIndex==100){
                 [weak_self.dataArr addObject:@{@"type":@"video",@"data":videoData}];
                }
               
            
                dispatch_semaphore_signal(sema);
                
            }else{
            
            if (!isEmpty(model.asset)) {
                
          PHVideoRequestOptions* options = [[PHVideoRequestOptions alloc] init];
            options.version = PHVideoRequestOptionsVersionOriginal;
            options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
            options.networkAccessAllowed = YES;
            [[PHImageManager defaultManager] requestAVAssetForVideo:model.asset options:options resultHandler:^(AVAsset* avasset, AVAudioMix* audioMix, NSDictionary* info){
                AVURLAsset *videoAsset = (AVURLAsset*)avasset;
                NSLog(@"AVAsset URL: %@",videoAsset.URL);
                NSError* error = nil;
                NSData* videoData = [NSData dataWithContentsOfURL:videoAsset.URL options:NSDataReadingUncached error:&error];
                if (weak_self.currentPhotoIndex==100){
                    [weak_self.dataArr addObject:@{@"type":@"video",@"data":videoData}];
                    dispatch_semaphore_signal(sema);
                }
                
                
             }];
            }
           
          }
        }else{//图片
        
            NSLog(@"end");
            
            
            if (model.imageURL) {//编辑后才有的路径
                
                NSLog(@"%@",model.imageURL);

                
                NSData *imageData=[UIImage imageData:model.previewPhoto];
                
                if (weak_self.currentPhotoIndex==100){
                   [weak_self.dataArr addObject:@{@"type":@"image",@"data":imageData}];
                }else{
                   [weak_self.dataDetailsArr addObject:@{@"type":@"image",@"data":imageData}];
                }
                
                   dispatch_semaphore_signal(sema);
                
                
            }else{
            if (!isEmpty(model.asset)) {
            
                        
                PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
                options.synchronous = YES;
                options.networkAccessAllowed = YES;
                  
                  if (model.photoFormat==4) {
                      options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
                  }else{
                      options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;

                  }
                
                [[PHImageManager defaultManager] requestImageForAsset:model.asset targetSize:PHImageManagerMaximumSize  contentMode:PHImageContentModeAspectFit  options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                 
                    NSData *imageData=[UIImage imageData:result];
 
                    if (weak_self.currentPhotoIndex==100){
                       [weak_self.dataArr addObject:@{@"type":@"image",@"data":imageData}];
                    }else{
                       [weak_self.dataDetailsArr addObject:@{@"type":@"image",@"data":imageData}];
                    }
                    
                   NSLog(@"dataArr:%ld",weak_self.dataArr.count);
                   NSLog(@"datadetailsArr:%ld",weak_self.dataDetailsArr.count);
                   dispatch_semaphore_signal(sema);
            
                }];
            
                }
              }
            }
         dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
      }

    });
    
       
   
 }

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    NSSLog(@"%@",NSStringFromCGRect(frame));
    
    NSLog(@"%ld",photoView.tag);
    if (photoView.tag==200) {
        self.photoDetailsFrame=frame;
    }else{
        self.photoViewFrame=frame;
        self.photoView.frame = self.photoViewFrame;
    }
    
     self.photoDetailsLabel.frame=CGRectMake(14.5, self.photoView.bottom+16, 150, 20);
    
     self.photoDetailsView.frame = CGRectMake(0, self.photoView.bottom+40, self.photoDetailsFrame.size.width, self.photoDetailsFrame.size.height);
     self.footer.frame=CGRectMake(0, _photoDetailsView.bottom+10, kScreenWidth, self.footer.height);
    
    self.scrollView.contentSize =CGSizeMake(kScreenWidth, kScreenHeight+self.photoViewFrame.size.height+self.photoDetailsView.frame.size.height);
}

- (void)photoView:(HXPhotoView *)photoView currentDeleteModel:(HXPhotoModel *)model currentIndex:(NSInteger)index{
    
    if (!isEmpty(model.networkPhotoUrl)) {
        if (photoView.tag==100) {
            for (NSDictionary *dic in self.dataArr) {
                if ([dic[@"dataUrl"] isEqualToString:model.networkPhotoUrl.absoluteString]) {
                    [self.dataArr removeObject:dic];
                    [self.dataUrlArr removeObject:model.networkPhotoUrl.absoluteString];
                }
            }
            
        }else{
            for (NSDictionary *dic in self.dataDetailsArr) {
                if ([dic[@"dataUrl"] isEqualToString:model.networkPhotoUrl.absoluteString]) {
                    [self.dataDetailsArr removeObject:dic];
                    [self.dataDetailsUrlArr removeObject:model.networkPhotoUrl.absoluteString];
                }
            }
        }

        
    }
    
    if ([model.videoURL.absoluteString containsString:@"http"]) {
//        for (NSDictionary *dic in self.annexesArr) {
//            if ([dic[@"picUrl"] isEqualToString:model.videoURL.absoluteString]) {
//                NSLog(@"删除:%@",dic[@"id"]);
//                [self deleteImageId:dic[@"id"]];
//            }
//        }

    }
    
    
}

#pragma mark ------------ 设置价格参数
- (void)priceInfoOfSpecs:(NSString *)unit sunit:(NSString *)sunit specsArr:(NSArray *)arr
{
    _quantity=sunit;
    _unit=unit;
    NSLog(@"计量单位 = %@  起批量 = %@",unit,sunit);
    self.tmpPriceArray = arr;
    [self priceView:arr];
}
 
-(void)priceView:(NSArray*)arr{
    self.priceArray = [[NSMutableArray alloc]init];
    for(int i=0;i<arr.count;i++)
       {
           SetPriceModel *pm = [arr objectAtIndex:i];
           NSLog(@"规格 = %@  价格 = %@",pm.priceSpec,pm.pricevalue);
           [self.priceArray addObject:@{@"specification":pm.priceSpec,@"unit_price":pm.pricevalue}];
       }
    
    UIView *v = [_footer.priceBgView viewWithTag:1212];
    [v removeFromSuperview];
    
          UIView *priceV = [self priceCellView:(NSMutableArray *)arr];
          priceV.tag = 1212;
          priceV.frame = CGRectMake(0, 0, priceV.width, priceV.height);
          [_footer.priceBgView addSubview:priceV];
          [_footer.priceBgView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
              [self jumoPageIndex:1];
          }];
    
    
          _footer.priceBgViewHeight.constant=priceV.height;
        if (arr.count>1) {
        _footer.frame=CGRectMake(0, _photoView.bottom, kScreenWidth, 235+priceV.height);
        }
         
          _footer.priceLabel.hidden=YES;
}
#pragma mark ------------ 类目选择完成
- (void)specsConfirmInfo:(NSString *)spstr idstring:(NSString *)idstr
{
    _header.typeLabel.text = spstr;
    _header.typeLabel.textColor = UIColorFromRGB(0x111111);
    
    NSArray *idarr = [idstr componentsSeparatedByString:@"/"];
    _productId  = [idarr lastObject];

   _categoryId = [idarr objectAtIndex:3];
    NSLog(@"类目名称 = %@  类目ID = %@  品类ID = %@",spstr,_categoryId,_productId);
}

#pragma mark ------------ 运费模板选择完成
- (void)confirmExpressInfo:(NSString *)exway name:(NSString *)moduldname moduleId:(int)mid
{
    
    _footer.logisticsLabel.text = [NSString stringWithFormat:@"%@;%@",exway,moduldname];
    _expressname = exway;
    _footer.logisticsLabel.textColor = UIColorFromRGB(0x111111);
    _templateName=moduldname;
    if (mid==0) {//没有选择模板
        _templateId=@"";
    }else{
       _templateId = [NSString stringWithFormat:@"%d",mid];
    }
}

#pragma mark ------------ 详细信息填写完成
- (void)detailInfoMsg:(NSString *)string
{
    _footer.detailsLabel.text = string;
    _footer.detailsLabel.textColor = UIColorFromRGB(0x111111);
    
}

 

/////////////////////// 价格Cell view
- (UIView *)priceCellView:(NSMutableArray *)array
{
//    for(int i=0;i<array.count;i++)
//    {
//        SetPriceModel *pm = array[i];
//        pm.priceSpec = [NSString stringWithFormat:@"规格%d",i];
//        pm.pricevalue = [NSString stringWithFormat:@"%d.00元/斤",i+1];
//        [array addObject:pm];
//    }
    
    UIView *bgv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-100, array.count*25+25)];

    
    int x = 10;
    int y = 13;
    int w = ((kScreenWidth-100)-x-y*2-10)/2;
    int h = 25;
    for(int i=0;i<array.count;i++)
    {
        SetPriceModel *pm = [array objectAtIndex:i];
        
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(x, y+h*i, w, h)];
        [bgv addSubview:lab1];
        lab1.text = pm.priceSpec;
        lab1.textColor = UIColorFromRGB(0x343434);
        lab1.font = CUSTOMFONT(14);
        lab1.textAlignment = NSTextAlignmentLeft;
        
        UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(x+w, y+h*i, w, h)];
        [bgv addSubview:lab2];
        lab2.text = [NSString stringWithFormat:@"%@ 元/%@",pm.pricevalue,_unit];
        lab2.textColor = UIColorFromRGB(0x343434);
        lab2.font = CUSTOMFONT(14);
        lab2.textAlignment = NSTextAlignmentRight;
    }
    return bgv;
}

 

@end
