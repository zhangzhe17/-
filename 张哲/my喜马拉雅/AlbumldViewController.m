//
//  AlbumldViewController.m
//  my喜马拉雅
//
//  Created by lanou3g on 15/11/19.
//  Copyright © 2015年 张哲. All rights reserved.
//

#import "AlbumldViewController.h"
#import "AFHTTPRequestOperation.h"
#import "Albumld.h"
#import "UIImageView+WebCache.h"
#import "AlbumldList.h"
#import "AlbumldListCell.h"
#import "PlayViewController.h"
#import "MJRefresh.h"

@interface AlbumldViewController ()

@property(nonatomic,strong)Albumld *albumld;
// 播放列表
@property(nonatomic,strong)NSMutableArray *listArray;
@end

@implementation AlbumldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"AlbumldListCell" bundle:nil] forCellReuseIdentifier:@"albumld"];
    [self parseData];
    // 2.集成刷新控件
    [self setupRefresh];
    a=1;
}


- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
#warning 自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
}


#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    
    [self parseData];
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
//    NSNumber *i = _paramDictionary[@"albumId"];
//    NSInteger albumId = i.integerValue;
//    
//    NSNumber *j = _paramDictionary[@"position"];
//    NSInteger position = j.integerValue;
//    NSString *urlStr = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/others/ca/album/track/%ld/true/%d/20?device=iPhone&position=%ld&title=%@", albumId, a, position,_paramDictionary[@"title"]];
    a+=1;
    
    [self parseData];
    
    // 2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 刷新表格
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView footerEndRefreshing];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.listArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlbumldListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"albumld" forIndexPath:indexPath];
    AlbumldList *list =_listArray[indexPath.row];
    cell.titleLab.text = list.title;
    
    
    return cell;
}
// 解析数据
-(void)parseData{
    NSNumber *i = _paramDictionary[@"albumId"];
    NSInteger albumId = i.integerValue;
    
    NSNumber *j = _paramDictionary[@"position"];
    NSInteger position = j.integerValue;
     //网址
    //  NSDictionary* dic1 = @{@"albumId":[NSNumber numberWithInteger:special1.albumId],@"position":@"1",@"title":special1.title};
    NSString *urlStr = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/others/ca/album/track/%ld/true/%d/20?device=iPhone&position=%ld&title=%@", albumId, a,position,_paramDictionary[@"title"]];
    
    
    
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation1 = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation1 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *html = operation.responseString;
        NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];;
        
        NSDictionary * dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        // 专辑描述
        NSDictionary *dictionary = dataDict[@"album"];
        self.albumld = [Albumld new];
        [_albumld setValuesForKeysWithDictionary:dictionary];
        // 专辑内容
        NSDictionary *trackDic = dataDict[@"tracks"];
        NSArray *list = trackDic[@"list"];
        for (NSDictionary *dictionary in list) {
            AlbumldList *list = [AlbumldList new];
            [list setValuesForKeysWithDictionary:dictionary];
            [self.listArray addObject:list];
        }
        
        
        // 刷新数据
        [self updateHeaderView];
        [self.tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"获取数据错误 ---%@",error);
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation1];
}
-(void)updateHeaderView{
    
    [_middleImgView sd_setImageWithURL:[NSURL URLWithString:_albumld.coverMiddle]];
    [_smallImgView sd_setImageWithURL:[NSURL URLWithString:_albumld.avatarPath]];
    _nameLab.text = _albumld.nickname;
    _desLab.text = _albumld.intro;
    _tagLab.text = _albumld.tags;
    
}
// 懒加载
-(NSMutableArray *)listArray{
    if (_listArray == nil) {
        _listArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _listArray;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PlayViewController *playVC = [PlayViewController sharedPlayVC];
    
    playVC.albumldList = _listArray;
    playVC.choiceNum = indexPath.row;
    [self showDetailViewController:playVC sender:nil];
    
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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
