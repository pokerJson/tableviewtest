//
//  PicView.m
//  News
//
//  Created by FANTEXIX on 2018/7/13.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "PicView.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define lTop (IS_IPHONE_X?44:0)
#define lBottom (IS_IPHONE_X?34:0)

@interface PicView ()<UIScrollViewDelegate>

@property(nonatomic, strong)UIScrollView * scrollView;

@property(nonatomic, strong)UITapGestureRecognizer * viewTap;

@property(nonatomic, assign)float off;

@property(nonatomic, assign)float topInset;
@property(nonatomic, assign)float bottomInset;

@property(nonatomic, assign)BOOL isLong;

@property(nonatomic, assign)BOOL over;

@property(nonatomic, strong)SectorProgressView * sectorView;

@property(nonatomic, strong)NSDictionary * model;
@property(nonatomic, assign)float imgRate;


@end

@implementation PicView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
        [self addSubviews];
    }
    return self;
}

- (void)initial {
    self.backgroundColor = [UIColor clearColor];
    
    
}

- (void)addSubviews {
    
    _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    if (@available(iOS 11.0, *)) _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.delegate = self;
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = 2;
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    _viewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapMethod:)];
    _viewTap.numberOfTapsRequired = 1;
    [_scrollView addGestureRecognizer:_viewTap];
    
    UITapGestureRecognizer * dTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dTapMethod:)];
    dTap.numberOfTapsRequired = 2;
    [_scrollView addGestureRecognizer:dTap];
    
    [_viewTap requireGestureRecognizerToFail:dTap];
    
    
    UILongPressGestureRecognizer * press = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(pressMethod:)];
    press.minimumPressDuration = 0.5;
    press.numberOfTouchesRequired = 1;
    [_scrollView addGestureRecognizer:press];
    
    
    _imageView = [[YYAnimatedImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [_scrollView addSubview:_imageView];
    
    _sectorView = [[SectorProgressView alloc]initWithFrame:self.bounds];
    _sectorView.hidden = YES;
    [self addSubview:_sectorView];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}


- (void)loadDataWithModel:(NSDictionary *)model {
    _model = model;
    _imgRate = [_model[@"height"] floatValue]/[_model[@"width"] floatValue];
    if (!isnan(self.imgRate)) [self handleImageView];
    
    NSString *sUrlStr = [model[@"small"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *bUrlStr = [model[@"big"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 
    YYWebImageManager * manager = [YYWebImageManager sharedManager];
    UIImage * image = [manager.cache getImageForKey:[manager cacheKeyForURL:[NSURL URLWithString:sUrlStr]] withType:YYImageCacheTypeMemory];
    
    
    weakObj(self);
    [_imageView yy_setImageWithURL:[NSURL URLWithString:bUrlStr] placeholder:image options: YYWebImageOptionSetImageWithFadeAnimation progress:^(NSInteger receivedSize, NSInteger expectedSize) {

        if (expectedSize > 0 && receivedSize > 0) {
            
            __block CGFloat progress = receivedSize / (CGFloat)expectedSize;
            progress = progress < 0 ? 0 : progress > 1 ? 1 : progress;
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (selfWeak.sectorView.isHidden) selfWeak.sectorView.hidden = NO;
                selfWeak.sectorView.progressValue = progress;
            }];
        }

    } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (stage == YYWebImageStageFinished) {
            
        }
        selfWeak.sectorView.hidden = YES;
        selfWeak.over = YES;
        selfWeak.imgRate = image.size.height/image.size.width;
        if (!isnan(selfWeak.imgRate)) [selfWeak handleImageView];
    }];
}

- (void)handleImageView {
    //NSLog(@"_imgRate:%f",_imgRate);
    
    _imageView.frame = CGRectMake(0, 0, sWidth,self.imgRate*sWidth);
    
    _scrollView.contentSize = CGSizeMake(_imageView.width, _imageView.height);
    
    
    float screenRate;
    if (IS_IPHONE_X) {
        screenRate = (sHeight - kStatusHeight-kBottomInsets)/sWidth;
    }else {
        screenRate = sHeight/sWidth;
    }
    
    if (self.imgRate > screenRate) {
        //长图
        _isLong = YES;
        _scrollView.contentInset = UIEdgeInsetsMake(lTop, 0, lBottom, 0);
        _scrollView.contentOffset = CGPointMake(0, -_scrollView.contentInset.top);
    }else {
        _isLong = NO;
        _scrollView.contentInset = UIEdgeInsetsMake((_scrollView.height-_imageView.height)/2., 0, (_scrollView.height-_imageView.height)/2., 0);
        _scrollView.contentOffset = CGPointMake(0, -_scrollView.contentInset.top);
    }
    
    
}



- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (self.over) {
        return _scrollView.subviews.firstObject;
    }else {
        return nil;
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    NSLog(@"%@",NSStringFromCGSize(_imageView.size));
    
    if (_isLong) {
        _scrollView.contentInset = UIEdgeInsetsMake(lTop, 0, lBottom, 0);
    }else {
        _scrollView.contentInset = UIEdgeInsetsMake((_scrollView.height - _imageView.height)/2., 0, (_scrollView.height - _imageView.height)/2., 0);

    }
    _sectorView.frame = _imageView.bounds;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float y = scrollView.contentOffset.y;
    float yt = scrollView.contentInset.top;
    float yb = scrollView.contentSize.height+scrollView.contentInset.bottom-scrollView.height;
    
    _topInset = y+yt;
    _bottomInset = y-yb;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (_topInset < - 50 || _bottomInset > 50) {
        if (self.picDelegate && [self.picDelegate respondsToSelector:@selector(picViewViewTap:)]) {
            [self.picDelegate picViewViewTap:self];
        }
    }
}

- (void)viewTapMethod:(UITapGestureRecognizer *)tap {
    if (self.picDelegate && [self.picDelegate respondsToSelector:@selector(picViewViewTap:)]) {
        _scrollView.contentOffset = CGPointMake(0, -_scrollView.contentInset.top);
        [self.picDelegate picViewViewTap:self];
    }
}
- (void)dTapMethod:(UITapGestureRecognizer *)tap {
    if (self.scrollView.zoomScale == 1) {
        [UIView animateWithDuration:0.25 animations:^{
            self.scrollView.zoomScale = 2;
        }];
    }else {
        [UIView animateWithDuration:0.25 animations:^{
            self.scrollView.zoomScale = 1;
        }];
    }
    
}



- (void)pressMethod:(UILongPressGestureRecognizer *)press {
    
    if (press.state == UIGestureRecognizerStateBegan) {
        
        
        
        
        weakObj(self);
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet];

        
        UIAlertAction* saveAction = [UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {

                                                                 YYWebImageManager * manager = [YYWebImageManager sharedManager];
                                                                 
                                                                 YYImage * image = (YYImage *)[manager.cache getImageForKey:[manager cacheKeyForURL:[NSURL URLWithString:selfWeak.model[@"big"]]] withType:YYImageCacheTypeMemory];
                                                                 
                                                                 if (image.animatedImageType != YYImageTypeGIF) {
                                                                     UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                                                                     
                                                                 }else {
                                                                     [[[ALAssetsLibrary alloc] init] writeImageDataToSavedPhotosAlbum:image.animatedImageData metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
                                                                         if (!error) {
                                                                             NSLog(@"保存成功");
                                                                             [KKHUD showMiddleWithStatus:@"保存成功"];
                                                                         }
                                                                     }];
                                                                 }
                                                                 
                                                             }];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * action) {
                                                                 
                                                          }];
        
        
        //初始化  将类型设置为二维码
        CIDetector * detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:nil];
        NSArray *features = [detector featuresInImage:[CIImage imageWithData:UIImagePNGRepresentation(_imageView.image)]];
        //判断是否有数据（即是否是二维码）
        if (features.count >= 1) {
            //取第一个元素就是二维码所存放的文本信息
            CIQRCodeFeature * feature = features[0];
            NSString *scannedResult = feature.messageString;
            NSLog(@"%@",scannedResult);
            
            UIAlertAction* qrAction = [UIAlertAction actionWithTitle:@"识别图片二维码" style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {
                                                                   
                                                                   
            
                                                               }];
            [alert addAction:qrAction];
            
        }else{
            NSLog(@"没识别出来");
        }
        
        
        
        [alert addAction:saveAction];
        [alert addAction:cancelAction];

        [self.viewController presentViewController:alert animated:YES completion:nil];

    }
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        NSLog(@"保存成功");
        [KKHUD showMiddleWithStatus:@"保存成功"];
    }
    
}



@end
