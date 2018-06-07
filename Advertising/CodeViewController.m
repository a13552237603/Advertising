//
//  CodeViewController.m
//  Advertising
//
//  Created by hht on 2018/5/29.
//  Copyright © 2018年 hht. All rights reserved.
//

#import "CodeViewController.h"
#import "UIImage+Code.h"

@interface CodeViewController (){
    CGFloat bright;
}

@end

@implementation CodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"生成二维码";
    self.view.backgroundColor = [UIColor whiteColor];

     bright = [[UIScreen mainScreen] brightness];
    
    UIImageView *wechatImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 200, 200,200)];
    wechatImageView.image = [UIImage codeImageFromeString:@"https://www.jianshu.com/u/db4a11fa4081" imageSize:400.0 logoImageSize:100.0];
   // wechatImageView.image = [UIImage codeImageFromeString:@"https://www.jianshu.com/u/db4a11fa4081" imageSize:400.0];
    [self.view addSubview:wechatImageView];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIScreen mainScreen] setBrightness: 1.0];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIScreen mainScreen] setBrightness: bright];
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
