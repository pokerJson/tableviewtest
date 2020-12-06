//
//  ModifyIconController.m
//  YiZhiPai
//
//  Created by FANTEXIX on 2018/3/1.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "ModifyIconController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ImageCutController.h"
#import "PersonModel.h"
#import <Photos/Photos.h>

@interface ModifyIconController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic, strong)UIImageView * preImageView;

@property(nonatomic,strong)UIImagePickerController * imagePicker;

@property(nonatomic, strong)NSData * imageData;

@end

@implementation ModifyIconController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    self.navBarView.hidden = NO;
    self.navBarView.backgroundColor = [UIColor clearColor];
    self.navShadowLine.hidden = YES;
    self.navTitleLabel.textColor = [UIColor whiteColor];
    self.navRightButton.hidden = NO;
    [self.navLeftButton setImage:UIImageNamed(@"icon_back_white") forState:UIControlStateNormal];
    //[self.navRightButton setImage:UIImageNamed(@"ic_comment_more") forState:UIControlStateNormal];
    [self.navRightButton setTitle:@"更改" forState:UIControlStateNormal];
    self.navRightButton.titleLabel.font = UIFontSys(16);
    
    _preImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (kScreenHeight - kScreenWidth)/2.0+20, kScreenWidth, kScreenWidth)];
    _preImageView.backgroundColor = RGBColor(32, 32, 32);
    if (_type.intValue == 0) {
        self.navTitleLabel.text = @"背景图片";
        [_preImageView sd_setImageWithURL:[NSURL URLWithString:_model.bgpic]];
    }else {
        self.navTitleLabel.text = @"个人头像";
        [_preImageView sd_setImageWithURL:[NSURL URLWithString:_model.icon]];
    }
    [self.view addSubview:_preImageView];
    
}

- (void)navLeftMethod:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)navRightMethod:(UIButton *)button {
    
    weakObj(self);
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cameraAction = [UIAlertAction actionWithTitle:@"拍一张" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                            
                                                             selfWeak.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;              //相机来源
                                                             selfWeak.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                                                             selfWeak.imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
                                                             [selfWeak presentViewController:self.imagePicker animated:YES completion:nil];
                                                             
                                                         }];
    
    UIAlertAction* photoAction = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                            
                                                            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;    //相册来源
                                                            self.imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
                                                            [self presentViewController:self.imagePicker animated:YES completion:nil];

                                                        }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                             
                                                        
                                                         }];
    
    
    [alert addAction:cameraAction];
    [alert addAction:photoAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

//图片选择控制器懒加载
- (UIImagePickerController *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc]init];
        _imagePicker.delegate = self;
        _imagePicker.navigationBar.translucent = NO;
    }
    return _imagePicker;
}


#pragma mark 协议方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    weakObj(self);
    
    UIImage  * img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (img) {
        
        ImageCutController * iCVC = [ImageCutController new];
        iCVC.preImage = img;
    
        iCVC.callBack = ^(UIImage * image) {
            [selfWeak update:image];
        };
        
        [picker dismissViewControllerAnimated:NO completion:^{
            [self presentViewController:iCVC animated:YES completion:nil];
        }];
        
    }else {
        
        NSURL * url = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
        PHFetchResult *fetchResult = [PHAsset fetchAssetsWithALAssetURLs:@[url] options:nil];
        PHAsset *asset = fetchResult.firstObject;
    
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            
            UIImage * image = [UIImage imageWithData:imageData];
            
            if (!image) return ;
            
            ImageCutController * iCVC = [ImageCutController new];
            iCVC.preImage = image;
            
            iCVC.callBack = ^(UIImage * image) {
                [selfWeak update:image];
            };
            
            [picker dismissViewControllerAnimated:NO completion:^{
                [selfWeak presentViewController:iCVC animated:YES completion:nil];
            }];
            
        }];
        
    }
    

}

- (UIImage *)zipNSDataWithImage:(UIImage *)sourceImage{

    CGSize  imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    if (width > 600 && height > 600) {
        if (width > height) {
            CGFloat scale = height/width;
            width = 600;
            height = width*scale;
        }else{
            CGFloat scale = width/height;
            height = 600;
            width = height*scale;
        }
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [sourceImage drawInRect:CGRectMake(0,0,width,height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData * data = UIImageJPEGRepresentation(newImage, 1.0);
    if (data.length > 2*1024*1024) {
        data = UIImageJPEGRepresentation(newImage, 0.8);
    }
    
    return [UIImage imageWithData:data];;
}


- (void)update:(UIImage *)image {

    image = [self zipNSDataWithImage:image];
    
    NSLog(@"%@",image);
    
    NSString * url = nil;
    
    switch (_type.intValue) {
        case 0: {
            url = UPDATE_BG_URL;
        }
            break;
        case 1: {
            url = UPDATE_ICON_URL;
        }
            break;
        default:
            break;
    }
    
    NSDictionary * param = @{
                             @"userid":[UserManager shared].userInfo.uid,
                             @"token":[UserManager shared].userInfo.accessToken,
                             };

    NSString * filename = [NSString stringWithFormat:@"avatar%@",[UserManager shared].userInfo.uid];

    [HttpRequest upload_RequestWithURL:url URLParam:param image:image name:@"file" filename:filename returnData:^(NSURLResponse *urlResponse, NSData *resultData, NSError *error) {

        NSLog(@"%@",[[NSString alloc]initWithData:resultData encoding:NSUTF8StringEncoding]);
        
        if (!error) {
            id dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"msg"] isEqualToString:@"success"]) {

                if (self.type.intValue == 0) {
                    self.preImageView.image = image;
                    self.model.bgpic = dic[@"data"][@"bgpic"];
                }else {
                    self.preImageView.image = image;
                    self.model.icon = dic[@"data"][@"icon"];
                    [UserManager shared].userInfo.icon = dic[@"data"][@"icon"];
                }
            }
        }else {
            MLog(@"%@",error.localizedDescription);
        }


    }];
    
}





@end
