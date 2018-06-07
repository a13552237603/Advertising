//
//  YKTAlphaSdverView.m
//  Advertising
//
//  Created by hht on 2018/5/23.
//  Copyright © 2018年 hht. All rights reserved.
//

#import "YKTAlphaSdverView.h"
#import "WMPlayer.h"

@interface YKTAlphaSdverView ()<WMPlayerDelegate>

@property (strong, nonatomic) WMPlayer *wmPlay;


@end

@implementation YKTAlphaSdverView

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
        [self greatUI];
        
    }
    return self;
    
}
-(void)greatUI{
    self.backgroundColor = [UIColor clearColor];
    _alphaSdverLabel = [[UILabel alloc]initWithFrame: CGRectMake(0, 0, self.frame.size.width, 374*adapterRect)];
    _alphaSdverLabel.numberOfLines = 0;
    _alphaSdverLabel.font = [UIFont systemFontOfSize:14];
    //    _sdverLabel.textColor = FontColor_Gray;
    _alphaSdverLabel.userInteractionEnabled = YES;
    [self addSubview:_alphaSdverLabel];
    
    _alphaSdverImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 374*adapterRect)];
    _alphaSdverImage.contentMode =  UIViewContentModeScaleAspectFit;
    _alphaSdverImage.userInteractionEnabled = YES;
    [self addSubview:_alphaSdverImage];
    
    _alphaVideoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 374*adapterRect)];
    _alphaVideoView.userInteractionEnabled = YES;
    [self addSubview:_alphaVideoView];
    _alphaVideoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 374*adapterRect)];
    _alphaVideoImage.contentMode =  UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *videoTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSdverClick)];
    [self addGestureRecognizer:videoTap];
    [_alphaVideoView addSubview:_alphaVideoImage];
    _alphaVideoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50*adapterRect, 50*adapterRect)];
    _alphaVideoBtn.center = _alphaVideoView.center;
    _alphaVideoBtn.userInteractionEnabled = YES;
    [_alphaVideoBtn addTarget:self action:@selector(clickVideoPlay) forControlEvents:UIControlEventTouchUpInside];
    [_alphaVideoBtn setBackgroundImage:[UIImage imageNamed:@"video_play_btn_bg"] forState:UIControlStateNormal];
    [_alphaVideoView addSubview:_alphaVideoBtn];
    
//    _deleteBtn = [[UIButton alloc]init];
//    _deleteBtn.userInteractionEnabled = YES;
//    [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
//    [_deleteBtn addTarget:self action:@selector(delegateClick) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_deleteBtn];
//    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self).with.offset(0);
//        make.centerX.mas_equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(45*adapterRect, 45*adapterRect));
//    }];
    
    
    _alphaSdverImage.hidden = YES;
    _alphaSdverLabel.hidden = YES;
    _alphaVideoView.hidden = YES;
    
}

