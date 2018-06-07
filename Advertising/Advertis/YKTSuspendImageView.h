//
//  YKTSuspendImageView.h
//  数据库
//
//  Created by hht on 2018/5/21.
//  Copyright © 2018年 贺恒涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SuspendClickDelegate <NSObject>
//点击悬浮事件
-(void)clickEvent;

@end

@interface YKTSuspendImageView : UIImageView
@property(nonatomic,weak)id <SuspendClickDelegate> clickDelegate;

@end
