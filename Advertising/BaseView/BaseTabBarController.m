//
//  BaseTabBarController.m
//  StarBuyer
//
//  Created by 贺恒涛 on 17/11/6.
//  Copyright © 2017年 bigbo. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseNavController.h"
#import "UIImage+Cut.h"
#import "ViewController.h"
#import "ServiceViewController.h"
#import "MineViewController.h"

#define isIphoneX   CGRectEqualToRect([UIScreen mainScreen].bounds, CGRectMake(0, 0, 375, 812))
@interface BaseTabBarController ()<UITabBarControllerDelegate>


@end

@implementation BaseTabBarController

- (instancetype)init {
    if (self = [super init]) {
    
    }
    return self;
}

//-(void)viewWillLayoutSubviews{
//
//    [super viewWillLayoutSubviews];
//
//    if (isIphoneX) {
//
//        CGRect frame = self.tabBar.frame;
//        frame.size.height = 49;
//        frame.origin.y = self.view.frame.size.height - frame.size.height;
//        self.tabBar.frame = frame;
//
//    }
//}
#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:14.0/255.0 green:14.0/255.0 blue:18.0/255.0 alpha:1.0]];
    [UITabBar appearance].translucent = NO;
    
    [self addSubViewsControllers];
    [self customTabbarItem];
}

-(void)addSubViewsControllers{
    
    NSArray *classControllers = @[@"ViewController",@"ServiceViewController",@"MineViewController"];
    NSMutableArray *conArr = [NSMutableArray array];
    
    for (int i = 0; i < classControllers.count; i ++) {
        Class cts = NSClassFromString(classControllers[i]);
        UIViewController *vc = [[cts alloc] init];
        BaseNavController *naVC = [[BaseNavController alloc] initWithRootViewController:vc];
        [conArr addObject:naVC];
    }
    self.viewControllers = conArr;
}

-(void)customTabbarItem{
    
    NSArray *titles = @[@"首页",@"服务",@"个人"];
    NSArray *normalImages = @[@"icon_shouye", @"icon_tongzhi", @"icon_dingdan"];
    NSArray *selectImages = @[@"icon_shouye_sele", @"icon_tongzhi_sele", @"icon_dingdan_sele"];
    
    for (int i = 0; i < titles.count; i++){
        UIViewController *vc = self.viewControllers[i];
        UIImage *normalImage = [UIImage imageWithOriginalImageName:normalImages[i]];
        UIImage *selectImage = [UIImage imageWithOriginalImageName:selectImages[i]];
        vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:titles[i] image:normalImage selectedImage:selectImage];
    }
    //设置TabBar的颜色
    //    [self.tabBar setBarTintColor:kNavigationBarBg];
    
}

/************************************
 //想让TabBarItem跳动可以打开下面的代码
 ************************************/

//
//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
//    NSLog(@"item name = %@", item.title);
//    NSInteger index = [self.tabBar.items indexOfObject:item];
//    [self animationWithIndex:index];
//    if([item.title isEqualToString:@"发现"]){
//        NSLog(@"---------发现");
//    }
//}
//- (void)animationWithIndex:(NSInteger) index {
//
//    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
//    for (UIView *tabBarButton in self.tabBar.subviews) {
//        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
//            [tabbarbuttonArray addObject:tabBarButton];
//        }
//    }
//    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    pulse.duration = 0.2;
//    pulse.repeatCount= 1;
//    pulse.autoreverses= YES;
//    pulse.fromValue= [NSNumber numberWithFloat:0.7];
//    pulse.toValue= [NSNumber numberWithFloat:1.3];
//    [[tabbarbuttonArray[index] layer] addAnimation:pulse forKey:nil];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
{
//    viewController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",3];//标记
}

#pragma mark - View rotation
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}


- (void)dealloc {
    
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
