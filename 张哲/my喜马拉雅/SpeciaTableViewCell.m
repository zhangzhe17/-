//
//  SpeciaTableViewCell.m
//  my喜马拉雅
//
//  Created by lanou3g on 15/11/18.
//  Copyright © 2015年 张哲. All rights reserved.
//

#import "SpeciaTableViewCell.h"
#import "Special.h"
#import "UIImageView+WebCache.h"

@implementation SpeciaTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setArray:(NSMutableArray *)recommends{
    Special *r1 = recommends[0];
    Special *r2 = recommends[1];
    [_FirstImgVIew sd_setImageWithURL:[NSURL URLWithString:r1.coverPath ]placeholderImage:[UIImage imageNamed:@"loads"]];
    _FirstTitleLab.text = r1.title;
    _FirstDesLab.text = r1.subtitle;
    _FirstVoiceLab.text = r1.footnote;
    
    [_SecongImgView sd_setImageWithURL:[NSURL URLWithString:r2.coverPath ]placeholderImage:[UIImage imageNamed:@"loads"]];
    _SecondTitleLab.text = r2.title;
    _SecondDesLab.text = r2.subtitle;
    _SecondVoiceLab.text = r2.footnote;
    
}
@end
