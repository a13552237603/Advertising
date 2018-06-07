//
//  YKTSuspendView.h
//  Advertising
//
//  Created by hht on 2018/5/21.
//  Copyright © 2018年 hht. All rights reserved.
//

typedef NS_ENUM(NSInteger, FromSuspendType) {
    FromSuspendText,    //文本
    FromSuspendImage,  //图片
};

#import <UIKit/UIKit.h>
@protocol SuspendClickDelegate <NSObject>
//点击悬浮图片
-(void)clickEvent;
//点击关闭
-(void)dismissEvent;
@end

@interface YKTSuspendView : UIView
@property(nonatomic,weak)id <SuspendClickDelegate> clickDelegate;
@property (nonatomic, assign) FromSuspendType  FromSuspendType;

@property(nonatomic,strong)UIImageView *suspendImage;//悬浮图片
@property(nonatomic,strong)UILabel *suspendLabel;//悬浮文本
@property(nonatomic,strong)UIButton *suspendBtn;//悬浮关闭按钮


@property(nonatomic,copy)NSString *typeStr;//判断的参数
@property(nonatomic,copy)NSString *imageStr;//图片地址

@end
