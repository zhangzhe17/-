//
//  RecommendViewController.m
//  my喜马拉雅
//
//  Created by lanou3g on 15/11/17.
//  Copyright (c) 2015年 张哲. All rights reserved.
//

#import "RecommendViewController.h"
#import "UrlAndTag.h"
#import "FocusImages.h"
#import "RecommendCell.h"
#import "Recommend.h"
#import "UIImageView+WebCache.h"
#import "RecommendCell.h"
#import "SpeciaTableViewCell.h"
#import "Special.h"
#import "AlbumldViewController.h"
#import "CYImageView.h"
#define kScrollHeigh 180


@interface RecommendViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)NSTimer* timer;
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIPageControl *page;
@property(nonatomic, strong)UITableView *tableView;

// 解析出的数据
// 轮播图
@property(nonatomic,strong)NSMutableArray *imageArray;
// 小编推荐
@property(nonatomic,strong)NSMutableArray *recommendArray;
// 精品听单
@property(nonatomic,strong)NSMutableArray *specialArray;
// 发现新奇
@property(nonatomic,strong)NSMutableArray *NewArray;
// 听XX
@property(nonatomic,strong)NSMutableDictionary *listenDictionary;
@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kViewWidth, kViewHeight-64-49) style:(UITableViewStyleGrouped)];
    _tableView.sectionFooterHeight = 1;
    _tableView.sectionHeaderHeight = 1;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self registerNib];
    
    
    // 轮播图
    [self creatScrollView];
    //创建一个计时器 
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    //设置时间无限
    [_timer setFireDate:[NSDate distantPast]];
    
    // 解析数据
    [self dataParse];
    
}


-(void)registerNib{
    [self.tableView registerNib:[UINib nibWithNibName:@"RecommendCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"RecommendCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SpeciaTableViewCell" bundle:nil] forCellReuseIdentifier:@"SpeciaTableViewCell"];
    
}
-(void)creatScrollView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kViewWidth, kScrollHeigh)];
    view.tag = BACKVIEW_TAG;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, kScrollHeigh)];
    
    _scrollView.contentSize = CGSizeMake(kViewWidth * 7, kScrollHeigh);
    _scrollView.backgroundColor = [UIColor yellowColor];
    // 整页翻动
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    self.page = [[UIPageControl alloc]initWithFrame:CGRectMake(kViewWidth/2, 150, 100, 30)];
    _page.numberOfPages = 7;
    _page.pageIndicatorTintColor = [UIColor lightGrayColor];
    _page.currentPageIndicatorTintColor = [UIColor whiteColor];
    [_page addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventValueChanged];
    
    for (int i = 0; i < 7; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake( kViewWidth *i, 0, kViewWidth, 180)];
        imgView.tag = HEADSCROLLIMAGE_TAG+i;
        imgView.userInteractionEnabled = YES;
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png", 1]];
        [_scrollView addSubview:imgView];
    }
    [view addSubview:_scrollView];
    [view addSubview:_page];
    self.tableView.tableHeaderView = view;
    
}
-(void)nextPage{
    NSInteger page = 0;
    
    if (_page.currentPage == 6) {
        page = 0;
    }else{
        page = _page.currentPage + 1;
    }
    //计算滚动的位置
    
    CGFloat offsetX = page * kViewWidth;
    CGPoint offset = CGPointMake(offsetX, 0);
    _page.currentPage = page;
    [_scrollView setContentOffset:offset];
}

- (void)pageAction:(UIPageControl *)sender{
    _scrollView.contentOffset = CGPointMake(sender.currentPage*kViewWidth, 0);
}

// 停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //    NSLog(@"%s--%d",__func__, __LINE__);
    NSInteger page = _scrollView.contentOffset.x / kViewWidth;
    _page.currentPage = page;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 15;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
