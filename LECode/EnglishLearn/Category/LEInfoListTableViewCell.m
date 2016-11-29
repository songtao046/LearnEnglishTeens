//
//  LEInfoListTableViewCell.m
//  LearnEnglish
//
//  Created by Ma SongTao on 6/27/15.
//  Copyright (c) 2015 Sely. All rights reserved.
//

#import "LEInfoListTableViewCell.h"

@implementation LEInfoListTableViewCell

- (void)awakeFromNib {

}

-(void)configCellWithImage:(UIImage *)image flagTitle:(NSString *)flag title:(NSString *)title text:(NSString *)text
{
    self.flagLabel.text = flag;
    self.infoImageView.image = image;
    self.contentTextView.text = text;
    self.titleLabel.text = title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(NSString *)identifier
{
    return @"LEInfoListTableViewCell";
}

+(CGFloat)heightOfCell
{
    return 100.f;
}

@end
