//
//  WatchOptionsTableViewController.m
//  SpriteKitWatchFace
//
//  Created by Joseph Shenton on 15/10/18.
//  Copyright © 2018 Steven Troughton-Smith. All rights reserved.
//

#import "WatchOptionsTableViewController.h"

@interface WatchOptionsTableViewController () <WCSessionDelegate>

@end

@implementation WatchOptionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([WCSession isSupported]) {
        session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
    
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    if ([WCSession isSupported]) {
//        session.delegate = self;
//        [session deactivate];
//    }
//}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([indexPath section] == 0) {
        if(self.watchFacePath && ![self.watchFacePath isEqual:indexPath]) {
            UITableViewCell* uncheckCell = [tableView cellForRowAtIndexPath:self.watchFacePath];
            uncheckCell.accessoryType = UITableViewCellAccessoryNone;
        }
        if([self.watchFacePath isEqual:indexPath]) {
            self.watchFacePath = indexPath;
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            NSString *counterString = [NSString stringWithFormat:@"%@", cell.textLabel.text];
            NSLog(@"%@", counterString);
            NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:@[counterString] forKeys:@[@"faceChange"]];
            
            [[WCSession defaultSession] sendMessage:applicationData
               replyHandler:^(NSDictionary *reply) {
                   //handle reply from iPhone app here
               }
               errorHandler:^(NSError *error) {
                   //catch any errors here
               }
             ];
        }
        else {
            UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.watchFacePath = indexPath;
            NSString *counterString = [NSString stringWithFormat:@"%@", cell.textLabel.text];
            NSLog(@"%@", counterString);
            NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:@[counterString] forKeys:@[@"faceChange"]];
            
            [[WCSession defaultSession] sendMessage:applicationData
                                       replyHandler:^(NSDictionary *reply) {
                                           //handle reply from iPhone app here
                                       }
                                       errorHandler:^(NSError *error) {
                                           //catch any errors here
                                       }
             ];
        }
    } else if ([indexPath section] == 1) {
        if(self.complicationsPath && ![self.complicationsPath isEqual:indexPath]) {
            UITableViewCell* uncheckCell = [tableView cellForRowAtIndexPath:self.complicationsPath];
            uncheckCell.accessoryType = UITableViewCellAccessoryNone;
        }
        if([self.complicationsPath isEqual:indexPath]) {
            self.complicationsPath = indexPath;
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            NSString *counterString = [NSString stringWithFormat:@"%@", cell.textLabel.text];
            NSLog(@"%@", counterString);
            NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:@[counterString] forKeys:@[@"complicationChange"]];
            
            [[WCSession defaultSession] sendMessage:applicationData
                                       replyHandler:^(NSDictionary *reply) {
                                           //handle reply from iPhone app here
                                       }
                                       errorHandler:^(NSError *error) {
                                           //catch any errors here
                                       }
             ];
        }
        else {
            UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.complicationsPath = indexPath;
            NSString *counterString = [NSString stringWithFormat:@"%@", cell.textLabel.text];
            NSLog(@"%@", counterString);
            NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:@[counterString] forKeys:@[@"complicationChange"]];
            
            [[WCSession defaultSession] sendMessage:applicationData
                                       replyHandler:^(NSDictionary *reply) {
                                           //handle reply from iPhone app here
                                       }
                                       errorHandler:^(NSError *error) {
                                           //catch any errors here
                                       }
             ];
        }
    } else if ([indexPath section] == 2) {
        if(self.tickMarksPath && ![self.tickMarksPath isEqual:indexPath]) {
            UITableViewCell* uncheckCell = [tableView cellForRowAtIndexPath:self.tickMarksPath];
            uncheckCell.accessoryType = UITableViewCellAccessoryNone;
        }
        if([self.tickMarksPath isEqual:indexPath]) {
            self.tickMarksPath = indexPath;
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            NSString *counterString = [NSString stringWithFormat:@"%@", cell.textLabel.text];
            NSLog(@"%@", counterString);
            NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:@[counterString] forKeys:@[@"tickmarkChange"]];
            
            [[WCSession defaultSession] sendMessage:applicationData
                                       replyHandler:^(NSDictionary *reply) {
                                           //handle reply from iPhone app here
                                       }
                                       errorHandler:^(NSError *error) {
                                           //catch any errors here
                                       }
             ];
        }
        else {
            UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.tickMarksPath = indexPath;
            NSString *counterString = [NSString stringWithFormat:@"%@", cell.textLabel.text];
            NSLog(@"%@", counterString);
            NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:@[counterString] forKeys:@[@"tickmarkChange"]];
            
            [[WCSession defaultSession] sendMessage:applicationData
                                       replyHandler:^(NSDictionary *reply) {
                                           //handle reply from iPhone app here
                                       }
                                       errorHandler:^(NSError *error) {
                                           //catch any errors here
                                       }
             ];
        }
    } else if ([indexPath section] == 3) {
        if(self.colorRegionPath && ![self.colorRegionPath isEqual:indexPath]) {
            UITableViewCell* uncheckCell = [tableView cellForRowAtIndexPath:self.colorRegionPath];
            uncheckCell.accessoryType = UITableViewCellAccessoryNone;
        }
        if([self.colorRegionPath isEqual:indexPath]) {
            self.colorRegionPath = indexPath;
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            NSString *counterString = [NSString stringWithFormat:@"%@", cell.textLabel.text];
            NSLog(@"%@", counterString);
            NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:@[counterString] forKeys:@[@"colorRegionChange"]];
            
            [[WCSession defaultSession] sendMessage:applicationData
                                       replyHandler:^(NSDictionary *reply) {
                                           //handle reply from iPhone app here
                                       }
                                       errorHandler:^(NSError *error) {
                                           //catch any errors here
                                       }
             ];
        }
        else {
            UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.colorRegionPath = indexPath;
            NSString *counterString = [NSString stringWithFormat:@"%@", cell.textLabel.text];
            NSLog(@"%@", counterString);
            NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:@[counterString] forKeys:@[@"colorRegionChange"]];
            
            [[WCSession defaultSession] sendMessage:applicationData
                                       replyHandler:^(NSDictionary *reply) {
                                           //handle reply from iPhone app here
                                       }
                                       errorHandler:^(NSError *error) {
                                           //catch any errors here
                                       }
             ];
        }
    } else if ([indexPath section] == 4) {
        if(self.numberStylePath && ![self.numberStylePath isEqual:indexPath]) {
            UITableViewCell* uncheckCell = [tableView cellForRowAtIndexPath:self.numberStylePath];
            uncheckCell.accessoryType = UITableViewCellAccessoryNone;
        }
        if([self.numberStylePath isEqual:indexPath]) {
            self.numberStylePath = indexPath;
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            NSString *counterString = [NSString stringWithFormat:@"%@", cell.textLabel.text];
            NSLog(@"%@", counterString);
            NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:@[counterString] forKeys:@[@"numberStyleChange"]];
            
            [[WCSession defaultSession] sendMessage:applicationData
                                       replyHandler:^(NSDictionary *reply) {
                                           //handle reply from iPhone app here
                                       }
                                       errorHandler:^(NSError *error) {
                                           //catch any errors here
                                       }
             ];
        }
        else {
            UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.numberStylePath = indexPath;
            NSString *counterString = [NSString stringWithFormat:@"%@", cell.textLabel.text];
            NSLog(@"%@", counterString);
            NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:@[counterString] forKeys:@[@"numberStyleChange"]];
            
            [[WCSession defaultSession] sendMessage:applicationData
                                       replyHandler:^(NSDictionary *reply) {
                                           //handle reply from iPhone app here
                                       }
                                       errorHandler:^(NSError *error) {
                                           //catch any errors here
                                       }
             ];
        }
    } else if ([indexPath section] == 5) {
        if(self.numberTextPath && ![self.numberTextPath isEqual:indexPath]) {
            UITableViewCell* uncheckCell = [tableView cellForRowAtIndexPath:self.numberTextPath];
            uncheckCell.accessoryType = UITableViewCellAccessoryNone;
        }
        if([self.numberTextPath isEqual:indexPath]) {
            self.numberTextPath = indexPath;
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            NSString *counterString = [NSString stringWithFormat:@"%@", cell.textLabel.text];
            NSLog(@"%@", counterString);
            NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:@[counterString] forKeys:@[@"numberTextChange"]];
            
            [[WCSession defaultSession] sendMessage:applicationData
                                       replyHandler:^(NSDictionary *reply) {
                                           //handle reply from iPhone app here
                                       }
                                       errorHandler:^(NSError *error) {
                                           //catch any errors here
                                       }
             ];
        }
        else {
            UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.numberTextPath = indexPath;
            NSString *counterString = [NSString stringWithFormat:@"%@", cell.textLabel.text];
            NSLog(@"%@", counterString);
            NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:@[counterString] forKeys:@[@"numberTextChange"]];
            
            [[WCSession defaultSession] sendMessage:applicationData
                                       replyHandler:^(NSDictionary *reply) {
                                           //handle reply from iPhone app here
                                       }
                                       errorHandler:^(NSError *error) {
                                           //catch any errors here
                                       }
             ];
        }
    } else {
        
    }
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
