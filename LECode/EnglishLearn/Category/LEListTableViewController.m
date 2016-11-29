//
//  LEListTableViewController.m
//  LearnEnglish
//
//  Created by Ma SongTao on 6/16/15.
//  Copyright (c) 2015 Sely. All rights reserved.
//


#define COLOR_PURPLE [UIColor colorWithRed:143./255. green:55./255. blue:120./255. alpha:1]
#define COLOR_WHITE [UIColor colorWithRed:255./255. green:255./255. blue:255./255. alpha:1]
#import "LEListTableViewController.h"
#import "LEInfoListTableViewController.h"
#import "CategoryData.h"

@interface LEListTableViewController ()

@end

@implementation LEListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.textColor = COLOR_PURPLE;
    cell.textLabel.font = [UIFont systemFontOfSize:13.];
    cell.textLabel.text = NSLocalizedString([self.titleArray[indexPath.row] capitalizedString], @"");
//    cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LEInfoListTableViewController *infoList = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([LEInfoListTableViewController class])];
    infoList.serviceName = [CategoryData serviceNameWithType:self.type];
    infoList.path = [CategoryData pathNameWithType:self.type index:indexPath.row];
    infoList.type = self.type;
    infoList.infoType = indexPath.row;
    [self.navigationController pushViewController:infoList animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
