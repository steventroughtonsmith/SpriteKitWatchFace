//
//  WatchOptionsTableViewController.h
//  SpriteKitWatchFace
//
//  Created by Joseph Shenton on 15/10/18.
//  Copyright © 2018 Steven Troughton-Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WatchOptionsTableViewController : UITableViewController {
    NSIndexPath* watchFacePath;
    NSIndexPath* tickMarksPath;
    NSIndexPath* colorRegionPath;
    NSIndexPath* numberStylePath;
    NSIndexPath* numberTextPath;
}

@property (nonatomic, retain) NSIndexPath* watchFacePath;
@property (nonatomic, retain) NSIndexPath* tickMarksPath;
@property (nonatomic, retain) NSIndexPath* colorRegionPath;
@property (nonatomic, retain) NSIndexPath* numberStylePath;
@property (nonatomic, retain) NSIndexPath* numberTextPath;

@end

NS_ASSUME_NONNULL_END
