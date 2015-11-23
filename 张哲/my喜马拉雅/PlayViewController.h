//
//  PlayViewController.h
//  my喜马拉雅
//
//  Created by lanou3g on 15/11/18.
//  Copyright © 2015年 张哲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumldList.h"

@interface PlayViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *bgImgView;

@property (strong, nonatomic) IBOutlet UIImageView *upperImgView;
@property (strong, nonatomic) IBOutlet UIImageView *headImgView;
@property (strong, nonatomic) IBOutlet UILabel *themeLabel;

@property (strong, nonatomic) IBOutlet UILabel *desLabel;

// 传过来的播放数组
@property (strong, nonatomic) NSArray *albumldList;
//
@property (assign, nonatomic) NSInteger choiceNum;


// 单例
+(instancetype)sharedPlayVC;
@end
