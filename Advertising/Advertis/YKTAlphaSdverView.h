//
//  YKTAlphaSdverView.h
//  Advertising
//
//  Created by hht on 2018/5/23.
//  Copyright © 2018年 hht. All rights reserved.
//
typedef NS_ENUM(NSInteger, FromAlphaSdverType) {
    FromAlphaSdverText,    //文本
    FromAlphaSdverImage,  //图片
    FromAlphaSdverVideo,  //视频
};
#import <UIKit/UIKit.h>

@protocol AlphaSdverClickDelegate <NSObject>
//点击广告
-(void)alphaSdverClickEvent;
//点击播放
-(void)alphaSdverPlayVideo;
//点击关闭
//-(void)alphaSdverDelegate;

@end

@interface YKTAlphaSdverView : UIView

@property(nonatomic,weak)id <AlphaSdverClickDelegate> alphaSdverClickDelegate;
@property (nonatomic, assign) FromAlphaSdverType  FromAlphaSdverType;

@property(nonatomic,strong)UIImageView *alphaSdverImage;//广告图片
@property(nonatomic,strong)UILabel *alphaSdverLabel;//广告文本
//@property(nonatomic,strong)UIButton *deleteBtn;//删除按钮

@property(nonatomic,strong)UIView *alphaVideoView;//视频view
@property(nonatomic,strong)UIImageView *alphaVideoImage;//视频占位图片
@property(nonatomic,strong)UIButton *alphaVideoBtn;//点击播放按钮

@property(nonatomic,copy)NSString *alphaSdverTypeStr;//判断的参数
@property(nonatomic,copy)NSString *alphaSdverValue;//返回值(文本，URL)
@property(nonatomic,copy)NSString *videoStr;//视频链接
@property(nonatomic,copy)NSString *removeStr;//是否移除视频

@end
