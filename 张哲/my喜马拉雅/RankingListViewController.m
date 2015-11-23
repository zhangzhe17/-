//
//  RankingListViewController.m
//  my喜马拉雅
//
//  Created by lanou3g on 15/11/18.
//  Copyright © 2015年 张哲. All rights reserved.
//

#import "RankingListViewController.h"
#import "UrlAndTag.h"
#import "fxbangdanTableViewCell.h"
#import "faxianBangDanModel.h"
#import "AFNetworking.h"
#import "faxianBangDanFocusImagesModel.h"
#import "UIImageView+WebCache.h"

#define kHeaderViewHeight 150

@interface RankingListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView * tabelView;
@property (nonatomic,strong) UIImageView * images;
@property (nonatomic,strong) NSMutableArray * mutableArray;
@property (nonatomic,strong) NSMutableDictionary * mutableDic;
@property (nonatomic,strong) faxianBangDanFocusImagesModel * focusImageModel;


@end

@implementation RankingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kViewWidth, kViewHeight - 64 - 49) style:(UITableViewStyleGrouped)];
    
    _tabelView.dataSource = self;
    _tabelView.delegate = self;
    
    [_tabelView registerNib:[UINib nibWithNibName:@"fxbangdanTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellReuse2"];
    
    
    self.images = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kViewWidth, kHeaderViewHeight)];
    _tabelView.tableHeaderView = _images;
    
    [self.view addSubview:_tabelView];
    [self loadBangdan];
}

- (void)loadBangdan{
    NSURL *url = [NSURL URLWithString:kFaxianBangdanUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL: url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *html = operation.responseString;
        NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSMutableArray * array = dataDic[@"datas"];
        
        self.mutableArray = [NSMutableArray array];
        self.mutableDic = [NSMutableDictionary dictionary];
        for (NSDictionary * dic in array) {
            
            [_mutableArray addObject:dic[@"title"]];
            NSArray * arrayList = dic[@"list"];
            NSMutableArray * resultArray = [NSMutableArray array];
            for (NSDictionary * dict in arrayList) {
                faxianBangDanModel * results = [faxianBangDanModel new];
                [results setValuesForKeysWithDictionary:dict];
                NSLog(@"%@",results);
                [resultArray addObject:results];
            }
            [_mutableDic setObject:resultArray forKey:dic[@"title"]];
        }
        
        NSMutableDictionary * didfocus = dataDic[@"focusImages"];
        NSArray * arrayList = didfocus[@"list"];
        NSMutableDictionary * focusImageDic = arrayList[0];
        faxianBangDanFocusImagesModel * focusModel = [faxianBangDanFocusImagesModel new];
        [focusModel setValuesForKeysWithDictionary:focusImageDic];
        [self.tabelView reloadData];
        [_images sd_setImageWithURL:[NSURL URLWithString:focusModel.pic] placeholderImage:[UIImage imageNamed:@"loads"]];
 
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error:%@", error);
    }];
    [[NSOperationQueue mainQueue] addOperation:operation];
}


#pragma mark tableViewDataSource
//必须实现 分区header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

//必须实现 分区footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

// 设置显示数据 与viewForHeaderInSection 不可以共存
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _mutableArray[section];
}

// 可选择实现 设置分区个数  不写 默认为1
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

// 必须实现 设置每个分区有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

//必须实现  每一行显示的信息 cell

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    fxbangdanTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellReuse2"];
    NSMutableArray * muArray = _mutableDic[_mutableArray[indexPath.section]];
    faxianBangDanModel * model = muArray[indexPath.row];
    if (model != nil) {
        cell.bdModel = model;
    }
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

#pragma mark tableViewDelegate

// 点击row时 获取路径
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
