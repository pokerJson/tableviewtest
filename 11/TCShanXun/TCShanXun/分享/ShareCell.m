//
//  ShareCell.m
//  News
//
//  Created by FANTEXIX on 2018/7/8.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "ShareCell.h"


@interface ShareCell ()

@property(nonatomic, strong)UIImageView * iconImageView;
@property(nonatomic, strong)UILabel * nameLabel;

@end

@implementation ShareCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
        [self addSubviews];
    }
    return self;
}

- (void)initial {
    self.backgroundColor = [UIColor whiteColor];
}

- (void)addSubviews {
    
    _iconImageView = [[UIImageView alloc]init];
    
    [self addSubview:_iconImageView];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.textColor = RGBColor(150, 150, 150);
    _nameLabel.textAlignment = 1;
    _nameLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_nameLabel];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _iconImageView.frame = CGRectMake((self.width-40)/2., 10, 40, 40);
    _nameLabel.frame = CGRectMake(0, self.height-20, self.width, 20);
}

- (void)loadDataWithModel:(NSDictionary *)model {
    if ([model[@"type"] isEqualToString:@"0"]) {
        _iconImageView.image = UIImageNamed(model[@"img"]);

    }else {
        _iconImageView.image = [self grayscaleImageForImage:UIImageNamed(model[@"img"])];

    }
    _nameLabel.text = model[@"name"];
}


- (UIImage*)grayscaleImageForImage:(UIImage*)image {
    // Adapted from this thread: http://stackoverflow.com/questions/1298867/convert-image-to-grayscale
    const int RED =1;
    const int GREEN =2;
    const int BLUE =3;
    
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0,0, image.size.width* image.scale, image.size.height* image.scale);
    
    int width = imageRect.size.width;
    int height = imageRect.size.height;
    
    // the pixels will be painted to this array
    uint32_t * pixels = (uint32_t*) malloc(width * height *sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels,0, width * height *sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height,8, width *sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context,CGRectMake(0,0, width, height), [image CGImage]);
    
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t * rgbaPixel = (uint8_t*) &pixels[y * width + x];
            
            // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            
            //uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
            uint32_t gray = 150;
            
            
            // set the pixels to gray
            rgbaPixel[RED] = gray;
            rgbaPixel[GREEN] = gray;
            rgbaPixel[BLUE] = gray;
        }
    }
    
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:UIImageOrientationUp];
    
    // we're done with image now too
    CGImageRelease(imageRef);
    
    return resultUIImage;
}


//所谓颜色或灰度级指黑白显示器中显示像素点的亮暗差别，在彩色显示器中表现为颜色的不同，灰度级越多，图像层次越清楚逼真。灰度级取决于每个像素对应的刷新存储单元的位数和显示器本身的性能。如每个象素的颜色用16位二进制数表示，我们就叫它16位图，它可以表达2的16次方即65536种颜色。如每一个象素采用24位二进制数表示，我们就叫它24位图，它可以表达2的24次方即16777216种颜色。
//灰度就是没有色彩，RGB色彩分量全部相等。如果是一个二值灰度图象，它的象素值只能为0或1，我们说它的灰度级为2。用个例子来说明吧:一个256级灰度的图象，如果RGB三个量相同时，如：RGB(100,100,100)就代表灰度为100,RGB(50,50,50)代表灰度为50。
//彩色图象的灰度其实在转化为黑白图像后的像素值（是一种广义的提法），转化的方法看应用的领域而定，一般按加权的方法转换，R， G，B 的比一般为3：6：1。
//任何颜色都由红、绿、蓝三原色组成，假如原来某点的颜色为RGB(R，G，B)，那么，我们可以通过下面几种方法，将其转换为灰度：
//1.浮点算法：Gray=R*0.3+G*0.59+B*0.11
//2.整数方法：Gray=(R*30+G*59+B*11)/100
//3.移位方法：Gray =(R*77+G*151+B*28)>>8;
//4.平均值法：Gray=（R+G+B）/3;
//5.仅取绿色：Gray=G；
//通过上述任一种方法求得Gray后，将原来的RGB(R,G,B)中的R,G,B统一用Gray替换，形成新的颜色RGB(Gray,Gray,Gray)，用它替换原来的RGB(R,G,B)就是灰度图了。



@end
