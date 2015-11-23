//
//  AlbumldViewController.h
//  my喜马拉雅
//
//  Created by lanou3g on 15/11/19.
//  Copyright © 2015年 张哲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumldViewController : UITableViewController

{
    int a;
}


@property (strong, nonatomic) NSMutableDictionary *paramDictionary;

@property (strong, nonatomic) IBOutlet UIImageView *largeBgImgView;

@property (strong, nonatomic) IBOutlet UIImageView *middleImgView;


@property (strong, nonatomic) IBOutlet UIImageView *smallImgView;

@property (strong, nonatomic) IBOutlet UILabel *nameLab;

@property (strong, nonatomic) IBOutlet UILabel *desLab;

@property (strong, nonatomic) IBOutlet UILabel *tagLab;


@end
