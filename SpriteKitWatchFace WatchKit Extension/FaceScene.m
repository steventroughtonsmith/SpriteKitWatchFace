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

#define PREPARE_SCREENSHOT 0

CGFloat workingRadiusForFaceOfSizeWithAngle(CGSize faceSize, CGFloat angle)
{
	CGFloat faceHeight = faceSize.height;
	CGFloat faceWidth = faceSize.width;
	
	CGFloat workingRadius = 0;
	
	double vx = cos(angle);
	double vy = sin(angle);
	
	double x1 = 0;
	double y1 = 0;
	double x2 = faceHeight;
	double y2 = faceWidth;
	double px = faceHeight/2;
	double py = faceWidth/2;
	
	double t[4];
	double smallestT = 1000;
	
	t[0]=(x1-px)/vx;
	t[1]=(x2-px)/vx;
	t[2]=(y1-py)/vy;
	t[3]=(y2-py)/vy;
	
	for (int m = 0; m < 4; m++)
	{
		double currentT = t[m];
		
		if (currentT > 0 && currentT < smallestT)
			smallestT = currentT;
	}
	
	workingRadius = smallestT;
	
	return workingRadius;
}

@implementation FaceScene

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		
		self.theme = ThemeHermesPink;
		self.useProgrammaticLayout = YES;
		self.useRoundFace = YES;
		
		[self setupColors];
		[self setupScene];
		
		self.delegate = self;
	}
	return self;
}

-(void)setupTickmarksForRoundFace
{
	CGFloat margin = 4.0;
	CGFloat labelMargin = 26.0;
	
	SKNode *faceMarkings = [SKNode node];
	
	/* Hardcoded for 44mm Apple Watch */
	
	CGSize faceSize = (CGSize){184, 224};
	
	for (int i = 0; i < 12; i++)
	{
		CGFloat angle = -(2*M_PI)/12.0 * i;
		CGFloat workingRadius = faceSize.width/2;
		CGFloat longTickHeight = workingRadius/15;
		
		SKSpriteNode *tick = [SKSpriteNode spriteNodeWithColor:self.markColor size:CGSizeMake(2, longTickHeight)];
		
		tick.position = CGPointZero;
		tick.anchorPoint = CGPointMake(0.5, (workingRadius-margin)/longTickHeight);
		tick.zRotation = angle;
		
		[faceMarkings addChild:tick];
		
		CGFloat h = 25;
		
		NSDictionary *attribs = @{NSFontAttributeName : [NSFont systemFontOfSize:h], NSForegroundColorAttributeName : self.textColor};
		
		NSAttributedString *labelText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%i", i == 0 ? 12 : i] attributes:attribs];
		
		SKLabelNode *numberLabel = [SKLabelNode labelNodeWithAttributedText:labelText];
		numberLabel.position = CGPointMake((workingRadius-labelMargin) * -sin(angle), (workingRadius-labelMargin) * cos(angle) - 9);
		
		[faceMarkings addChild:numberLabel];
	}
	
	for (int i = 0; i < 60; i++)
	{
		CGFloat angle = - (2*M_PI)/60.0 * i;
		CGFloat workingRadius = faceSize.width/2;
		CGFloat shortTickHeight = workingRadius/20;
		SKSpriteNode *tick = [SKSpriteNode spriteNodeWithColor:self.markColor size:CGSizeMake(1, shortTickHeight)];
		
		tick.position = CGPointZero;
		tick.anchorPoint = CGPointMake(0.5, (workingRadius-margin)/shortTickHeight);
		tick.zRotation = angle;
		
		
		if (i % 5 != 0)
			[faceMarkings addChild:tick];
	}
	
	[self addChild:faceMarkings];
}

