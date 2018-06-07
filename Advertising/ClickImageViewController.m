//
//  ClickImageViewController.m
//  Advertising
//
//  Created by hht on 2018/5/22.
//  Copyright © 2018年 hht. All rights reserved.
//


#import "ClickImageViewController.h"
#import "YKTSdvertisingManager.h"
#import "YKTSuspendView.h"

@interface ClickImageViewController ()<UIWebViewDelegate,SuspendClickDelegate>
@property (nonatomic,strong)UIWebView *heiWeb;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) YKTSuspendView *suspendView;

@end

@implementation ClickImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"点击图片";
    
    _heiWeb = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [_heiWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URL_Baidu]]];
    _heiWeb.delegate = self;
    
    [self.view addSubview:_heiWeb];
    
    BOOL greatBool = [YKTSdvertisingManager shareSdverManager].Home_close;
    if (greatBool == YES) {
        [self greatSupendUI];
    }
    // Do any additional setup after loading the view.
}
#pragma 创建UI
-(void)greatSupendUI{
    self.window = [[UIApplication sharedApplication] delegate].window;
    _suspendView = [[YKTSuspendView alloc]initWithFrame:CGRectMake(kScreenWidth-44, 200*adapterRect, 44, 70)];
    _suspendView.clickDelegate = self;
    _suspendView.typeStr = @"1";
    _suspendView.imageStr = URL_dynImage;
    [self.window addSubview:_suspendView];
    //    [self.window bringSubviewToFront:_suspendView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    float height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    NSLog(@"height===%f",height);
    
}
#pragma mark 点击图片
-(void)clickEvent{
    NSLog(@"点击图片");
    // [_suspendView removeFromSuperview];
   //    _suspendView.hidden = YES;
}
#pragma mark 关闭悬浮图标
-(void)dismissEvent{
    NSLog(@"点击关闭");
    [_suspendView removeFromSuperview];
    [[YKTSdvertisingManager shareSdverManager]updateWithHome:NO];
    // [ToolHelper saveToDefaultWithObj:@"1" forKey:@"suspendImage"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ( [YKTSdvertisingManager shareSdverManager].Home_close == YES) {
        _suspendView.hidden = NO;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([YKTSdvertisingManager shareSdverManager].Home_close == YES) {
        _suspendView.hidden = YES;
    }
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