//    return self.recommendArray.count;
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
         //
    NSArray *titleArray = @[@"听新闻",@"听小说",@"听脱口秀",@"听相声",@"听音乐",@"听情感心声",@"听历史",@"听讲座",@"听广播剧",@"听儿童故事",@"听外语",@"听游戏"];
    
    NSInteger section = indexPath.section;
    // 精品听单
    if (section == 1 && self.specialArray.count !=0) {
        SpeciaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpeciaTableViewCell" forIndexPath:indexPath];
        [cell setArray:self.specialArray];
        
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        Special *special1 = _specialArray[0];
        NSDictionary* dic1 = @{@"albumId":[NSNumber numberWithInteger:special1.albumId],@"position":@"1"};
        [cell.FirstImgVIew addClickedWithTarget:self action:@selector(clickToAlbumld:) withObjcet:dic1];
        
        Special *special2 = _specialArray[1];
        NSDictionary* dic2 = @{@"albumId":[NSNumber numberWithInteger:special2.albumId],@"position":@"2"};
        [cell.SecongImgView addClickedWithTarget:self action:@selector(clickToAlbumld:) withObjcet:dic2];
        
        return cell;
        // 其他
    }else{
        RecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendCell" forIndexPath:indexPath];
        if (section==0&&self.recommendArray.count!=0) {
            cell.titleLabel.text = @"小编推荐";
            [cell setArray:self.recommendArray];
            Recommend *special1 = _recommendArray[0];
            NSDictionary* dic1 = @{@"albumId":[NSNumber numberWithInteger:special1.albumId],@"position":@"1",@"title":special1.title};
            [cell.FirstImgView addClickedWithTarget:self action:@selector(clickToAlbumld:) withObjcet:dic1];
            
            Recommend *special2 = _recommendArray[1];
            NSDictionary* dic2 = @{@"albumId":[NSNumber numberWithInteger:special2.albumId],@"position":@"2",@"title":special2.title};
            [cell.SecondImgView addClickedWithTarget:self action:@selector(clickToAlbumld:) withObjcet:dic2];
            Recommend *special3 = _recommendArray[2];
            NSDictionary* dic3 = @{@"albumId":[NSNumber numberWithInteger:special3.albumId],@"position":@"3",@"title":special3.title};
            [cell.ThirdImgView addClickedWithTarget:self action:@selector(clickToAlbumld:) withObjcet:dic3];

        }else if(_listenDictionary!=nil){
            for (int i = 0; i<titleArray.count; i++) {
                if (section==i+2) {
                    NSMutableArray *array = [self.listenDictionary objectForKey:titleArray[i]];
                    cell.titleLabel.text = titleArray[i];
                    [cell setArray:array];
                    Recommend *special1 = array[0];
                    NSDictionary* dic1 = @{@"albumId":[NSNumber numberWithInteger:special1.albumId],@"position":@"1",@"title":special1.title};
                    [cell.FirstImgView addClickedWithTarget:self action:@selector(clickToAlbumld:) withObjcet:dic1];
                    
                    Recommend *special2 = array[1];
                    NSDictionary* dic2 = @{@"albumId":[NSNumber numberWithInteger:special2.albumId],@"position":@"2",@"title":special2.title};
                    [cell.SecondImgView addClickedWithTarget:self action:@selector(clickToAlbumld:) withObjcet:dic2];
                    Recommend *special3 = array[2];
                    NSDictionary* dic3 = @{@"albumId":[NSNumber numberWithInteger:special3.albumId],@"position":@"3",@"title":special3.title};
                    [cell.ThirdImgView addClickedWithTarget:self action:@selector(clickToAlbumld:) withObjcet:dic3];

                }
            }
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kViewWidth/3 + 25+30;
}
// 数据解析
-(void)dataParse{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kRecommengURL]];
    NSURLSession *conn = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [conn dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:&error];
        // 轮播图
        NSDictionary *focImags = dic[@"focusImages"];
               NSArray *array = focImags[@"list"];
        for (NSDictionary *dictionary in array) {
            FocusImages *fo = [FocusImages new];
            [fo setValuesForKeysWithDictionary:dictionary];
            [self.imageArray addObject:fo];
        }

        // 小编推荐
        NSDictionary *recommend = dic[@"editorRecommendAlbums"];
        NSArray *recArray = recommend[@"list"];
