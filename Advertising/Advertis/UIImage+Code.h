//
//  UIImage+Code.h
//  Advertising
//
//  Created by hht on 2018/5/29.
//  Copyright © 2018年 hht. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Code)

#pragma mark 加载logo图生成的二维码
+(UIImage *)codeImageFromeString:(NSString *)string imageSize:(CGFloat)Imagesize logoImageSize:(CGFloat)logoImagesize;

#pragma mark 生成二维码
+(UIImage *)codeImageFromeString:(NSString *)string imageSize:(CGFloat)Imagesize;

@end
