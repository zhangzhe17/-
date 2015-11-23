//
//  RecommendCell.m
//  my喜马拉雅
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 张哲. All rights reserved.
//

#import "RecommendCell.h"
#import "UIImageView+WebCache.h"
#import "Recommend.h"

@implementation RecommendCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setArray:(NSMutableArray *)recommends{
    Recommend *r1 = recommends[0];
    Recommend *r2 = recommends[1];
    Recommend *r3 = recommends[2];
        [_FirstImgView sd_setImageWithURL:[NSURL URLWithString:r1.coverLarge] placeholderImage:[UIImage imageNamed:@"1"]];
    _FirstLabel.text = r1.trackTitle;
    _First2Lab.text = r1.title;
    
        [_SecondImgView sd_setImageWithURL:[NSURL URLWithString:r2.coverLarge] placeholderImage:[UIImage imageNamed:@"1"]];
    _SecondLabel.text = r2.trackTitle;
    _Second2Lab.text = r2.title;
    
        [_ThirdImgView sd_setImageWithURL:[NSURL URLWithString:r3.coverLarge] placeholderImage:[UIImage imageNamed:@"1"]];
    _ThirdLabel.text = r3.trackTitle;
    _Third2Lab.text = r3.title;
    

}

-(void)setRecommend:(NSMutableArray *)recommends{
    Recommend *r1 = recommends[1];
    Recommend *r2 = recommends[2];
    Recommend *r3 = recommends[3];
//    [_FirstImgView sd_setImageWithURL:[NSURL URLWithString:r1.coverLarge] placeholderImage:[UIImage imageNamed:@"1"]];
    _FirstLabel.text = r1.trackTitle;
    _First2Lab.text = r1.title;
    
//    [_SecondImgView sd_setImageWithURL:[NSURL URLWithString:r2.coverLarge] placeholderImage:[UIImage imageNamed:@"1"]];
    _SecondLabel.text = r2.trackTitle;
    _Second2Lab.text = r2.title;
    
//    [_ThirdImgView sd_setImageWithURL:[NSURL URLWithString:r3.coverLarge] placeholderImage:[UIImage imageNamed:@"1"]];
    _ThirdLabel.text = r3.trackTitle;
    _Third2Lab.text = r3.title;

}

@end
