//
//  ViewController.m
//  Advertising
//
//  Created by hht on 2018/5/21.
//  Copyright © 2018年 hht. All rights reserved.


#import "ViewController.h"
#import "YKTSuspendView.h"
#import "ClickImageViewController.h"
#include "sha256.h"

@interface ViewController ()<SuspendClickDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) YKTSuspendView *suspendView;
@property(nonatomic,assign)BOOL suspendBool;//判断是否点击悬浮框


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"首页";
    self.view.backgroundColor = [UIColor purpleColor];
    
    
    [self greatSupendUI];
    [self greatClickBtn];//创建一个按钮
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma 创建UI
-(void)greatSupendUI{
    _suspendBool = YES;
    self.window = [[UIApplication sharedApplication] delegate].window;
    _suspendView = [[YKTSuspendView alloc]initWithFrame:CGRectMake(kScreenWidth-44, 400*adapterRect, 44, 70)];
    _suspendView.clickDelegate = self;
    _suspendView.typeStr = @"1";
    _suspendView.imageStr = URL_dynImage;
    [self.window addSubview:_suspendView];
//    [self.window bringSubviewToFront:_suspendView];
}

#pragma mark 点击图片
-(void)clickEvent{
    NSLog(@"点击图片");
   // [_suspendView removeFromSuperview];
    _suspendView.hidden = YES;
    ClickImageViewController *clickImage = [[ClickImageViewController alloc]init];
    Navcontroller_push(clickImage);
}
#pragma mark 关闭悬浮图标
-(void)dismissEvent{
    NSLog(@"点击关闭");
    [_suspendView removeFromSuperview];
   // [ToolHelper saveToDefaultWithObj:@"1" forKey:@"suspendImage"];
}


//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    _suspendView.hidden = NO;
//}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_suspendBool) {
         _suspendView.hidden = NO;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_suspendBool) {
        _suspendView.hidden = YES;
    }
}

-(void)greatClickBtn{
    UIButton *clickBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 300, 80, 80)];
    [clickBtn setTitle:@"判断卡号" forState:UIControlStateNormal];
    [clickBtn addTarget:self action:@selector(clickNumber) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clickBtn];
}
-(void)clickNumber{
    NSLog(@"判断卡号");
    CSHA256CalDlg();
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