//        NSString *titleName = recommend[@"title"];
        for (NSDictionary *dictionary in recArray) {
            Recommend *rec = [Recommend new];
            [rec setValuesForKeysWithDictionary:dictionary];
            [self.recommendArray addObject:rec];
        }
        // 精品听单
        NSDictionary *special = dic[@"specialColumn"];
        NSArray *speArray = special[@"list"];
//        NSString *titleName = recommend[@"title"];
        for (NSDictionary *dictionary in speArray) {
            Special *rec = [Special new];
            [rec setValuesForKeysWithDictionary:dictionary];
            [self.specialArray addObject:rec];
        }
        // 发现新奇
        NSDictionary *newDic = dic[@"discoveryColumns"];
        NSArray *newArray = newDic[@"list"];
        for (NSDictionary *dictionary in newArray) {
            Recommend *rec = [Recommend new];
            [rec setValuesForKeysWithDictionary:dictionary];
            [self.NewArray addObject:rec];
        }

        // 听XX
        NSDictionary *listenDic = dic[@"hotRecommends"];
        NSArray *listenArray = listenDic[@"list"];
        for (NSDictionary *dictionary in listenArray) {
            NSString *title = dictionary[@"title"];
            NSArray *list = dictionary[@"list"];
            NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:3];
            for (NSDictionary *dict in list) {
                Recommend *rec = [Recommend new];
                [rec setValuesForKeysWithDictionary:dict];
                [contentArray addObject:rec];
            }
            [self.listenDictionary setObject:contentArray forKey:title];
        }

        
        // 更新数据
        [self updateTableHeader];
    }];
    [dataTask resume];
}

//懒加载
-(NSMutableArray *)imageArray{
    if (_imageArray==nil) {
        _imageArray = [NSMutableArray arrayWithCapacity:7];
    }
    return _imageArray;
}
-(NSMutableArray *)recommendArray{
    if (_recommendArray == nil) {
        _recommendArray = [NSMutableArray arrayWithCapacity:3];
    }
    return _recommendArray;
}
-(NSMutableArray *)specialArray{
    if (_specialArray == nil) {
        _specialArray = [NSMutableArray arrayWithCapacity:3];
    }
    return _specialArray;
}
-(NSMutableArray *)NewArray{
    if (_NewArray == nil) {
        _NewArray = [NSMutableArray arrayWithCapacity:3];
    }
    return _NewArray;
}
-(NSMutableDictionary *)listenDictionary{
    if (_listenDictionary == nil) {
        _listenDictionary = [NSMutableDictionary dictionary];
    }
    return _listenDictionary;
}

// cell点击方法
-(void)clickToAlbumld:(NSMutableDictionary *)dic{
//    AlbumldViewController *albumld = [[AlbumldViewController alloc]initWithNibName:@"AlbumldViewController" bundle:nil];
    //使用Storyboard初始化根界面
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"AlbumldStoryboard" bundle:nil];
    AlbumldViewController *albumld= [storyBoard instantiateInitialViewController];
    albumld.paramDictionary = dic;
    [self showDetailViewController:albumld sender:nil];
    
    
}


// 更新轮播图的图片
- (void)updateTableHeader
{
    
    UIView* backView = [self.view viewWithTag:BACKVIEW_TAG];
    for (int j = 0; j < self.imageArray.count; j++) {
        
        UIImageView * imageView =(UIImageView*)[_scrollView viewWithTag:HEADSCROLLIMAGE_TAG+j];
        FocusImages * model = self.imageArray[j];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.pic]];
            // 封装的uiimageview
//            [imageView addClickedWithTarget:self action:@selector(playMedia:) withObjcet:dic];
            
    }
    [_tableView reloadData];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
