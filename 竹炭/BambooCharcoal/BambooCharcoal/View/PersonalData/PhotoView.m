//
//  PhotoView.m
//  BloodSugar-Patient
//
//  Created by 曾勇兵 on 2020/7/9.
//  Copyright © 2020 wangyan. All rights reserved.
//

#import "PhotoView.h"
#import "UIView+BlockGesture.h"
#import "UploadPhotoManager.h"
static PhotoView *_photoManager = nil;
@implementation PhotoView
+ (instancetype)photoManager{
    static dispatch_once_t onceToken;
       
       dispatch_once(&onceToken, ^{
           
           _photoManager = [[PhotoView alloc] init];
           
       });
       
       return _photoManager;
}
- (void)seletecdIndexBlock:(SeletecdIndexBlock)seletecdIndexBlock{
    

     _viewBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _viewBG.tag=777;
    _viewBG.backgroundColor =  [UIColor colorWithWhite:0.f alpha:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview:_viewBG];
    WEAK_SELF
    [_viewBG addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [weak_self colse];
    }];
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 232)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView.tag=999;
       //UIView设置阴影UIColorFromRGB(0xacacac).CGColor;
    self.bottomView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.bottomView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.bottomView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    self.bottomView.layer.shadowRadius = 5;//阴影半径，默认3
    self.bottomView.layer.masksToBounds = NO;
    [_viewBG addSubview:self.bottomView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-50, 18, 100, 20)];
    titleLabel.textColor = UIColorFromRGB(0x111111);
    titleLabel.textAlignment=1;
    titleLabel.text = @"上传头像";
    titleLabel.font=CUSTOMFONT(18);
    [self.bottomView addSubview:titleLabel];
    //图片在上 文字在下
    UIButton *shootingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shootingBtn.frame = CGRectMake(kScreenWidth/2-30-60, 74, 60, 85);
    shootingBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [shootingBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [shootingBtn setImage:IMAGE(@"shooting") forState:UIControlStateNormal];
    [shootingBtn setTitle:@"拍摄照片" forState:UIControlStateNormal];
    [shootingBtn addTarget:self action:@selector(shootingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    CGFloat offset = 15.0f;
    shootingBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -shootingBtn.imageView.frame.size.width, -shootingBtn.imageView.frame.size.height-offset/2, 0);
    shootingBtn.imageEdgeInsets = UIEdgeInsetsMake(-shootingBtn.titleLabel.intrinsicContentSize.height-offset/2, 0, 0, -shootingBtn.titleLabel.intrinsicContentSize.width);
    [_bottomView addSubview:shootingBtn];
    
  
    
    UIButton *seletecdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    seletecdBtn.frame = CGRectMake(kScreenWidth/2+30, 74, 60, 85);
    seletecdBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [seletecdBtn setTitle:@"选择照片" forState:UIControlStateNormal];
    [seletecdBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [seletecdBtn setImage:IMAGE(@"seletecdPhoto") forState:UIControlStateNormal];
    [seletecdBtn addTarget:self action:@selector(seletecdBtnClick) forControlEvents:UIControlEventTouchUpInside];
    seletecdBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -seletecdBtn.imageView.frame.size.width, -seletecdBtn.imageView.frame.size.height-offset/2, 0);
    seletecdBtn.imageEdgeInsets = UIEdgeInsetsMake(-seletecdBtn.titleLabel.intrinsicContentSize.height-offset/2, 0, 0, -seletecdBtn.titleLabel.intrinsicContentSize.width);
    [_bottomView addSubview:seletecdBtn];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 182.5, kScreenWidth, 0.5)];
      lineView.backgroundColor = UIColorFromRGB(0xF2F2F2);
      [self.bottomView addSubview:lineView];
      UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
      cancelBtn.frame = CGRectMake(0,183, kScreenWidth, 48);
      cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
      [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:[UIColor whiteColor]];
      [cancelBtn addTarget:self action:@selector(cancelBtnBtnClick) forControlEvents:UIControlEventTouchUpInside];
      [_bottomView addSubview:cancelBtn];
    
    
    [UIView animateWithDuration:0.3 animations:^{
           
           weak_self.bottomView.frame = CGRectMake(0, kScreenHeight-232, kScreenWidth, 232);
           
           
    } completion:^(BOOL finished) {
       
       
    }];
    
    self.seletecdIndexBlock =seletecdIndexBlock;
}

- (void)showPickerWithType:(UIImagePickerControllerSourceType)photoType
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = photoType;
    picker.allowsEditing = YES;
    picker.delegate = self;
    picker.modalPresentationStyle = UIModalPresentationOverFullScreen;
    picker.modalPresentationCapturesStatusBarAppearance = YES;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:picker animated:YES completion:nil];
    WEAK_SELF
    [UIView animateWithDuration:0.3 animations:^{
        weak_self.viewBG.hidden=YES;
        weak_self.bottomView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 145);
        

    } completion:^(BOOL finished) {
        
    }];
}


#pragma mark - image piker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info{
{
    NSString * mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]) {//照片
        UIImage* editedImage =(UIImage *)[info objectForKey:
                       UIImagePickerControllerEditedImage]; //取出编辑过的照片
        UIImage* originalImage =(UIImage *)[info objectForKey:
                       UIImagePickerControllerOriginalImage];//取出原生照片
           UIImage* imageToSave = nil;
           if(editedImage){
               imageToSave = editedImage;
           } else {
               imageToSave = originalImage;
           }
       //将新图像（原始图像或已编辑）保存到相机胶卷
        UIImageWriteToSavedPhotosAlbum(imageToSave,nil,nil,nil);
        imageToSave =   [UIImage compressionImage:imageToSave];
        NSData *iconData = UIImageJPEGRepresentation(imageToSave,1.0);
        //用日期给文件命名
       NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
       formatter.dateFormat = @"yyyyMMddHHmmss";
       NSString *fileName = [formatter stringFromDate:[NSDate date]];
       NSString *objectKey = [NSString stringWithFormat:@"ios/%@.png",fileName];
        emptyBlock(self.seletecdIndexBlock,iconData,objectKey);
        [self colse];
       }
    }
 
 
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}




//保存到本地图片
- (void)saveImage:(UIImage *)image withName:(NSString *)imageName {
    NSData *currentImage = UIImageJPEGRepresentation(image, 0.5);
    NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"photoAlbum"];
    NSString *photoPath = [file stringByAppendingPathComponent:imageName];
    [currentImage writeToFile:photoPath atomically:YES];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}

//设置照片的名称保存格式
- (NSString *)currentDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *currentDate = [NSDate date];
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
    NSString *imageFileName = [NSString stringWithFormat:@"%@.png", currentDateString];
    
    return imageFileName;
}

 

-(void)shootingBtnClick{
    
    [self showPickerWithType:UIImagePickerControllerSourceTypeCamera];
//    emptyBlock(self.seletecdIndexBlock,1);
//    [self colse];
}

- (void)seletecdBtnClick{
     [self showPickerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
//    emptyBlock(self.seletecdIndexBlock,2);
//    [self colse];
}

-(void)cancelBtnBtnClick{
//    emptyBlock(self.seletecdIndexBlock,0);
    [self colse];
}



- (void)colse{
    WEAK_SELF
 [UIView animateWithDuration:0.3 animations:^{
     
     weak_self.bottomView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 232);
     

 } completion:^(BOOL finished) {
      [[[UIApplication sharedApplication].keyWindow viewWithTag:777] removeFromSuperview];
 }];
     
}


@end
