//
//  YKTSuspendImageView.m
//  数据库
//
//  Created by hht on 2018/5/21.
//  Copyright © 2018年 贺恒涛. All rights reserved.


#import "YKTSuspendImageView.h"
#import "UIView+Extend.h"

@implementation YKTSuspendImageView{
    CGPoint starLoaction;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
        [self addGestureRecognizer:tap];
    }
    return self;
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint pt = [[touches anyObject] locationInView:self];
    starLoaction = pt;
    [[self superview] bringSubviewToFront:self];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint pt = [[touches anyObject] locationInView:self];
    float dx = pt.x - starLoaction.x;
    float dy = pt.y - starLoaction.y;
    CGPoint newCenter = CGPointMake(self.center.x + dx, self.center.y + dy);
    
    float newx = CGRectGetMidX(self.bounds);
    newCenter.x = MAX(newx, newCenter.x);
    newCenter.x = MIN(self.superview.bounds.size.width - newx, newCenter.x);
    
    float newy = CGRectGetMidY(self.bounds);
    newCenter.y = MAX(newy, newCenter.y);
    newCenter.y = MIN(self.superview.bounds.size.height - newy, newCenter.y);
    
    self.center = newCenter;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = self.center;
    if (point.x >[self superview].width/2.0) {
        [UIView animateWithDuration:0.2 animations:^{
            self.x = [self superview].width - self.width;
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.x = 0;
        }];
    }
    if (self.y <64) {
        self.y = 64;
    }
}

-(void)tapClick{
    if ([self.clickDelegate respondsToSelector:@selector(clickEvent)]) {
        [self.clickDelegate clickEvent];

    }
}

@end
