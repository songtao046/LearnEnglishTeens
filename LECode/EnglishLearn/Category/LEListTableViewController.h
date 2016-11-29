//
//  LEListTableViewController.h
//  LearnEnglish
//
//  Created by Ma SongTao on 6/16/15.
//  Copyright (c) 2015 Sely. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEListTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, assign) CategoryType type;

@end
