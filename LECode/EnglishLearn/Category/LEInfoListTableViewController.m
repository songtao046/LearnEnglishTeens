//
//  LEInfoListTableViewController.m
//  LearnEnglish
//
//  Created by Ma SongTao on 6/19/15.
//  Copyright (c) 2015 Sely. All rights reserved.
//




#import "LEInfoListTableViewController.h"
#import "LENetManager.h"
#import "TFHpple.h"
#import "InfoListParser.h"
#import "InfoListService.h"
#import "SVPullToRefresh.h"
#import "LEInfoListTableViewCell.h"
#import "LEImageLoad.h" 
#import "LEInfoDetailTableViewController.h"

@interface LEInfoListTableViewController ()

@property (nonatomic, strong) NSMutableDictionary *resultDictionary;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, assign) BOOL hasNoMorePage;

@property (nonatomic, assign) BOOL isPending;

@end

@implementation LEInfoListTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _resultDictionary = [NSMutableDictionary dictionary];
    [self loadDataFromServer];
    
    CGFloat top = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
    
    
    
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    __weak LEInfoListTableViewController *weakSelf = self;
    
    _pageIndex = 0;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        
        if (weakSelf.isPending)
        {
            return;
        }
        if (weakSelf.hasNoMorePage)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
            label.font = [UIFont systemFontOfSize:11];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor darkGrayColor];
            label.text = @"No More Data";
            [weakSelf.tableView.infiniteScrollingView setCustomView:label forState:SVInfiniteScrollingStateStopped];
            return;
        }
        weakSelf.pageIndex ++;
        [weakSelf loadDataFromServer];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
        

    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)dealloc
{
    self.refreshControl = nil;
}

-(void)handleRefresh:(id)sender
{
    [self loadDataFromServer];
}

-(void)loadDataFromServer
{
    __weak LEInfoListTableViewController *weakself = self;
    __block NSInteger pageIndex = self.pageIndex;
    weakself.isPending = YES;
    [InfoListService getInfoListWithService:self.serviceName path:self.path pageIndex:self.pageIndex completionHandler:^(id responseObject, NSInteger errorCode, NSError *error){
        weakself.isPending = NO;
        if (errorCode == SE_SUCCESS)
        {
            NSString *htmlString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            InfoListParser *parser = [InfoListParser parserWithType:weakself.type infoType:self.infoType string:htmlString completionHandler:^(NSArray *resultArray, BOOL success, NSString *errorMessage) {
                    NSLog(@"result array : %@", resultArray);
                
                [weakself.resultDictionary setObject:resultArray forKey:@(pageIndex)];
                [weakself reloadData];
                if (resultArray && [[resultArray objectAtIndex:0] count] < LIST_PAGE_SIZE)
                {
                    weakself.hasNoMorePage = YES;
                    return;
                }

                if (self.refreshControl)
                {
                    [self.refreshControl endRefreshing];
                }
            }];
            [parser parse];
        }
        else
        {
            if (weakself.pageIndex != 0)
            {
                weakself.pageIndex -- ;
            }

        }
    }];
}

-(void)reloadData
{
    [self loadDataFromLocal];
    [self.tableView reloadData];
}

-(void)loadDataFromLocal
{
    
}


#pragma mark - Table view data source
-(NSInteger)numberOfInfos
{
    int number = 0;
    for (id key in self.resultDictionary.allKeys)
    {
        id results = [self.resultDictionary objectForKey:key];
        if (results && [results isKindOfClass:[NSArray class]])
        {
            NSArray *subresults = [results objectAtIndex:0];
            number += subresults.count;
        }
    }
    return number;
}

-(NSArray *)resultsAtRow:(NSInteger)row
{
    NSInteger pageIndex = row/LIST_PAGE_SIZE;
    NSArray *resultArray = [self.resultDictionary objectForKey:@(pageIndex)];
    if (resultArray && resultArray.count > 0)
    {
        return [resultArray objectAtIndex:0];
    }
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [LEInfoListTableViewCell heightOfCell];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self numberOfInfos];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LEInfoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LEInfoListTableViewCell identifier] forIndexPath:indexPath];
    
    NSArray *currentResults = [self resultsAtRow:indexPath.row];
    if (currentResults.count > 0)
    {
        NSInteger infoPosition = indexPath.row%LIST_PAGE_SIZE;
        if (currentResults.count <= infoPosition)
        {

        }
        ParserInfo *info = [currentResults objectAtIndex:infoPosition];
        cell.flagLabel.text = info.flagString;
        cell.titleLabel.text = info.title;
        cell.contentTextView.text = info.content;
        
        
        [LEImageLoad imageView:cell.infoImageView setImageWithURL:[NSURL URLWithString:info.image] placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
                     }];
    }

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *currentResults = [self resultsAtRow:indexPath.row];
    if (currentResults.count > 0)
    {
        NSInteger infoPosition = indexPath.row%LIST_PAGE_SIZE;
        assert(currentResults.count > infoPosition);
        ParserInfo *info = [currentResults objectAtIndex:infoPosition];
        LEInfoDetailTableViewController *infoDetail = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([LEInfoDetailTableViewController class])];
        infoDetail.infoPath = info.urlString;
        [self.navigationController pushViewController:infoDetail animated:YES];
    }

}

@end