-(void)setupTickmarksForRectangularFace
{
	CGFloat margin = 5.0;
	CGFloat labelYMargin = 30.0;
	CGFloat labelXMargin = 24.0;

	CGSize faceSize = (CGSize){184, 224};
	
	/* Major */
	for (int i = 0; i < 12; i++)
	{
		CGFloat angle = -(2*M_PI)/12.0 * i;
		CGFloat workingRadius = workingRadiusForFaceOfSizeWithAngle(faceSize, angle);
		CGFloat longTickHeight = workingRadius/10.0;
		
		SKSpriteNode *tick = [SKSpriteNode spriteNodeWithColor:self.markColor size:CGSizeMake(2, longTickHeight)];
		
		tick.position = CGPointZero;
		tick.anchorPoint = CGPointMake(0.5, (workingRadius-margin)/longTickHeight);
		tick.zRotation = angle;
		
		tick.zPosition = 0;
		
		[self addChild:tick];
	}
	
	/* Minor */
	for (int i = 0; i < 60; i++)
	{
		
		CGFloat angle = - (2*M_PI)/60.0 * i;
		CGFloat workingRadius = workingRadiusForFaceOfSizeWithAngle(faceSize, angle);
		CGFloat shortTickHeight = workingRadius/20;
		SKSpriteNode *tick = [SKSpriteNode spriteNodeWithColor:self.markColor size:CGSizeMake(1, shortTickHeight)];
		
		tick.position = CGPointZero;
		tick.anchorPoint = CGPointMake(0.5, (workingRadius-margin)/shortTickHeight);
		tick.zRotation = angle;
		
		tick.zPosition = 0;
		if (i % 5 != 0)
			[self addChild:tick];
	}
	
	/* Numerals */
	for (int i = 1; i <= 12; i++)
	{
		CGFloat fontSize = 25;
		
		SKSpriteNode *labelNode = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(fontSize, fontSize)];
		labelNode.anchorPoint = CGPointMake(0.5,0.5);
		
		if (i == 1 || i == 11 || i == 12)
			labelNode.position = CGPointMake(labelXMargin-faceSize.width/2 + ((i+1)%3) * (faceSize.width-labelXMargin*2)/3.0 + (faceSize.width-labelXMargin*2)/6.0, faceSize.height/2-labelYMargin);
		else if (i == 5 || i == 6 || i == 7)
			labelNode.position = CGPointMake(labelXMargin-faceSize.width/2 + (2-((i+1)%3)) * (faceSize.width-labelXMargin*2)/3.0 + (faceSize.width-labelXMargin*2)/6.0, -faceSize.height/2+labelYMargin);
		else if (i == 2 || i == 3 || i == 4)
			labelNode.position = CGPointMake(faceSize.height/2-fontSize-labelXMargin, -(faceSize.width-labelXMargin*2)/2 + (2-((i+1)%3)) * (faceSize.width-labelXMargin*2)/3.0 + (faceSize.width-labelYMargin*2)/6.0);
		else if (i == 8 || i == 9 || i == 10)
			labelNode.position = CGPointMake(-faceSize.height/2+fontSize+labelXMargin, -(faceSize.width-labelXMargin*2)/2 + ((i+1)%3) * (faceSize.width-labelXMargin*2)/3.0 + (faceSize.width-labelYMargin*2)/6.0);
		
		[self addChild:labelNode];
		
		NSDictionary *attribs = @{NSFontAttributeName : [NSFont fontWithName:@"Futura-Medium" size:fontSize], NSForegroundColorAttributeName : self.textColor};
		
		NSAttributedString *labelText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%i", i] attributes:attribs];
		
		SKLabelNode *numberLabel = [SKLabelNode labelNodeWithAttributedText:labelText];
		
		numberLabel.position = CGPointMake(0, -9);
		
		[labelNode addChild:numberLabel];
	}
}

