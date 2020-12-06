//
//  ImageCutController.h
//  YiZhiPai
//
//  Created by FANTEXIX on 2018/3/1.
//  Copyright © 2018年 fantexix Inc. All rights reserved.
//

#import "BViewController.h"

@interface ImageCutController : BViewController

@property(nonatomic, strong)UIImage * preImage;

@property(nonatomic, copy)void (^callBack)(UIImage * image);

@end
