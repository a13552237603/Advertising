//
//  YKTSdvertisingManager.m
//  Advertising
//
//  Created by hht on 2018/6/4.
//  Copyright © 2018年 hht. All rights reserved.
//

#import "YKTSdvertisingManager.h"

@implementation YKTSdvertisingManager

+ (instancetype)shareSdverManager{
    static YKTSdvertisingManager *sdver = nil;
    static dispatch_once_t sdvertising;
    dispatch_once(&sdvertising, ^{
        sdver = [[self alloc]init];
    });
    return sdver;
}
- (void)updateWithFirst:(BOOL )first_great{
    self.Home_close = first_great;
    self.Serve_close = first_great;
    self.Order_close = first_great;
    self.Number_close = first_great;
}

- (void)updateWithPage:(NSString *)typeStr{
    self.pageType = typeStr;
}

- (void)updateWithHome:(BOOL )home_close{
    self.Home_close = home_close;
}
- (void)updateWithServe:(BOOL )serve_close{
    self.Serve_close = serve_close;
}
- (void)updateWithOrder:(BOOL )order_close{
    self.Order_close = order_close;
}
- (void)updateWithNumber:(BOOL )number_close{
    self.Number_close = number_close;
}

@end
