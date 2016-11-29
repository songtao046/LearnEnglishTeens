//
//  LEInfoListTableViewController.h
//  LearnEnglish
//
//  Created by Ma SongTao on 6/19/15.
//  Copyright (c) 2015 Sely. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryData.h"

@interface LEInfoListTableViewController : UITableViewController

@property (nonatomic, assign) CategoryType type;
@property (nonatomic, assign) InfoType infoType;
@property (nonatomic, strong) NSString *serviceName;
@property (nonatomic, strong) NSString *path;

@end
