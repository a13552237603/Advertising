//
//  MineViewController.m
//  Advertising
//
//  Created by hht on 2018/5/22.
//  Copyright © 2018年 hht. All rights reserved.
//

#import "MineViewController.h"
#import "YKTSdvertisingspaceView.h"
#import "WMPlayer.h"
#import "ClickImageViewController.h"
#import "CodeViewController.h"
#import "ManyImageViewController.h"

@interface MineViewController ()<SdvertisingClickDelegate,WMPlayerDelegate>

@property (strong, nonatomic) YKTSdvertisingspaceView *sdverView;
@property (strong, nonatomic) WMPlayer *wmPlay;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人中心";
    self.view.backgroundColor = [UIColor purpleColor];
    
    [self greatSdvertisingUI];//创建广告位
    
    [self greatCode];//生成二维码
    [self greatMoreImage];//上传多张图片
    // Do any additional setup after loading the view.
}
#pragma mark 创建广告位
-(void)greatSdvertisingUI{
    _sdverView = [[YKTSdvertisingspaceView alloc]initWithFrame:CGRectMake(0, 300*adapterRect, kScreenWidth, 88*adapterRect)];
    _sdverView.sdverClickDelegate = self;
    _sdverView.sdverTypeStr = @"2";
    _sdverView.sdverValue = URL_legthImage;
    [self.view addSubview:_sdverView];
    
}
-(void)greatCode{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 200, 100, 50)];
    [button setTitle:@"生成二维码" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blackColor]];
    [button addTarget:self action:@selector(codeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}
-(void)greatMoreImage{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 50)];
    [button setTitle:@"多张图片" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blackColor]];
    [button addTarget:self action:@selector(moreImageClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

}
-(void)codeClick{
    CodeViewController *code = [[CodeViewController alloc]init];
    Navcontroller_push(code);

}
-(void)moreImageClick{
    ManyImageViewController *moreImage = [[ManyImageViewController alloc]init];
    Navcontroller_push(moreImage);

}
#pragma mark 点击广告位
-(void)sdverClickEvent{
    NSLog(@"点击广告位");
    ClickImageViewController *clickImage = [[ClickImageViewController alloc]init];
    Navcontroller_push(clickImage);
    
    
}
#pragma mark 点击播放视频
-(void)sdverPlayVideo{
    NSLog(@"点击播放视频");
    _sdverView.videoStr = URL_Video;
    
}
    /*
    _wmPlay = [[WMPlayer alloc]initWithFrame:_sdverView.videoImage.bounds];
    _wmPlay.delegate = self;
    _wmPlay.closeBtnStyle = CloseBtnStyleClose;
    _wmPlay.userInteractionEnabled = YES;
    _wmPlay.topView.hidden = YES;
    //关闭音量调节的手势
    //        wmPlayer.enableVolumeGesture = NO;
    _wmPlay.titleLabel.text = @"这是个测试视频";
    _wmPlay.URLString = URL_Video;
    [_wmPlay play];
    
    [_sdverView addSubview:_wmPlay];
//    [_sdverView.videoImage addSubview:_wmPlay];
//    [_sdverView.videoImage bringSubviewToFront:_wmPlay];
//    [_sdverView.videoBtn.superview sendSubviewToBack:_sdverView.videoBtn];
}
#pragma mark 播放完毕
-(void)wmplayerFinishedPlay:(WMPlayer *)wmplayer{
    NSLog(@"wmplayerDidFinishedPlay");
   // [_sdverView.videoBtn.superview bringSubviewToFront:_sdverView.videoBtn];
    [self releaseWMPlayer];
    [self setNeedsStatusBarAppearanceUpdate];
}
#pragma mark 点击全屏
-(void)wmplayer:(WMPlayer *)wmplayer clickedFullScreenButton:(UIButton *)fullScreenBtn{
     [_wmPlay removeFromSuperview];
    if (_wmPlay.isFullscreen==YES) {//全屏
        [_sdverView addSubview:_wmPlay];
        [_wmPlay mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_sdverView).with.offset(0);
            make.left.equalTo(self->_sdverView).with.offset(0);
            make.right.equalTo(self->_sdverView).with.offset(0);
            make.height.equalTo(@(self->_sdverView.frame.size.height));
        }];
        _wmPlay.isFullscreen = NO;
        _wmPlay.closeBtnStyle = CloseBtnStyleClose;

    }else{//非全屏
        
       [[UIApplication sharedApplication].keyWindow addSubview:_wmPlay];
        [_wmPlay mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([UIScreen mainScreen].bounds.size.width));
            make.height.equalTo(@([UIScreen mainScreen].bounds.size.height));
            make.center.equalTo(self->_wmPlay.superview);
        }];
        _wmPlay.isFullscreen = YES;
        _wmPlay.closeBtnStyle = CloseBtnStylePop;

    }
}

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
     */
//点击进入,退出全屏,或者监测到屏幕旋转去调用的方法

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _sdverView.removeStr = @"2";
    // [self releaseWMPlayer];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
