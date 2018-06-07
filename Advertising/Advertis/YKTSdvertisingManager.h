//
//  YKTSdvertisingManager.h
//  Advertising
//
//  Created by hht on 2018/6/4.
//  Copyright © 2018年 hht. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKTSdvertisingManager : NSObject

@property (nonatomic,  copy)NSString *pageType;//判断在那个页面，0(首页、服务页)，1(订单、积分)
//是否关闭悬浮框
@property (nonatomic, assign) BOOL Home_close;
@property (nonatomic, assign) BOOL Serve_close;
@property (nonatomic, assign) BOOL Order_close;
@property (nonatomic, assign) BOOL Number_close;

+ (instancetype)shareSdverManager;

- (void)updateWithFirst:(BOOL )first_great;//初始化

- (void)updateWithHome:(BOOL )home_close;//首页悬浮框
- (void)updateWithServe:(BOOL )serve_close;//服务业悬浮框
- (void)updateWithOrder:(BOOL )order_close;//订单页悬浮框
- (void)updateWithNumber:(BOOL )number_close;//积分页悬浮框

- (void)updateWithPage:(NSString *)typeStr; 

@end
