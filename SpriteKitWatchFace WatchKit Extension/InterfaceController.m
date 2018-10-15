//
//  InterfaceController.m
//  SpriteKitWatchFace WatchKit Extension
//
//  Created by Steven Troughton-Smith on 09/10/2018.
//  Copyright © 2018 Steven Troughton-Smith. All rights reserved.
//

#import "InterfaceController.h"
#import "FaceScene.h"

@import ObjectiveC.runtime;
@import SpriteKit;

@interface NSObject (fs_override)
+(id)sharedApplication;
-(id)keyWindow;
-(id)rootViewController;
-(NSArray *)viewControllers;
-(id)view;
-(NSArray *)subviews;
-(id)timeLabel;
-(id)layer;
@end

@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
	
	[[NSUserDefaults standardUserDefaults] registerDefaults:@{@"Theme":@(ThemeMarques)}];

	FaceScene *scene = [FaceScene nodeWithFileNamed:@"FaceScene"];
	
	CGSize currentDeviceSize = [WKInterfaceDevice currentDevice].screenBounds.size;
	
	/* Using the 44mm Apple Watch as the base size, scale down to fit */
	scene.camera.xScale = (184.0/currentDeviceSize.width);
	scene.camera.yScale = (184.0/currentDeviceSize.width);
	
	[self.scene presentScene:scene];
}

