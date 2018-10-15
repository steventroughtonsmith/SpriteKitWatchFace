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
	
	CGSize currentDeviceSize = [UIScreen mainScreen].bounds.size;
	
	CGFloat vertWidth = MIN(512, MIN(currentDeviceSize.width, currentDeviceSize.height));
	
	/* Using the 44mm Apple Watch as the base size, scale down to fit */
	scene.camera.xScale = (184.0/vertWidth);
	scene.camera.yScale = (184.0/vertWidth);
	
	[(SKView *)self.view presentScene:scene];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleLightContent;
}

@end
