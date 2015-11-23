//
//  SpeciaTableViewCell.h
//  my喜马拉雅
//
//  Created by lanou3g on 15/11/18.
//  Copyright © 2015年 张哲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYImageView.h"

@interface SpeciaTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet CYImageView *FirstImgVIew;

@property (strong, nonatomic) IBOutlet UILabel *FirstTitleLab;

@property (strong, nonatomic) IBOutlet UILabel *FirstDesLab;

@property (strong, nonatomic) IBOutlet UILabel *FirstVoiceLab;

@property (strong, nonatomic) IBOutlet CYImageView *SecongImgView;
@property (strong, nonatomic) IBOutlet UILabel *SecondTitleLab;
@property (strong, nonatomic) IBOutlet UILabel *SecondDesLab;
@property (strong, nonatomic) IBOutlet UILabel *SecondVoiceLab;

-(void)setArray:(NSMutableArray *)recommends;
@end
