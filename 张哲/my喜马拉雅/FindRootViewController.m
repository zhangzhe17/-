//
//  FindRootViewController.m
//  my喜马拉雅
//
//  Created by lanou3g on 15/11/16.
//  Copyright © 2015年 张哲. All rights reserved.
//

#import "FindRootViewController.h"
#import "UrlAndTag.h"
#import "RecommendViewController.h"
#import "ClassifyViewController.h"
#import "LivePlayViewController.h"
#import "RankingListViewController.h"
#import "HostViewController.h"

#define kClassify_BtnWeight (kViewWidth/5 )
#define kClassify_BtnHeight 30
int scrollIndex = 0;

@interface FindRootViewController ()<UIScrollViewDelegate>

@property (nonatomic ,strong) UIViewController *currentVC;
@property (nonatomic, strong) RecommendViewController *recommendVC;
@property(nonatomic,strong)ClassifyViewController *classifyVC;
@property(nonatomic,strong)LivePlayViewController *liveVC;
@property(nonatomic,strong)RankingListViewController *rankVC;
@property(nonatomic,strong)HostViewController *hostVC;


@end

@implementation FindRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.contentArrary = @[@"Recommend",@"Classify",@"LivePlay",@"RankingList",@"Host"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self createClassfiyView];
    [self createBigScrollView];
}

// navigation下面的分类条
-(void)createClassfiyView{
    
    UILabel* line = [[UILabel alloc] initWithFrame:CGRectMake(20, 26, 40, 2)];
    [line setBackgroundColor:[UIColor orangeColor]];
    line.tag = LINE_TAG;
    [self.view addSubview:line];
    
    NSArray* titleNames = @[@"推荐",@"分类",@"直播",@"榜单",@"主播"];
    //NSInteger len;
    for (int i = 0; i < titleNames.count; i++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(i*kClassify_BtnWeight, 0,kClassify_BtnWeight, 25)];
        [btn setTitle:titleNames[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"宋体" size:16];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [btn addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = BTN_TAG+i;
        [self.view addSubview:btn];
        if (i == 0) {
            btn.selected = YES;
        }
        
    }
}
    

-(void)changeView:(UIButton*)btn
{
    
    UILabel* line = (UILabel*)[self.view viewWithTag:LINE_TAG];
    CGPoint center = line.center;
    center.x = btn.center.x;
    [UIView animateWithDuration:0.1 animations:^{
        line.center = center;
    }];
    ;
    NSArray *array = self.view.subviews;
    for (UIButton* sender in array) {
        if (![sender isMemberOfClass:[UIButton class]]) {
            continue;
        }
        if (sender.tag != btn.tag) {
            sender.selected = NO;
        }
    }
    btn.selected = YES;
    int index = btn.tag - BTN_TAG;
    [_bigScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    if ((self.currentVC==self.recommendVC && index == 0)|| (self.currentVC==self.classifyVC && index == 1)||(self.currentVC==self.liveVC && index == 2)||(self.currentVC==self.rankVC && index == 3)||(self.currentVC==self.hostVC && index == 4)) {
        return;
    }
    switch (index) {
        case 0:
            [self replaceController:self.currentVC newController:self.recommendVC];
            break;
        case 1:
            [self replaceController:self.currentVC newController:self.classifyVC];
            break;
        case 2:
            [self replaceController:self.currentVC newController:self.liveVC];
            break;
        case 3:
            [self replaceController:self.currentVC newController:self.rankVC];
            break;
        case 4:
            [self replaceController:self.currentVC newController:self.hostVC];
            break;
        default:
            break;
    }
    }

-(void)createBigScrollView
{
    _bigScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, kViewWidth, kViewHeight-49-30)];
    _bigScrollView.delegate = self;
    _bigScrollView.pagingEnabled = YES;
    _bigScrollView.contentOffset = CGPointMake(0, 0);
    _bigScrollView.contentSize = CGSizeMake(kViewWidth*5, kViewHeight-49-30);
    _bigScrollView.tag = BIGSCROLL_TAG;
    _bigScrollView.bounces = NO;
    [self.view addSubview:_bigScrollView];
    
//    NSArray* arr = @[@"Recommend",@"Classify",@"LivePlay",@"RankingList",@"Host"];
//    for (int i = 0; i < arr.count; i++) {
//        NSString* className = [NSString stringWithFormat:@"%@ViewController",arr[i]];
//        Class myClass = NSClassFromString(className);
//        UIViewController* vc = [[myClass alloc] init];
//        vc.view.frame = CGRectMake(i*kViewWidth, 0, kViewWidth, 480);
//        if (i==0) {
//            [_bigScrollView addSubview:vc.view];
//            [self addChildViewController:vc];
//             self.currentVC = vc;
//        }
////        [_bigScrollView addSubview:vc.view];
////        [self addChildViewController:vc];
//    }
    // 推荐
    self.recommendVC = [[RecommendViewController alloc]init];
    self.recommendVC.view.frame = CGRectMake(0, 0, kViewWidth, kViewHeight);
    [self addChildViewController:_recommendVC];
    
    // 分类
    self.classifyVC = [[ClassifyViewController alloc]init];
//    [self.classifyVC.view setFrame:CGRectMake(kViewWidth *1, 0, kViewWidth, kViewHeight)];
    // 直播
    self.liveVC = [[LivePlayViewController alloc]init];
    // 榜单
    self.rankVC = [[RankingListViewController alloc]init];
    
    // 主播
    self.hostVC = [[HostViewController alloc]init];
    // 默认
    [self.bigScrollView addSubview:self.recommendVC.view];
    self.currentVC = self.recommendVC;
    
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index = scrollView.contentOffset.x/kViewWidth;
    if (index > 0) {
       scrollIndex++;
    }else{
       scrollIndex--;
    }
    
    UIButton *btn = (UIButton *)[self.view viewWithTag:BTN_TAG +scrollIndex];
    [self changeView:btn];
}

//  切换各个标签内容
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
    
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        
        if (finished) {
            
            [newController didMoveToParentViewController:self];
//            [oldController willMoveToParentViewController:nil];
//            [oldController removeFromParentViewController];
//            if (newController == self.classifyVC) {
//                [self.classifyVC.view setFrame:CGRectMake(kViewWidth *1, 0, kViewWidth, kViewHeight)];
//            }else if (newController == self.liveVC){
//                [self.liveVC.view setFrame:CGRectMake(kViewWidth *2, 0, kViewWidth, kViewHeight)];
//            }else if (newController == self.rankVC){
//                [self.rankVC.view setFrame:CGRectMake(kViewWidth *3, 0, kViewWidth, kViewHeight)];
//            }else if (newController == self.hostVC){
//                [self.hostVC.view setFrame:CGRectMake(kViewWidth *4, 0, kViewWidth, kViewHeight)];
//            }
            self.currentVC = newController;
            
        }else{
            
            self.currentVC = oldController;
            
        }
    }];
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
