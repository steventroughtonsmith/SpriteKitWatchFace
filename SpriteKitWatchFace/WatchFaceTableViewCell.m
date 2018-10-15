//
//  WatchFaceTableViewCell.m
//  SpriteKitWatchFace
//
//  Created by Joseph Shenton on 15/10/18.
//  Copyright © 2018 Steven Troughton-Smith. All rights reserved.
//

#import "WatchFaceTableViewCell.h"

@implementation WatchFaceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(20,10,66,78);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
