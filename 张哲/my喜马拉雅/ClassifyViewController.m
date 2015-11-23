//
//  ClassifyViewController.m
//  my喜马拉雅
//
//  Created by lanou3g on 15/11/18.
//  Copyright © 2015年 张哲. All rights reserved.
//

#import "ClassifyViewController.h"
#import "fenlei1TableViewCell.h"
#import "fenlie2TableViewCell.h"
#import "UrlAndTag.h"
#import "AFNetworking.h"
#import "faxianfenleiModel.h"

@interface ClassifyViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView * tabelView;
@property (nonatomic,strong) NSMutableArray * arrayFenlei;

@end

@implementation ClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self loadCategory];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kViewWidth, kViewHeight - 64 - 49) style:(UITableViewStyleGrouped)];
    
    _tabelView.dataSource = self;
    _tabelView.delegate = self;
    
    [_tabelView registerNib:[UINib nibWithNibName:@"fenlei1TableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [_tabelView registerNib:[UINib nibWithNibName:@"fenlie2TableViewCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
    
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(1, 1, 1, 1)];
    _tabelView.tableHeaderView = view1;
    
    [self.view addSubview:_tabelView];
    
//    [_tabelView reloadData];
    
}
//-(void)viewWillAppear:(BOOL)animated{
//   
//}
- (void)loadCategory{
    NSURL *url = [NSURL URLWithString:kFaxianFenleiUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL: url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *html = operation.responseString;
        NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray *array = dataDic[@"list"];
        
        self.arrayFenlei = [NSMutableArray array];
        for (NSDictionary * dic in array) {
            faxianfenleiModel * fenlei = [faxianfenleiModel new];
            [fenlei setValuesForKeysWithDictionary:dic];
          
            [_arrayFenlei addObject:fenlei];
            [self.tabelView reloadData];
        }
       
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

////分区footer的视图
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kViewWidth, 10)];
//        view.backgroundColor = [UIColor grayColor];
//    return view;
//}

// 可选择实现 设置分区个数  不写 默认为1
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arrayFenlei.count;
}

// 必须实现 设置每个分区有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//必须实现  每一行显示的信息 cell

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    注册后 重用cell
    if (indexPath.section == 0) {
        fenlei1TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (_arrayFenlei != NULL) {
            NSMutableArray * array = [NSMutableArray array];
            for (int i = 0; i < 5; i ++) {
                [array addObject:_arrayFenlei[i]];
            }
            cell.arrayCatagory = array;
        }
        return cell;
    }
    else
    {
        fenlie2TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (_arrayFenlei != NULL) {
            NSMutableArray * array = [NSMutableArray array];
            if (indexPath.section == 1) {
                for (int i = 5; i < 11; i ++) {
                    [array addObject:_arrayFenlei[i]];
                }
            }
            else if (indexPath.section == 2) {
                for (int i = 11; i < 17; i ++) {
                    [array addObject:_arrayFenlei[i]];
                }
            }
            else if (indexPath.section == 3) {
                for (int i = 17; i < 23; i ++) {
                    [array addObject:_arrayFenlei[i]];
                }
            }
            cell.arrayCategory = array;
        }
        return  cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 200;
    }
    else{
        return 120;
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
