//
//  YKTSdvertisingspaceView.h
//  Advertising
//
//  Created by hht on 2018/5/22.
//  Copyright © 2018年 hht. All rights reserved.
//

typedef NS_ENUM(NSInteger, FromSdvertisingType) {
    FromSdvertisingText,    //文本
    FromSdvertisingImage,  //图片
    FromSdvertisingVideo,  //视频
};
#import <UIKit/UIKit.h>
@protocol SdvertisingClickDelegate <NSObject>
//点击广告
-(void)sdverClickEvent;
//点击播放
-(void)sdverPlayVideo;

@end


@interface YKTSdvertisingspaceView : UIView  
@property(nonatomic,weak)id <SdvertisingClickDelegate> sdverClickDelegate;
@property (nonatomic, assign) FromSdvertisingType  FromSdverType;

@property(nonatomic,strong)UIImageView *sdverImage;//广告图片
@property(nonatomic,strong)UILabel *sdverLabel;//广告文本

@property(nonatomic,strong)UIView *videoView;//视频view
@property(nonatomic,strong)UIImageView *videoImage;//视频占位图片
@property(nonatomic,strong)UIButton *videoBtn;//点击播放按钮

@property(nonatomic,copy)NSString *sdverTypeStr;//判断的参数
@property(nonatomic,copy)NSString *sdverValue;//返回值(文本，URL,占位图)
@property(nonatomic,copy)NSString *videoStr;//视频链接
@property(nonatomic,copy)NSString *removeStr;//切换界面的时候，移除视频

@end
