//
//  ThemesTableViewController.m
//  SpriteKitWatchFace
//
//  Created by Joseph Shenton on 15/10/18.
//  Copyright © 2018 Steven Troughton-Smith. All rights reserved.
//

#import "ThemesTableViewController.h"

@interface ThemesTableViewController () <WCSessionDelegate>

@end

@implementation ThemesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 24;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    NSString *counterString = [NSString stringWithFormat:@"%@", [cell.textLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
    NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:@[counterString] forKeys:@[@"themeChange"]];
    
    [[WCSession defaultSession] sendMessage:applicationData
                               replyHandler:^(NSDictionary *reply) {
                                   //handle reply from iPhone app here
                               }
                               errorHandler:^(NSError *error) {
                                   //catch any errors here
                               }
     ];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
