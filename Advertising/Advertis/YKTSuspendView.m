//
//  YKTSuspendView.m
//  Advertising
//
//  Created by hht on 2018/5/21.
//  Copyright © 2018年 hht. All rights reserved.
//

#import "YKTSuspendView.h"
#import "UIView+Extend.h"

@implementation YKTSuspendView{
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
        self.backgroundColor = [UIColor clearColor];
        [self greatUI];
        
    }
    return self;
    
}
-(void)greatUI{
    _suspendLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    _suspendLabel.numberOfLines = 0;
    _suspendLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *taplabel=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [_suspendLabel addGestureRecognizer:taplabel];
    [self addSubview:_suspendLabel];
    
    _suspendImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    _suspendImage.userInteractionEnabled = YES;
    _suspendImage.contentMode =  UIViewContentModeScaleAspectFit;
    [self addSubview:_suspendImage];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [_suspendImage addGestureRecognizer:tap];
    
    _suspendBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, 50, 20, 20)];
    [_suspendBtn addTarget:self action:@selector(dismissClick) forControlEvents:UIControlEventTouchUpInside];
    _suspendBtn.userInteractionEnabled = YES;
    [_suspendBtn setBackgroundImage:[UIImage imageNamed:@"delete-30"] forState:UIControlStateNormal];
    [self addSubview:_suspendBtn];
    _suspendLabel.hidden = YES;
    _suspendImage.hidden = YES;
}
#pragma mark 根据不同的情况适应不同的类型
-(void)setTypeStr:(NSString *)typeStr{
    _typeStr = typeStr;
    if ([typeStr isEqualToString:@"1"]) {
        _suspendImage.hidden = NO;
        self.FromSuspendType = FromSuspendImage;
    }else{
        _suspendLabel.hidden = NO;
        self.FromSuspendType = FromSuspendText;
    }
}
-(void)setImageStr:(NSString *)imageStr{
    _imageStr = imageStr;
    switch (_FromSuspendType) {
        case FromSuspendText:{
            _suspendLabel.text = _imageStr;
        }
            break;
        case FromSuspendImage:{
             [_suspendImage sd_setImageWithURL:[NSURL URLWithString:_imageStr] placeholderImage:[UIImage imageNamed:@"order_add"]];
        }
            break;
            
        default:
            break;
    }
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
    if (self.y < AllPhoneTopInset) {
        [UIView animateWithDuration:0.2 animations:^{
            self.y = AllPhoneTopInset;
        }];
    }
    if (self.y > [self superview].height -AllPhoneBomInset -self.height) {
        [UIView animateWithDuration:0.2 animations:^{
            self.y = [self superview].height -AllPhoneBomInset-self.height;
            }];
    }
}

-(void)tapClick{
    if ([self.clickDelegate respondsToSelector:@selector(clickEvent)]) {
        [self.clickDelegate clickEvent];
    }
}
-(void)dismissClick{
    if ([self.clickDelegate respondsToSelector:@selector(dismissEvent)]) {
        [self.clickDelegate dismissEvent];
    }
}


@end
