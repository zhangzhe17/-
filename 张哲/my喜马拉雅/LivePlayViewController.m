//
//  LivePlayViewController.m
//  my喜马拉雅
//
//  Created by lanou3g on 15/11/18.
//  Copyright © 2015年 张哲. All rights reserved.
//

#import "LivePlayViewController.h"
#import "UrlAndTag.h"
#import "zhibotuijian1TableViewCell.h"
#import "TableViewCell.h"
#import "AFNetworking.h"
#import "faxianzhiboModel.h"

@interface LivePlayViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tabelView;
@property (nonatomic,strong) NSMutableArray * mutableArray;
@property (nonatomic,strong) NSMutableArray * mutableArray2;

@end

@implementation LivePlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kViewWidth, kViewHeight - 64 - 49) style:(UITableViewStyleGrouped)];
    
    _tabelView.dataSource = self;
    _tabelView.delegate = self;
    
    [_tabelView registerNib:[UINib nibWithNibName:@"zhibotuijian1TableViewCell" bundle:nil] forCellReuseIdentifier:@"cellzhibotuijian1"];
    [_tabelView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"cellReuse"];
    
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(1, 1, 1, 1)];
    _tabelView.tableHeaderView = view1;
    
    [self.view addSubview:_tabelView];
    [self loadHomePageRadiosList];
}

- (void)loadHomePageRadiosList{
    NSURL *url = [NSURL URLWithString:kFaxianZhiboUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL: url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *html = operation.responseString;
        NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSMutableDictionary * dic = dataDic[@"result"];
        NSArray *array1 = dic[@"recommandRadioList"];
        NSArray *array2 = dic[@"topRadioList"];
        
        self.mutableArray = [NSMutableArray array];
        self.mutableArray2= [NSMutableArray array];
        for (NSDictionary * dic in array1) {
            faxianzhiboModel * zhibo = [faxianzhiboModel new];
            [zhibo setValuesForKeysWithDictionary:dic];
            NSLog(@"%@",zhibo);
            [_mutableArray addObject:zhibo];
        }
        for (NSDictionary * dic in array2) {
            faxianzhiboModel * zhibo = [faxianzhiboModel new];
            [zhibo setValuesForKeysWithDictionary:dic];
            NSLog(@"%@",zhibo);
            [_mutableArray2 addObject:zhibo];
        }
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
    return 3;
}

// 必须实现 设置每个分区有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//必须实现  每一行显示的信息 cell

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    注册后 重用cell
    if (indexPath.section == 0) {
        zhibotuijian1TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellzhibotuijian1"];
        return cell;
    }
    else
    {
        TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellReuse"];
        if (indexPath.section == 1) {
            cell.fxzhibotuijianArray = _mutableArray;
        }
        else if(indexPath.section == 2){
            cell.fxpaihangbangArray = _mutableArray2;
        }
        return  cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 100;
    }
    else{
        return 160;
    }
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
