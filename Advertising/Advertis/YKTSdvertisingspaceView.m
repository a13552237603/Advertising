//
//  YKTSdvertisingspaceView.m
//  Advertising
//
//  Created by hht on 2018/5/22.
//  Copyright © 2018年 hht. All rights reserved.
//

#import "YKTSdvertisingspaceView.h"
#import "WMPlayer.h"
#import "ClickImageViewController.h"

@interface YKTSdvertisingspaceView ()<WMPlayerDelegate>

@property (strong, nonatomic) WMPlayer *wmPlay;

@end

@implementation YKTSdvertisingspaceView

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
    _sdverLabel = [[UILabel alloc]initWithFrame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _sdverLabel.numberOfLines = 0;
    _sdverLabel.font = [UIFont systemFontOfSize:14];
//    _sdverLabel.textColor = FontColor_Gray;
    _sdverLabel.userInteractionEnabled = YES;
    [self addSubview:_sdverLabel];

    _sdverImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _sdverImage.contentMode =  UIViewContentModeScaleAspectFit;
    _sdverImage.userInteractionEnabled = YES;
    [self addSubview:_sdverImage];

    _videoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _videoView.userInteractionEnabled = YES;
    [self addSubview:_videoView];
    _videoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _videoImage.contentMode =  UIViewContentModeScaleAspectFit;

    UITapGestureRecognizer *videoTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSdverClick)];
    [self addGestureRecognizer:videoTap];
    [_videoView addSubview:_videoImage];
    _videoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    _videoBtn.center = _videoView.center;
    _videoBtn.userInteractionEnabled = YES;
    [_videoBtn addTarget:self action:@selector(clickVideoPlay) forControlEvents:UIControlEventTouchUpInside];
    [_videoBtn setBackgroundImage:[UIImage imageNamed:@"video_play_btn_bg"] forState:UIControlStateNormal];
    [_videoView addSubview:_videoBtn];
    
    _sdverImage.hidden = YES;
    _sdverLabel.hidden = YES;
    _videoView.hidden = YES;
    
}

-(void)setSdverTypeStr:(NSString *)sdverTypeStr{
    _sdverTypeStr = sdverTypeStr;
    if ([_sdverTypeStr isEqualToString:@"0"]) {
        _sdverLabel.hidden = NO;
        self.FromSdverType = FromSdvertisingText;
    }else if ([_sdverTypeStr isEqualToString:@"1"] ){
        _sdverImage.hidden = NO;
        self.FromSdverType = FromSdvertisingImage;
    }else{
        _videoView.hidden = NO;
        self.FromSdverType = FromSdvertisingVideo;
    }
}

-(void)setSdverValue:(NSString *)sdverValue{
    _sdverValue = sdverValue;
    switch (_FromSdverType) {
        case FromSdvertisingText:
        {
            _sdverLabel.text = _sdverValue;
        }
            break;
        case FromSdvertisingImage:
        {
             [_sdverImage sd_setImageWithURL:[NSURL URLWithString:_sdverValue] placeholderImage:[UIImage imageNamed:@"order_add"]];
        }
            break;
        case FromSdvertisingVideo:
        {
            [_videoImage sd_setImageWithURL:[NSURL URLWithString:_sdverValue] placeholderImage:[UIImage imageNamed:@"order_add"]];
        }
            break;
            
        default:
            break;
    }
}
-(void)setVideoStr:(NSString *)videoStr{
    _videoStr = videoStr;
    _wmPlay = [[WMPlayer alloc]initWithFrame:_videoImage.bounds];
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
    if (self.FromSdverType == FromSdvertisingVideo) {
        [self releaseWMPlayer];
    }
}
#pragma mark 点击图片或者文本
-(void)tapSdverClick{
    if ([self.sdverClickDelegate respondsToSelector:@selector(sdverClickEvent)]){
        [self.sdverClickDelegate sdverClickEvent];
    }
}
#pragma mark 点击视频播放
-(void)clickVideoPlay{
    if ([self.sdverClickDelegate respondsToSelector:@selector(sdverPlayVideo)]) {
        [self.sdverClickDelegate sdverPlayVideo];
    }
}
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
//        UIInterfaceOrientation interface = [UIApplication sharedApplication].statusBarOrientation;
//        interface = UIInterfaceOrientationUnknown;

        [UIView animateWithDuration:0.5 animations:^{
            [self addSubview:self->_wmPlay];
            [self->_wmPlay mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).with.offset(0);
                make.left.equalTo(self).with.offset(0);
                make.right.equalTo(self).with.offset(0);
                make.height.equalTo(@(self.frame.size.height));
            }];
//        [self toOrientation:UIInterfaceOrientationPortrait];

            self->_wmPlay.isFullscreen = NO;
            self->_wmPlay.closeBtnStyle = CloseBtnStyleClose;
//            self->_wmPlay.transform = CGAffineTransformMakeRotation(-M_PI/6);
           
        }];
        _wmPlay.transform = CGAffineTransformIdentity;
        [UIView setAnimationDuration:1.0];
        //开始旋转
        [UIView commitAnimations];
    }else{//非全屏
//        [self toOrientation:UIInterfaceOrientationLandscapeRight];

        [UIView animateWithDuration:0.5 animations:^{
            [[UIApplication sharedApplication].keyWindow addSubview:self->_wmPlay];
            [self->_wmPlay mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@([UIScreen mainScreen].bounds.size.height));
                make.height.equalTo(@([UIScreen mainScreen].bounds.size.width));
                make.center.equalTo(self->_wmPlay.superview);
            }];
            self->_wmPlay.isFullscreen = YES;
            self->_wmPlay.closeBtnStyle = CloseBtnStylePop;
        }];
//        _wmPlay.transform = CGAffineTransformIdentity;
        _wmPlay.transform = CGAffineTransformMakeRotation(M_PI*0.5);
        [UIView setAnimationDuration:1.0];
        //开始旋转
        [UIView commitAnimations];
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