-(void)setupColors
{
	SKColor *lightColor = nil;
	SKColor *darkColor = nil;
	SKColor *markColor = nil;
	SKColor *inlayColor = nil;
	SKColor *handColor = nil;
	SKColor *textColor = nil;
	
	switch (self.theme) {
		case ThemeHermesPink:
		{
			lightColor = [SKColor colorWithRed:0.848 green:0.187 blue:0.349 alpha:1];
			darkColor = [SKColor colorWithRed:0.387 green:0.226 blue:0.270 alpha:1];
			markColor = [SKColor colorWithRed:0.831 green:0.540 blue:0.612 alpha:1];
			inlayColor = lightColor;
			handColor = [SKColor whiteColor];
			textColor = [SKColor whiteColor];
			break;
		}
		case ThemeHermesOrange:
		{
			lightColor = [SKColor colorWithRed:0.892 green:0.825 blue:0.745 alpha:1.000];
			darkColor = [SKColor colorWithRed:0.118 green:0.188 blue:0.239 alpha:1.000];
			inlayColor = [SKColor colorWithRed:1.000 green:0.450 blue:0.136 alpha:1.000];
			markColor = [inlayColor colorWithAlphaComponent:0.5];
			handColor = [SKColor whiteColor];
			textColor = inlayColor;
			break;
		}
		case ThemeNavy:
		{
			lightColor = [SKColor colorWithRed:0.067 green:0.471 blue:0.651 alpha:1.000];
			darkColor = [SKColor colorWithRed:0.118 green:0.188 blue:0.239 alpha:1.000];
			inlayColor = lightColor;
			markColor = [SKColor whiteColor];
			handColor = [SKColor whiteColor];
			textColor = [SKColor whiteColor];
			break;
		}
		case ThemeTidepod:
		{
			lightColor = [SKColor colorWithRed:1.000 green:0.450 blue:0.136 alpha:1.000];
			darkColor = [SKColor colorWithRed:0.067 green:0.471 blue:0.651 alpha:1.000];
			inlayColor = [SKColor colorWithRed:0.953 green:0.569 blue:0.196 alpha:1.000];
			markColor = [SKColor whiteColor];
			handColor = [SKColor whiteColor];
			textColor = [SKColor whiteColor];
			break;
		}
		case ThemeBretonnia:
		{
			lightColor = [SKColor colorWithRed:0.067 green:0.420 blue:0.843 alpha:1.000];
			darkColor = [SKColor colorWithRed:0.956 green:0.137 blue:0.294 alpha:1.000];
			inlayColor = darkColor;
			markColor = [SKColor whiteColor];
			handColor = [SKColor whiteColor];
			textColor = [SKColor whiteColor];
			break;
		}
		case ThemeNoir:
		{
			lightColor = [SKColor colorWithWhite:0.3 alpha:1.0];
			darkColor = [SKColor blackColor];
			inlayColor = darkColor;
			markColor = [SKColor whiteColor];
			handColor = [SKColor whiteColor];
			textColor = [SKColor whiteColor];
			break;
		}
		case ThemeContrast:
		{
			lightColor = [SKColor whiteColor];
			darkColor = [SKColor whiteColor];
			inlayColor = [SKColor whiteColor];
			markColor = [SKColor blackColor];
			handColor = [SKColor blackColor];
			textColor = [SKColor blackColor];
			break;
		}
		case ThemeVictoire:
		{
			lightColor = [SKColor colorWithRed:0.937 green:0.925 blue:0.871 alpha:1.000];
			darkColor = [SKColor colorWithRed:0.737 green:0.725 blue:0.671 alpha:1.000];
			inlayColor = lightColor;
			markColor = [SKColor colorWithRed:0.337 green:0.325 blue:0.271 alpha:1.000];
			handColor = [SKColor blackColor];
			textColor = [SKColor colorWithRed:0.137 green:0.125 blue:0.071 alpha:1.000];
			break;
		}
		case ThemeLiquid:
		{
			lightColor = [SKColor colorWithWhite:0.2 alpha:1.0];
			darkColor = lightColor;
			inlayColor = [SKColor colorWithWhite:0.3 alpha:1.0];
			markColor = [SKColor colorWithWhite:0.5 alpha:1.0];
			handColor = [SKColor whiteColor];
			textColor = [SKColor whiteColor];
			break;
		}
			
		default:
			break;
	}
	
	self.lightColor = lightColor;
	self.darkColor = darkColor;
	self.markColor = markColor;
	self.inlayColor = inlayColor;
	self.textColor = textColor;
	self.handColor = handColor;
}

-(void)setupScene
{
	SKNode *face = [self childNodeWithName:@"Face"];
	
	SKSpriteNode *hourHand = (SKSpriteNode *)[face childNodeWithName:@"Hours"];
	SKSpriteNode *minuteHand = (SKSpriteNode *)[face childNodeWithName:@"Minutes"];
	
	SKSpriteNode *hourHandInlay = (SKSpriteNode *)[hourHand childNodeWithName:@"Hours Inlay"];
	SKSpriteNode *minuteHandInlay = (SKSpriteNode *)[minuteHand childNodeWithName:@"Minutes Inlay"];
	
	SKSpriteNode *secondHand = (SKSpriteNode *)[face childNodeWithName:@"Seconds"];
	SKSpriteNode *colorRegion = (SKSpriteNode *)[face childNodeWithName:@"Color Region"];
	SKSpriteNode *numbers = (SKSpriteNode *)[face childNodeWithName:@"Numbers"];
	
	hourHand.color = self.handColor;
	hourHand.colorBlendFactor = 1.0;
	
	minuteHand.color = self.handColor;
	minuteHand.colorBlendFactor = 1.0;
	
	secondHand.color = self.markColor;
	secondHand.colorBlendFactor = 1.0;
	
	self.backgroundColor = self.darkColor;
	
	colorRegion.color = self.lightColor;
	colorRegion.colorBlendFactor = 1.0;
	
	numbers.color = self.textColor;
	numbers.colorBlendFactor = 1.0;
	
	hourHandInlay.color = self.inlayColor;
	hourHandInlay.colorBlendFactor = 1.0;
	
	minuteHandInlay.color = self.inlayColor;
	minuteHandInlay.colorBlendFactor = 1.0;
	
	if (self.useProgrammaticLayout)
	{
		SKNode *face = [self childNodeWithName:@"Face"];
		SKSpriteNode *numbersLayer = (SKSpriteNode *)[face childNodeWithName:@"Numbers"];
		numbersLayer.alpha = 0;
		
		if (self.useRoundFace)
		{
			[self setupTickmarksForRoundFace];
		}
		else
		{
			[self setupTickmarksForRectangularFace];
		}
	}
}

- (void)update:(NSTimeInterval)currentTime forScene:(SKScene *)scene
{
	[self updateHands];
}

-(void)updateHands
{
#if PREPARE_SCREENSHOT
	NSDate *now = [NSDate dateWithTimeIntervalSince1970:32760+27]; // 10:06:27am
#else
	NSDate *now = [NSDate date];
#endif
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
