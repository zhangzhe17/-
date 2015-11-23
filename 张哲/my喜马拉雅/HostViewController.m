//
//  HostViewController.m
//  my喜马拉雅
//
//  Created by lanou3g on 15/11/18.
//  Copyright © 2015年 张哲. All rights reserved.
//

#import "HostViewController.h"
#import "fxzhuboTableViewCell.h"
#import "faxianZhuboModel.h"
#import "UrlAndTag.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

#define kViewWidth self.view.frame.size.width
#define kViewHeight self.view.frame.size.height

@interface HostViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView * tabelView;
@property (nonatomic,strong) NSMutableArray * mutableArray;
@property (nonatomic,strong) NSMutableDictionary * mutableDic;

@end

@implementation HostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kViewWidth, kViewHeight - 64 - 49) style:(UITableViewStyleGrouped)];
    
    _tabelView.dataSource = self;
    _tabelView.delegate = self;
    
    [_tabelView registerNib:[UINib nibWithNibName:@"fxzhuboTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellZhubo"];
    
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(1, 1, 1, 1)];
    _tabelView.tableHeaderView = view1;
    
    [self.view addSubview:_tabelView];
    [self loadHost];
}

-(void)loadHost{
    NSURL *url = [NSURL URLWithString:kFaxianZhuboUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL: url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *html = operation.responseString;
        NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        
        self.mutableArray = [NSMutableArray array];
        self.mutableDic = [NSMutableDictionary dictionary];
        
        NSMutableArray * array = dataDic[@"list"];
        for (NSDictionary * dic in array) {
            [_mutableArray addObject:dic[@"title"]];
            NSArray * arrayList = dic[@"list"];
            NSMutableArray * resultArray = [NSMutableArray array];
            for (NSDictionary * dict in arrayList) {
                faxianZhuboModel * model = [faxianZhuboModel new];
                [model setValuesForKeysWithDictionary:dict];
                model.name = dic[@"title"];
                NSLog(@"%@",model);
                [resultArray addObject:model];
            }
            [_mutableDic setObject:resultArray forKey:dic[@"title"]];
        }
        
        NSMutableDictionary * arrayZB = dataDic[@"recommendBozhu"];
        [_mutableArray addObject:@"新晋主播"];
        NSArray * zhuboModel = arrayZB[@"list"];
        NSMutableArray * resultArray = [NSMutableArray array];
        for (NSDictionary * dict in zhuboModel) {
            faxianZhuboModel * model = [faxianZhuboModel new];
            [model setValuesForKeysWithDictionary:dict];
            NSLog(@"%@",model);
            [resultArray addObject:model];
        }
        [_mutableDic setObject:resultArray forKey:@"新晋主播"];
        [self.tabelView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error:%@", error);
    }];
    [[NSOperationQueue mainQueue] addOperation:operation];
    
}

#pragma mark tableViewDataSource
//必须实现 分区header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

//必须实现 分区footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

// 可选择实现 设置分区个数  不写 默认为1
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _mutableArray.count;
}

// 必须实现 设置每个分区有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//必须实现  每一行显示的信息 cell

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    注册后 重用cell
    fxzhuboTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellZhubo"];
    if (indexPath.section == 0) {
        cell.detailInfo = _mutableDic[_mutableArray[indexPath.section]];
    }
    else if (indexPath.section == 1){
        cell.zhuBoDetailInfo = _mutableDic[_mutableArray[_mutableArray.count -1]];
    }
    else{
        cell.detailInfo = _mutableDic[_mutableArray[indexPath.section - 1]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 220;
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
