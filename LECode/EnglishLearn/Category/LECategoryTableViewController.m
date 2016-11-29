//
//  LECategoryTableViewController.m
//  LearnEnglish
//
//  Created by Ma SongTao on 6/16/15.
//  Copyright (c) 2015 Sely. All rights reserved.
//

#import "LECategoryTableViewController.h"
#import "LEListTableViewController.h"
#import "CategoryData.h"

@interface LECategoryTableViewController ()<UIScrollViewDelegate>

@end

@implementation LECategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    LEListTableViewController *list = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([LEListTableViewController class])];
    list.title = cell.textLabel.text;
    list.type = (CategoryType)indexPath.row;
    list.titleArray = [CategoryData titlesWithType:list.type];
//    list.imageArray = [CategoryData imagesWithType:indexPath.row];
    [self.navigationController pushViewController:list animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
