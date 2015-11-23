//
//  RecommendCell.h
//  my喜马拉雅
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 张哲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYImageView.h"

@interface RecommendCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet CYImageView *FirstImgView;

@property (strong, nonatomic) IBOutlet CYImageView *SecondImgView;
@property (strong, nonatomic) IBOutlet CYImageView *ThirdImgView;

@property (strong, nonatomic) IBOutlet UILabel *FirstLabel;
@property (strong, nonatomic) IBOutlet UILabel *SecondLabel;

@property (strong, nonatomic) IBOutlet UILabel *ThirdLabel;
@property (strong, nonatomic) IBOutlet UILabel *First2Lab;

@property (strong, nonatomic) IBOutlet UILabel *Second2Lab;

@property (strong, nonatomic) IBOutlet UILabel *Third2Lab;

@property (strong, nonatomic) NSMutableArray * recommends;
-(void)setArray:(NSMutableArray *)recommends;
@end
