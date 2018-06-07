//
//  ServiceViewController.m
//  Advertising
//
//  Created by hht on 2018/5/22.
//  Copyright © 2018年 hht. All rights reserved.
//

#import "ServiceViewController.h"
#import "YKTAlphaSdverView.h"
#import "ClickImageViewController.h"

@interface ServiceViewController ()<AlphaSdverClickDelegate>
@property (strong, nonatomic) YKTAlphaSdverView *alphaSdverView;
@property (strong, nonatomic) UIView *lucencyView;//遮罩层
@end

@implementation ServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"服务";
    self.view.backgroundColor = [UIColor purpleColor];
    
    [self greatSdvertisingUI];//创建广告位
    // Do any additional setup after loading the view.
}
#pragma mark 创建广告位
-(void)greatSdvertisingUI{
    _lucencyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _lucencyView.backgroundColor = [UIColor blackColor];
    _lucencyView.alpha = 0.5;
    [[UIApplication sharedApplication].keyWindow addSubview:_lucencyView];
    
    _alphaSdverView = [[YKTAlphaSdverView alloc]initWithFrame:CGRectMake(0, 0, 311*adapterRect, 374*adapterRect)];//445
    _alphaSdverView.center = _lucencyView.center;
    _alphaSdverView.alphaSdverClickDelegate = self;
    _alphaSdverView.alphaSdverTypeStr = @"1";
    _alphaSdverView.alphaSdverValue = URL_heightImage;
   [[UIApplication sharedApplication].keyWindow addSubview:_alphaSdverView];
    
    UIButton *deleteBtn = [[UIButton alloc]init];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(delegateClick) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_alphaSdverView.mas_bottom).with.offset(25);
        make.centerX.equalTo(self->_lucencyView);
        make.size.mas_equalTo(CGSizeMake(45*adapterRect, 45*adapterRect));
            }];
}
#pragma mark 点击广告位
-(void)alphaSdverClickEvent{
    NSLog(@"点击广告位");
    [_lucencyView removeFromSuperview];
    [_alphaSdverView removeFromSuperview];
    
    ClickImageViewController *clickImage = [[ClickImageViewController alloc]init];
    Navcontroller_push(clickImage);
}
#pragma mark 点击视频播放
-(void)alphaSdverPlayVideo{
    NSLog(@"点击播放视频");
    _alphaSdverView.videoStr = URL_Video;

}
#pragma mark 点击关闭广告
-(void)delegateClick{
    [_lucencyView removeFromSuperview];
    [_alphaSdverView removeFromSuperview];
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