-(void)setAlphaSdverTypeStr:(NSString *)alphaSdverTypeStr{
    _alphaSdverTypeStr = alphaSdverTypeStr;
    if ([_alphaSdverTypeStr isEqualToString:@"0"]) {
        _alphaSdverLabel.hidden = NO;
        self.FromAlphaSdverType = FromAlphaSdverText;
    }else if ([_alphaSdverTypeStr isEqualToString:@"1"] ){
        _alphaSdverImage.hidden = NO;
        self.FromAlphaSdverType = FromAlphaSdverImage;
    }else{
        _alphaVideoView.hidden = NO;
        self.FromAlphaSdverType = FromAlphaSdverVideo;
    }
}
-(void)setAlphaSdverValue:(NSString *)alphaSdverValue{
    _alphaSdverValue = alphaSdverValue;
    switch (self.FromAlphaSdverType) {
        case FromAlphaSdverText:
        {
            _alphaSdverLabel.text = _alphaSdverValue;
        }
            break;
        case FromAlphaSdverImage:
        {
            [_alphaSdverImage sd_setImageWithURL:[NSURL URLWithString:_alphaSdverValue] placeholderImage:[UIImage imageNamed:@"order_add"]];
        }
            break;
        case FromAlphaSdverVideo:
        {
            [_alphaVideoImage sd_setImageWithURL:[NSURL URLWithString:_alphaSdverValue] placeholderImage:[UIImage imageNamed:@"order_add"]];
        }
            break;
            
        default:
            break;
    }
}
-(void)setVideoStr:(NSString *)videoStr{
    _videoStr = videoStr;
    _wmPlay = [[WMPlayer alloc]initWithFrame:_alphaVideoImage.bounds];
    _wmPlay.delegate = self;
    _wmPlay.closeBtnStyle = CloseBtnStyleClose;
    _wmPlay.userInteractionEnabled = YES;
    _wmPlay.topView.hidden = YES;
    //关闭音量调节的手势
    //        wmPlayer.enableVolumeGesture = NO;
    _wmPlay.titleLabel.text = @"这是个测试视频";
    _wmPlay.URLString = _videoStr;
    [_wmPlay play];
    [self addSubview:_wmPlay];
}
-(void)setRemoveStr:(NSString *)removeStr{
    _removeStr = removeStr;
    if (self.FromAlphaSdverType == FromAlphaSdverVideo) {
        [self releaseWMPlayer];
    }
}
#pragma mark 点击图片或者文本
-(void)tapSdverClick{
    if ([self.alphaSdverClickDelegate respondsToSelector:@selector(alphaSdverClickEvent)]){
        [self.alphaSdverClickDelegate alphaSdverClickEvent];
    }
}
#pragma mark 点击视频播放
-(void)clickVideoPlay{
    if ([self.alphaSdverClickDelegate respondsToSelector:@selector(alphaSdverPlayVideo)]) {
        [self.alphaSdverClickDelegate alphaSdverPlayVideo];
    }
}
#pragma mark 点击关闭广告
//-(void)delegateClick{
//    if ([self.alphaSdverClickDelegate respondsToSelector:@selector(alphaSdverDelegate)]) {
//        [self.alphaSdverClickDelegate alphaSdverDelegate];
//    }
//}
#pragma mark 播放完毕
-(void)wmplayerFinishedPlay:(WMPlayer *)wmplayer{
    NSLog(@"wmplayerDidFinishedPlay");
    // [_sdverView.videoBtn.superview bringSubviewToFront:_sdverView.videoBtn];
    [self releaseWMPlayer];
}
#pragma mark 点击全屏
-(void)wmplayer:(WMPlayer *)wmplayer clickedFullScreenButton:(UIButton *)fullScreenBtn{
    [_wmPlay removeFromSuperview];
    if (_wmPlay.isFullscreen==YES) {//全屏
        [UIView animateWithDuration:0.5 animations:^{
            [self addSubview:self->_wmPlay];
            [self->_wmPlay mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).with.offset(0);
                make.left.equalTo(self).with.offset(0);
                make.right.equalTo(self).with.offset(0);
                make.height.equalTo(@(self.frame.size.height));
            }];
            self->_wmPlay.isFullscreen = NO;
            self->_wmPlay.closeBtnStyle = CloseBtnStyleClose;
        }];
    }else{//非全屏
        [UIView animateWithDuration:0.5 animations:^{
            [[UIApplication sharedApplication].keyWindow addSubview:self->_wmPlay];
            [self->_wmPlay mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@([UIScreen mainScreen].bounds.size.width));
                make.height.equalTo(@([UIScreen mainScreen].bounds.size.height));
                make.center.equalTo(self->_wmPlay.superview);
            }];
            self->_wmPlay.isFullscreen = YES;
            self->_wmPlay.closeBtnStyle = CloseBtnStylePop;
        }];
    }
}
#pragma mark 移除视频
-(void)releaseWMPlayer{
    [_wmPlay pause];
    [_wmPlay removeFromSuperview];
    [_wmPlay.playerLayer removeFromSuperlayer];
    [_wmPlay.player replaceCurrentItemWithPlayerItem:nil];
    _wmPlay.player = nil;
    _wmPlay.currentItem = nil;
    //释放定时器，否侧不会调用WMPlayer中的dealloc方法
    [_wmPlay.autoDismissTimer invalidate];
    _wmPlay.autoDismissTimer = nil;
    _wmPlay.playOrPauseBtn = nil;
    _wmPlay.playerLayer = nil;
    _wmPlay = nil;
}
@end
