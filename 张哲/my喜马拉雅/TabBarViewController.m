//
//  TabBarViewController.m
//  my喜马拉雅
//
//  Created by lanou3g on 15/11/16.
//  Copyright © 2015年 张哲. All rights reserved.
//

#import "TabBarViewController.h"
#import "FindRootViewController.h"
#import "PlayViewController.h"
#import "CustomViewController.h"
#import "DownLoadViewController.h"
#import "UserViewController.h"
#import "CYLTabBarController.h"


@interface TabBarViewController ()


@end

@implementation TabBarViewController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.tabBar.backgroundColor = [UIColor redColor];
////    FindRootViewController *findVC = [[FindRootViewController alloc]init];
////    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:findVC];
////    self.viewControllers = @[nav1];
//    
////    [self setUpTabBarItemsAttributesForController:_tabBarController];
//////    [self addChildViewController:_tabBarController];
////    self.viewControllers = @[_tabBarController];
//    
//}
-(CYLTabBarController *)tabBarController{
    
        FindRootViewController *firstViewController = [[FindRootViewController alloc] init];
        UIViewController *firstNavigationController = [[UINavigationController alloc]
                                                       initWithRootViewController:firstViewController];
        
        CustomViewController *secondViewController = [[CustomViewController alloc] init];
        UIViewController *secondNavigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:secondViewController];
        
        DownLoadViewController *thirdViewController = [[DownLoadViewController alloc] init];
        UIViewController *thirdNavigationController = [[UINavigationController alloc]
                                                       initWithRootViewController:thirdViewController];
        
        UserViewController *fourthViewController = [[UserViewController alloc] init];
        UIViewController *fourthNavigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:fourthViewController];
        CYLTabBarController *tabBarController = [[CYLTabBarController alloc] init];
        
        /*
         *
         在`-setViewControllers:`之前设置TabBar的属性，设置TabBarItem的属性，包括 title、Image、selectedImage。
         *
         */
        [self setUpTabBarItemsAttributesForController:tabBarController];
        
        [tabBarController setViewControllers:@[
                                               firstNavigationController,
                                               secondNavigationController,
                                               thirdNavigationController,
                                               fourthNavigationController
                                               ]];
   _tabBarControllers = tabBarController;
    
    return self.tabBarControllers;
    
    
}

- (void)setUpTabBarItemsAttributesForController:(CYLTabBarController *)tabBarController {
    
    NSDictionary *dict1 = @{
                            CYLTabBarItemTitle : @"发现",
                            CYLTabBarItemImage : @"tab4",
                            CYLTabBarItemSelectedImage : @"tab4_down",
                            };
    NSDictionary *dict2 = @{
                            CYLTabBarItemTitle : @"定制听",
                            CYLTabBarItemImage : @"tab1",
                            CYLTabBarItemSelectedImage : @"tab1_down",
                            };
    NSDictionary *dict3 = @{
                            CYLTabBarItemTitle : @"下载听",
                            CYLTabBarItemImage : @"tab2",
                            CYLTabBarItemSelectedImage : @"tab2_down",
                            };
    NSDictionary *dict4 = @{
                            CYLTabBarItemTitle : @"我",
                            CYLTabBarItemImage : @"tab5",
                            CYLTabBarItemSelectedImage : @"tab5_down"
                            };
    NSArray *tabBarItemsAttributes = @[
                                       dict1,
                                       dict2,
                                       dict3,
                                       dict4
                                       ];
    tabBarController.tabBarItemsAttributes = tabBarItemsAttributes;
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