- (void)didAppear
{
	/* Hack to make the digital time overlay disappear */
	
	NSArray *views = [[[[[[[NSClassFromString(@"UIApplication") sharedApplication] keyWindow] rootViewController] viewControllers] firstObject] view] subviews];
	
	for (NSObject *view in views)
	{
		if ([view isKindOfClass:NSClassFromString(@"SPFullScreenView")])
			[[[view timeLabel] layer] setOpacity:0];
	}
	
	self.crownSequencer.delegate = self;
	[self.crownSequencer focus];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

#pragma mark -

CGFloat totalRotation = 0;

- (void)crownDidRotate:(nullable WKCrownSequencer *)crownSequencer rotationalDelta:(double)rotationalDelta
{
	int direction = 1;
	totalRotation += fabs(rotationalDelta);
	
	if (rotationalDelta < 0)
		direction = -1;
	
	if (totalRotation > (M_PI_4/2))
	{
		FaceScene *scene = (FaceScene *)self.scene.scene;
		
		if ((scene.theme+direction > 0) && (scene.theme+direction < ThemeMAX))
			scene.theme += direction;
		else
			scene.theme = 0;
		
		[scene refreshTheme];
        
		totalRotation = 0;
	}
}

- (void)session:(nonnull WCSession *)session didReceiveMessage:(nonnull NSDictionary<NSString *,id> *)message replyHandler:(nonnull void (^)(NSDictionary<NSString *,id> * __nonnull))replyHandler {
    if ([message objectForKey:@"themeChange"]) {
        NSArray *themes = @[@"ThemeHermesPink", @"ThemeHermesOrange", @"ThemeNavy", @"ThemeTidepod", @"ThemeBretonnia", @"ThemeNoir", @"ThemeContrast", @"ThemeVictoire", @"ThemeLiquid", @"ThemeAngler", @"ThemeSculley", @"ThemeKitty", @"ThemeDelay", @"ThemeDiesel", @"ThemeLuxe", @"ThemeSage", @"ThemeBondi", @"ThemeTangerine", @"ThemeStrawberry", @"ThemePawn", @"ThemeRoyal", @"ThemeMarques", @"ThemeVox", @"ThemeSummer", @"ThemeMAX"];
        int key = [themes indexOfObject:[NSString stringWithFormat:@"Theme%@", [message objectForKey:@"themeChange"]]];
        
        FaceScene *scene = (FaceScene *)self.scene.scene;
        
        scene.theme = key;
        
        
        [scene refreshTheme];
    } else if ([message objectForKey:@"faceChange"]) {
        NSArray *faceStyles = @[@"FaceStyleRound", @"FaceStyleRectangular", @"FaceStyleMAX"];
        int key = [faceStyles indexOfObject:[NSString stringWithFormat:@"FaceStyle%@", [[message objectForKey:@"faceChange"] stringByReplacingOccurrencesOfString:@" Face" withString:@""]]];
        FaceScene *scene = (FaceScene *)self.scene.scene;
        
        scene.faceStyle = key;
        
        
        [scene refreshTheme];
    }  else if ([message objectForKey:@"tickmarkChange"]) {
        NSArray *faceStyles = @[@"TickmarkStyleAll", @"TickmarkStyleMajor", @"TickmarkStyleMinor", @"TickmarkStyleNone", @"TickmarkStyleMAX"];
        int key = [faceStyles indexOfObject:[NSString stringWithFormat:@"TickmarkStyle%@", [message objectForKey:@"tickmarkChange"]]];
        FaceScene *scene = (FaceScene *)self.scene.scene;
        
        scene.tickmarkStyle = key;
        
        
        [scene refreshTheme];
    }  else if ([message objectForKey:@"colorRegionChange"]) {
        NSArray *faceStyles = @[@"ColorRegionStyleNone", @"ColorRegionStyleDynamicDuo", @"ColorRegionStyleHalf", @"ColorRegionStyleCircle", @"ColorRegionStyleRing", @"ColorRegionStyleMAX"];
        int key = [faceStyles indexOfObject:[NSString stringWithFormat:@"ColorRegionStyle%@", [[message objectForKey:@"colorRegionChange"] stringByReplacingOccurrencesOfString:@" " withString:@""]]];
        FaceScene *scene = (FaceScene *)self.scene.scene;
        
        scene.colorRegionStyle = key;
        
        
        [scene refreshTheme];
    } else if ([message objectForKey:@"numberStyleChange"]) {
        NSArray *faceStyles = @[@"NumeralStyleAll", @"NumeralStyleCardinal", @"NumeralStyleNone", @"NumeralStyleMAX"];
        int key = [faceStyles indexOfObject:[NSString stringWithFormat:@"NumeralStyle%@", [[message objectForKey:@"numberStyleChange"] stringByReplacingOccurrencesOfString:@" " withString:@""]]];
        FaceScene *scene = (FaceScene *)self.scene.scene;
        
        scene.numeralStyle = key;
        
        
        [scene refreshTheme];
    }  else if ([message objectForKey:@"numberTextChange"]) {
        NSString *numberTextType = [NSString stringWithFormat:@"%@", [[[message objectForKey:@"numberTextChange"] stringByReplacingOccurrencesOfString:@" (I, II, III)" withString:@""] stringByReplacingOccurrencesOfString:@" (1, 2, 3)" withString:@""]];
        FaceScene *scene = (FaceScene *)self.scene.scene;
        
        if ([numberTextType  isEqual: @"Roman Numerals"]) {
            scene.romanNumerals = YES;
        } else {
            scene.romanNumerals = NO;
        }
        
        
        [scene refreshTheme];
    }  else if ([message objectForKey:@"complicationChange"]) {
        NSString *complicationType = [NSString stringWithFormat:@"%@", [message objectForKey:@"complicationChange"]];
        FaceScene *scene = (FaceScene *)self.scene.scene;
        
        if ([complicationType isEqual: @"All"]) {
            scene.showWeather = YES;
            scene.showDate = YES;
            scene.showBattery = YES;
        } else if ([complicationType isEqual:@"Battery"]) {
            scene.showWeather = NO;
            scene.showDate = NO;
            scene.showBattery = YES;
        } else if ([complicationType isEqual:@"Date"]) {
            scene.showWeather = NO;
            scene.showDate = YES;
            scene.showBattery = NO;
        } else if ([complicationType isEqual:@"Weather"]) {
            scene.showWeather = YES;
            scene.showDate = NO;
            scene.showBattery = NO;
        } else if ([complicationType isEqual:@"None"]) {
            scene.showWeather = NO;
            scene.showDate = NO;
            scene.showBattery = NO;
        } else {
            scene.showWeather = NO;
            scene.showDate = NO;
            scene.showBattery = NO;
        }
        
        
        [scene refreshTheme];
    } else {
        
    }
}

@end



