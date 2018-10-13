//
//  ViewController.m
//  DesktopShim
//
//  Created by Steven Troughton-Smith on 10/10/2018.
//  Copyright © 2018 Steven Troughton-Smith. All rights reserved.
//

#import "ViewController.h"
#import "FaceScene.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[[NSUserDefaults standardUserDefaults] registerDefaults:@{@"Theme":@(ThemeMarques)}];

    FaceScene *scene = [FaceScene nodeWithFileNamed:@"FaceScene"];
	
	scene.camera.xScale = 0.5;
	scene.camera.yScale = 0.5;

    [self.skView presentScene:scene];
}

@end
