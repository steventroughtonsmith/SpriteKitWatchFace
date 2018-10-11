//
//  FaceScene.m
//  SpriteKitWatchFace
//
//  Created by Steven Troughton-Smith on 10/10/2018.
//  Copyright © 2018 Steven Troughton-Smith. All rights reserved.
//

#import "FaceScene.h"

#if TARGET_OS_IPHONE
#define NSFont UIFont
#endif

@implementation FaceScene

BOOL vectorDisplay = YES;

// 184 x 224

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		[self setupColors];
		
		if (vectorDisplay)
			[self setupTickmarks];
		
		self.delegate = self;
	}
	return self;
}

-(void)setupTickmarks
{
	CGFloat margin = 4.0;
	CGFloat labelMargin = 26.0;
	
	SKNode *faceMarkings = [SKNode node];
	
	/* Hardcoded for 44mm Apple Watch */
	CGFloat faceWidth = 184;
	CGFloat faceHeight = 224;

	SKColor *accentColor = [SKColor colorWithRed:0.831 green:0.540 blue:0.612 alpha:1];

	for (int i = 0; i < 12; i++)
	{
		CGFloat angle = -(2*M_PI)/12.0 * i;
		CGFloat workingRadius = faceWidth/2;
		CGFloat longTickHeight = workingRadius/15;
		
		SKSpriteNode *tick = [SKSpriteNode spriteNodeWithColor:accentColor size:CGSizeMake(2, longTickHeight)];
		
		tick.position = CGPointZero;
		tick.anchorPoint = CGPointMake(0.5, (workingRadius-margin)/longTickHeight);
		tick.zRotation = angle;
		
		[faceMarkings addChild:tick];
		
		CGFloat h = 25;
		
		NSDictionary *attribs = @{NSFontAttributeName : [NSFont systemFontOfSize:h], NSForegroundColorAttributeName : [SKColor whiteColor]};
		
		NSAttributedString *labelText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%i", i == 0 ? 12 : i] attributes:attribs];
		
		SKLabelNode *numberLabel = [SKLabelNode labelNodeWithAttributedText:labelText];
		numberLabel.position = CGPointMake((workingRadius-labelMargin) * -sin(angle), (workingRadius-labelMargin) * cos(angle) - 9);
		
		[faceMarkings addChild:numberLabel];
	}
	
	for (int i = 0; i < 60; i++)
	{
		CGFloat angle = - (2*M_PI)/60.0 * i;
		CGFloat workingRadius = faceWidth/2;
		CGFloat shortTickHeight = workingRadius/20;
		SKSpriteNode *tick = [SKSpriteNode spriteNodeWithColor:accentColor size:CGSizeMake(1, shortTickHeight)];
		
		tick.position = CGPointZero;
		tick.anchorPoint = CGPointMake(0.5, (workingRadius-margin)/shortTickHeight);
		tick.zRotation = angle;
		
		
		if (i % 5 != 0)
			[faceMarkings addChild:tick];
	}
	
	[self addChild:faceMarkings];
	
	SKNode *face = [self childNodeWithName:@"Face"];
	SKSpriteNode *numbersLayer = (SKSpriteNode *)[face childNodeWithName:@"Numbers"];
	numbersLayer.alpha = 0;
}


-(void)setupColors
{
	SKColor *lightColor = [SKColor colorWithRed:0.848 green:0.187 blue:0.349 alpha:1];
	SKColor *darkColor = [SKColor colorWithRed:0.387 green:0.226 blue:0.270 alpha:1];
	SKColor *accentColor = [SKColor colorWithRed:0.831 green:0.540 blue:0.612 alpha:1];
	
	SKNode *face = [self childNodeWithName:@"Face"];
	
	SKSpriteNode *hourHand = (SKSpriteNode *)[face childNodeWithName:@"Hours"];
	SKSpriteNode *minuteHand = (SKSpriteNode *)[face childNodeWithName:@"Minutes"];
	
	SKSpriteNode *hourHandInlay = (SKSpriteNode *)[hourHand childNodeWithName:@"Hours Inlay"];
	SKSpriteNode *minuteHandInlay = (SKSpriteNode *)[minuteHand childNodeWithName:@"Minutes Inlay"];
	
	SKSpriteNode *secondHand = (SKSpriteNode *)[face childNodeWithName:@"Seconds"];
	SKSpriteNode *colorRegion = (SKSpriteNode *)[face childNodeWithName:@"Color Region"];
	SKSpriteNode *numbers = (SKSpriteNode *)[face childNodeWithName:@"Numbers"];
	
	hourHand.color = [SKColor whiteColor];
	hourHand.colorBlendFactor = 1.0;
	
	minuteHand.color = [SKColor whiteColor];
	minuteHand.colorBlendFactor = 1.0;
	
	secondHand.color = accentColor;
	secondHand.colorBlendFactor = 1.0;
	
	self.backgroundColor = darkColor;
	
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
	
	SKNode *face = [self childNodeWithName:@"Face"];
	
	SKNode *hourHand = [face childNodeWithName:@"Hours"];
	SKNode *minuteHand = [face childNodeWithName:@"Minutes"];
	SKNode *secondHand = [face childNodeWithName:@"Seconds"];
	
	SKNode *colorRegion = [face childNodeWithName:@"Color Region"];
	
	hourHand.zRotation =  - (2*M_PI)/12.0 * (CGFloat)(components.hour%12 + 1.0/60.0*components.minute);
	minuteHand.zRotation =  - (2*M_PI)/60.0 * (CGFloat)(components.minute + 1.0/60.0*components.second);
	secondHand.zRotation = - (2*M_PI)/60 * (CGFloat)(components.second + 1.0/NSEC_PER_SEC*components.nanosecond);
	
	colorRegion.zRotation =  M_PI_2 -(2*M_PI)/60.0 * (CGFloat)(components.minute + 1.0/60.0*components.second);
}


@end
