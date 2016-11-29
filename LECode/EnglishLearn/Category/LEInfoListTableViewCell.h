//
//  LEInfoListTableViewCell.h
//  LearnEnglish
//
//  Created by Ma SongTao on 6/27/15.
//  Copyright (c) 2015 Sely. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEInfoListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *flagLabel;
@property (weak, nonatomic) IBOutlet UIImageView *infoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

-(void)configCellWithImage:(UIImage *)image flagTitle:(NSString *)flag title:(NSString *)title text:(NSString *)text;

+(NSString *)identifier;
+(CGFloat)heightOfCell;

@end
