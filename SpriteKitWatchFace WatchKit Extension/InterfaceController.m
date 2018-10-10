//
//  InterfaceController.m
//  SpriteKitWatchFace WatchKit Extension
//
//  Created by Steven Troughton-Smith on 09/10/2018.
//  Copyright © 2018 Steven Troughton-Smith. All rights reserved.
//

#import "InterfaceController.h"

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

	self.scene.scene.delegate = self;
	
	[self setupColors];
}

-(void)setupColors
{
	UIColor *lightColor = [UIColor colorWithRed:0.848 green:0.187 blue:0.349 alpha:1];
	UIColor *darkColor = [UIColor colorWithRed:0.387 green:0.226 blue:0.270 alpha:1];
	UIColor *accentColor = [UIColor colorWithRed:0.831 green:0.540 blue:0.612 alpha:1];
	
	SKNode *face = [self.scene.scene childNodeWithName:@"Face"];
	
	SKSpriteNode *hourHand = (SKSpriteNode *)[face childNodeWithName:@"Hours"];
	SKSpriteNode *minuteHand = (SKSpriteNode *)[face childNodeWithName:@"Minutes"];
	
	SKSpriteNode *hourHandInlay = (SKSpriteNode *)[hourHand childNodeWithName:@"Hours Inlay"];
	SKSpriteNode *minuteHandInlay = (SKSpriteNode *)[minuteHand childNodeWithName:@"Minutes Inlay"];
	
	SKSpriteNode *secondHand = (SKSpriteNode *)[face childNodeWithName:@"Seconds"];
	SKSpriteNode *colorRegion = (SKSpriteNode *)[face childNodeWithName:@"Color Region"];
	SKSpriteNode *numbers = (SKSpriteNode *)[face childNodeWithName:@"Numbers"];
	
	hourHand.color = [UIColor whiteColor];
	hourHand.colorBlendFactor = 1.0;
	
	minuteHand.color = [UIColor whiteColor];
	minuteHand.colorBlendFactor = 1.0;
	
	secondHand.color = accentColor;
	secondHand.colorBlendFactor = 1.0;
	
	self.scene.scene.backgroundColor = darkColor;
	
	colorRegion.color = lightColor;
	colorRegion.colorBlendFactor = 1.0;
	
	numbers.color = accentColor;
	numbers.colorBlendFactor = 1.0;
	
	hourHandInlay.color = lightColor;
	hourHandInlay.colorBlendFactor = 1.0;
	
	minuteHandInlay.color = lightColor;
	minuteHandInlay.colorBlendFactor = 1.0;
}

- (void)update:(NSTimeInterval)currentTime forScene:(SKScene *)scene
{
	[self updateHands];
}

-(void)updateHands
{
	NSDate *now = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond| NSCalendarUnitNanosecond) fromDate:now];
	
	SKNode *face = [self.scene.scene childNodeWithName:@"Face"];
	
	SKNode *hourHand = [face childNodeWithName:@"Hours"];
	SKNode *minuteHand = [face childNodeWithName:@"Minutes"];
	SKNode *secondHand = [face childNodeWithName:@"Seconds"];
	
	SKNode *colorRegion = [face childNodeWithName:@"Color Region"];

	hourHand.zRotation =  - (2*M_PI)/12.0 * (CGFloat)(components.hour%12 + 1.0/60.0*components.minute);
	minuteHand.zRotation =  - (2*M_PI)/60.0 * (CGFloat)(components.minute + 1.0/60.0*components.second);
	secondHand.zRotation = - (2*M_PI)/60 * (CGFloat)(components.second + 1.0/NSEC_PER_SEC*components.nanosecond);

	colorRegion.zRotation =  M_PI_2 -(2*M_PI)/60.0 * (CGFloat)(components.minute + 1.0/60.0*components.second);
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
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
	[self updateHands];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



