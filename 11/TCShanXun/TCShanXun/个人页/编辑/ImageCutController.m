//
//  ImageCutController.m
//  YiZhiPai
//
//  Created by FANTEXIX on 2018/3/1.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "ImageCutController.h"

@interface ImageCutController ()<UIScrollViewDelegate>

@property(nonatomic, strong)UIScrollView * scrollView;
@property(nonatomic, strong)UIImageView * imageView;

@property(nonatomic, strong)UIImageView * preImageView;

@end

@implementation ImageCutController

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
    self.navTitleLabel.text = @"预览";
    self.navTitleLabel.textColor = [UIColor whiteColor];
    self.navRightButton.hidden = NO;
    [self.navLeftButton setImage:UIImageNamed(@"icon_back_white") forState:UIControlStateNormal];
    [self.navRightButton setTitle:@"选取" forState:UIControlStateNormal];
    self.navRightButton.titleLabel.font = UIFontSys(16);
    
    
    
    //1 创建
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.navBarView.bounds.size.height, kWidth, kHeight - self.navBarView.bounds.size.height)];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];

    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kWidth * _preImage.size.height/_preImage.size.width)];
    _imageView.image = _preImage;
    [_scrollView addSubview:_imageView];
    
    _scrollView.contentSize = _imageView.bounds.size;
    
    _scrollView.contentOffset = CGPointMake(0, -(_scrollView.bounds.size.height-kWidth)/4.0);
    
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    _scrollView.contentInset = UIEdgeInsetsMake((_scrollView.bounds.size.height-kWidth)/2.0, 0, (_scrollView.bounds.size.height-kWidth)/2.0, 0);
    
    _scrollView.decelerationRate = 0.5;
    
    _scrollView.maximumZoomScale = 5;
    _scrollView.minimumZoomScale = 1;
    
    UILabel * top = [[UILabel alloc]initWithFrame:CGRectMake(0, self.navBarView.bounds.size.height, kWidth, (_scrollView.bounds.size.height-kWidth)/2.0)];
    top.backgroundColor = RGBAColor(0, 0, 0, 0.3);
    [self.view addSubview:top];
    
    UILabel * bottom = [[UILabel alloc]initWithFrame:CGRectMake(0, kHeight - (_scrollView.bounds.size.height-kWidth)/2.0, kWidth, (_scrollView.bounds.size.height-kWidth)/2.0)];
    bottom.backgroundColor = RGBAColor(0, 0, 0, 0.3);
    [self.view addSubview:bottom];
    
    
    UILabel * mid = [[UILabel alloc]initWithFrame:CGRectMake(0, kHeight - (_scrollView.bounds.size.height-kWidth)/2.0 - kWidth, kWidth, kWidth)];
    mid.layer.borderColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.6].CGColor;
    mid.layer.borderWidth = 1.0;
    [self.view addSubview:mid];
    
    
    _preImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 88, 100, 100)];
    [self.view addSubview:_preImageView];
    
    
}

- (void)navLeftMethod:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)navRightMethod:(UIButton *)button {
    
    CGPoint cg = CGPointMake(_scrollView.contentOffset.x, _scrollView.contentOffset.y+(_scrollView.bounds.size.height-kWidth)/2.0);
    
    CGSize c = _imageView.image.size;
    
    NSLog(@"cg_width:%lf  cg_height:%lf",cg.x,cg.y);
    float zoom = _imageView.frame.size.width/c.width;
    
    CGRect rec = CGRectMake(cg.x/zoom, cg.y/zoom, kWidth/zoom, kWidth/zoom);
    CGImageRef imageRef = CGImageCreateWithImageInRect([[self fixOrientation:_imageView.image] CGImage],rec);
    UIImage * clipImage = [[UIImage alloc] initWithCGImage:imageRef];
    
    _preImageView.image = clipImage;
    
    
    if (_callBack) {
        _callBack(clipImage);
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}


//缩放相关
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    //返回希望缩放的视图
    return scrollView.subviews[0];
}

//修改拍摄照片的水平度不然会旋转90度
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


@end
