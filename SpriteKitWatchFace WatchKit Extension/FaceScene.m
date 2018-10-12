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
#define NSFontWeightMedium UIFontWeightMedium
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
		
		self.theme = ThemeMarble;
		self.useProgrammaticLayout = YES;
		self.useRoundFace = YES;
		self.numeralStyle = NumeralStyleAll;
		self.tickmarkStyle = TickmarkStyleAll;
		self.faceSize = (CGSize){184, 224};
		
		[self refreshTheme];
		
		self.delegate = self;
	}
	return self;
}

#pragma mark -

-(void)setupTickmarksForRoundFaceWithLayerName:(NSString *)layerName
{
	CGFloat margin = 4.0;
	CGFloat labelMargin = 26.0;
	
	SKCropNode *faceMarkings = [SKCropNode node];
	faceMarkings.name = layerName;
	
	/* Hardcoded for 44mm Apple Watch */
	
	for (int i = 0; i < 12; i++)
	{
		CGFloat angle = -(2*M_PI)/12.0 * i;
		CGFloat workingRadius = self.faceSize.width/2;
		CGFloat longTickHeight = workingRadius/15;
		
		SKSpriteNode *tick = [SKSpriteNode spriteNodeWithColor:self.majorMarkColor size:CGSizeMake(2, longTickHeight)];
		
		tick.position = CGPointZero;
		tick.anchorPoint = CGPointMake(0.5, (workingRadius-margin)/longTickHeight);
		tick.zRotation = angle;
		
		if (self.tickmarkStyle == TickmarkStyleAll || self.tickmarkStyle == TickmarkStyleMajor)
			[faceMarkings addChild:tick];
		
		CGFloat h = 25;
		
		NSDictionary *attribs = @{NSFontAttributeName : [NSFont systemFontOfSize:h weight:NSFontWeightMedium], NSForegroundColorAttributeName : self.textColor};
		
		NSAttributedString *labelText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%i", i == 0 ? 12 : i] attributes:attribs];
		
		SKLabelNode *numberLabel = [SKLabelNode labelNodeWithAttributedText:labelText];
		numberLabel.position = CGPointMake((workingRadius-labelMargin) * -sin(angle), (workingRadius-labelMargin) * cos(angle) - 9);
		
		if (self.numeralStyle == NumeralStyleAll || ((self.numeralStyle == NumeralStyleCardinal) && (i % 3 == 0)))
			[faceMarkings addChild:numberLabel];
	}
	
	for (int i = 0; i < 60; i++)
	{
		CGFloat angle = - (2*M_PI)/60.0 * i;
		CGFloat workingRadius = self.faceSize.width/2;
		CGFloat shortTickHeight = workingRadius/20;
		SKSpriteNode *tick = [SKSpriteNode spriteNodeWithColor:self.minorMarkColor size:CGSizeMake(1, shortTickHeight)];
		
		tick.position = CGPointZero;
		tick.anchorPoint = CGPointMake(0.5, (workingRadius-margin)/shortTickHeight);
		tick.zRotation = angle;
		
		if (self.tickmarkStyle == TickmarkStyleAll || self.tickmarkStyle == TickmarkStyleMinor)
		{
			if (i % 5 != 0)
				[faceMarkings addChild:tick];
		}
	}

	[self addChild:faceMarkings];
}


-(void)setupTickmarksForRectangularFaceWithLayerName:(NSString *)layerName
{
	CGFloat margin = 5.0;
	CGFloat labelYMargin = 30.0;
	CGFloat labelXMargin = 24.0;
	
	SKCropNode *faceMarkings = [SKCropNode node];
	faceMarkings.name = layerName;
	
	/* Major */
	for (int i = 0; i < 12; i++)
	{
		CGFloat angle = -(2*M_PI)/12.0 * i;
		CGFloat workingRadius = workingRadiusForFaceOfSizeWithAngle(self.faceSize, angle);
		CGFloat longTickHeight = workingRadius/10.0;
		
		SKSpriteNode *tick = [SKSpriteNode spriteNodeWithColor:self.majorMarkColor size:CGSizeMake(2, longTickHeight)];
		
		tick.position = CGPointZero;
		tick.anchorPoint = CGPointMake(0.5, (workingRadius-margin)/longTickHeight);
		tick.zRotation = angle;
		
		tick.zPosition = 0;
		
		if (self.tickmarkStyle == TickmarkStyleAll || self.tickmarkStyle == TickmarkStyleMajor)
			[faceMarkings addChild:tick];
	}
	
	/* Minor */
	for (int i = 0; i < 60; i++)
	{
		
		CGFloat angle =  (2*M_PI)/60.0 * i;
		CGFloat workingRadius = workingRadiusForFaceOfSizeWithAngle(self.faceSize, angle);
		CGFloat shortTickHeight = workingRadius/20;
		SKSpriteNode *tick = [SKSpriteNode spriteNodeWithColor:self.minorMarkColor size:CGSizeMake(1, shortTickHeight)];
		
		/* Super hacky hack to inset the tickmarks at the four corners of a curved display instead of doing math */
		if (i == 6 || i == 7  || i == 23 || i == 24 || i == 36 || i == 37 || i == 53 || i == 54)
		{
			workingRadius -= 8;
		}

		tick.position = CGPointZero;
		tick.anchorPoint = CGPointMake(0.5, (workingRadius-margin)/shortTickHeight);
		tick.zRotation = angle;
		
		tick.zPosition = 0;
		
		if (self.tickmarkStyle == TickmarkStyleAll || self.tickmarkStyle == TickmarkStyleMinor)
		{
			if (i % 5 != 0)
			{
				[faceMarkings addChild:tick];
			}
		}
	}
	
	/* Numerals */
	for (int i = 1; i <= 12; i++)
	{
		CGFloat fontSize = 25;
		
		SKSpriteNode *labelNode = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(fontSize, fontSize)];
		labelNode.anchorPoint = CGPointMake(0.5,0.5);
		
		if (i == 1 || i == 11 || i == 12)
			labelNode.position = CGPointMake(labelXMargin-self.faceSize.width/2 + ((i+1)%3) * (self.faceSize.width-labelXMargin*2)/3.0 + (self.faceSize.width-labelXMargin*2)/6.0, self.faceSize.height/2-labelYMargin);
		else if (i == 5 || i == 6 || i == 7)
			labelNode.position = CGPointMake(labelXMargin-self.faceSize.width/2 + (2-((i+1)%3)) * (self.faceSize.width-labelXMargin*2)/3.0 + (self.faceSize.width-labelXMargin*2)/6.0, -self.faceSize.height/2+labelYMargin);
		else if (i == 2 || i == 3 || i == 4)
			labelNode.position = CGPointMake(self.faceSize.height/2-fontSize-labelXMargin, -(self.faceSize.width-labelXMargin*2)/2 + (2-((i+1)%3)) * (self.faceSize.width-labelXMargin*2)/3.0 + (self.faceSize.width-labelYMargin*2)/6.0);
		else if (i == 8 || i == 9 || i == 10)
			labelNode.position = CGPointMake(-self.faceSize.height/2+fontSize+labelXMargin, -(self.faceSize.width-labelXMargin*2)/2 + ((i+1)%3) * (self.faceSize.width-labelXMargin*2)/3.0 + (self.faceSize.width-labelYMargin*2)/6.0);
		
		[faceMarkings addChild:labelNode];
		
		NSDictionary *attribs = @{NSFontAttributeName : [NSFont fontWithName:@"Futura-Medium" size:fontSize], NSForegroundColorAttributeName : self.textColor};
		
		NSAttributedString *labelText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%i", i] attributes:attribs];
		
		SKLabelNode *numberLabel = [SKLabelNode labelNodeWithAttributedText:labelText];
		
		numberLabel.position = CGPointMake(0, -9);
		
		if (self.numeralStyle == NumeralStyleAll || ((self.numeralStyle == NumeralStyleCardinal) && (i % 3 == 0)))
			[labelNode addChild:numberLabel];
	}
	
	[self addChild:faceMarkings];
}

#pragma mark -

-(void)setupColors
{
	SKColor *colorRegionColor = nil;
	SKColor *faceBackgroundColor = nil;
	SKColor *majorMarkColor = nil;
	SKColor *minorMarkColor = nil;
	SKColor *inlayColor = nil;
	SKColor *handColor = nil;
	SKColor *textColor = nil;
	SKColor *secondHandColor = nil;
	
	SKColor *alternateMajorMarkColor = nil;
	SKColor *alternateMinorMarkColor = nil;
	SKColor *alternateTextColor = nil;

	self.useMasking = NO;
	
	switch (self.theme) {
		case ThemeHermesPink:
		{
			colorRegionColor = [SKColor colorWithRed:0.848 green:0.187 blue:0.349 alpha:1];
			faceBackgroundColor = [SKColor colorWithRed:0.387 green:0.226 blue:0.270 alpha:1];
			majorMarkColor = [SKColor colorWithRed:0.831 green:0.540 blue:0.612 alpha:1];
			minorMarkColor = majorMarkColor;
			inlayColor = colorRegionColor;
			handColor = [SKColor whiteColor];
			textColor = [SKColor whiteColor];
			secondHandColor = majorMarkColor;
			break;
		}
		case ThemeHermesOrange:
		{
			colorRegionColor = [SKColor colorWithRed:0.892 green:0.825 blue:0.745 alpha:1.000];
			faceBackgroundColor = [SKColor colorWithRed:0.118 green:0.188 blue:0.239 alpha:1.000];
			inlayColor = [SKColor colorWithRed:1.000 green:0.450 blue:0.136 alpha:1.000];
			majorMarkColor = [inlayColor colorWithAlphaComponent:0.5];
			minorMarkColor = majorMarkColor;
			handColor = [SKColor whiteColor];
			textColor = inlayColor;
			secondHandColor = majorMarkColor;
			break;
		}
		case ThemeNavy:
		{
			colorRegionColor = [SKColor colorWithRed:0.067 green:0.471 blue:0.651 alpha:1.000];
			faceBackgroundColor = [SKColor colorWithRed:0.118 green:0.188 blue:0.239 alpha:1.000];
			inlayColor = colorRegionColor;
			majorMarkColor = [SKColor whiteColor];
			minorMarkColor = majorMarkColor;
			handColor = [SKColor whiteColor];
			textColor = [SKColor whiteColor];
			secondHandColor = majorMarkColor;
			break;
		}
		case ThemeTidepod:
		{
			colorRegionColor = [SKColor colorWithRed:1.000 green:0.450 blue:0.136 alpha:1.000];
			faceBackgroundColor = [SKColor colorWithRed:0.067 green:0.471 blue:0.651 alpha:1.000];
			inlayColor = [SKColor colorWithRed:0.953 green:0.569 blue:0.196 alpha:1.000];
			majorMarkColor = [SKColor whiteColor];
			minorMarkColor = majorMarkColor;
			handColor = [SKColor whiteColor];
			textColor = [SKColor whiteColor];
			secondHandColor = majorMarkColor;
			break;
		}
		case ThemeBretonnia:
		{
			colorRegionColor = [SKColor colorWithRed:0.067 green:0.420 blue:0.843 alpha:1.000];
			faceBackgroundColor = [SKColor colorWithRed:0.956 green:0.137 blue:0.294 alpha:1.000];
			inlayColor = faceBackgroundColor;
			majorMarkColor = [SKColor whiteColor];
			minorMarkColor = majorMarkColor;
			handColor = [SKColor whiteColor];
			textColor = [SKColor whiteColor];
			secondHandColor = majorMarkColor;
			break;
		}
		case ThemeNoir:
		{
			colorRegionColor = [SKColor colorWithWhite:0.3 alpha:1.0];
			faceBackgroundColor = [SKColor blackColor];
			inlayColor = faceBackgroundColor;
			majorMarkColor = [SKColor whiteColor];
			minorMarkColor = majorMarkColor;
			handColor = [SKColor whiteColor];
			textColor = [SKColor whiteColor];
			secondHandColor = majorMarkColor;
			break;
		}
		case ThemeContrast:
		{
			colorRegionColor = [SKColor whiteColor];
			faceBackgroundColor = [SKColor whiteColor];
			inlayColor = [SKColor whiteColor];
			majorMarkColor = [SKColor blackColor];
			minorMarkColor = majorMarkColor;
			handColor = [SKColor blackColor];
			textColor = [SKColor blackColor];
			secondHandColor = majorMarkColor;
			break;
		}
		case ThemeVictoire:
		{
			colorRegionColor = [SKColor colorWithRed:0.749 green:0.291 blue:0.319 alpha:1.000];
			faceBackgroundColor = [SKColor colorWithRed:0.391 green:0.382 blue:0.340 alpha:1.000];
			inlayColor = [SKColor colorWithRed:0.649 green:0.191 blue:0.219 alpha:1.000];
			majorMarkColor = [SKColor colorWithRed:0.937 green:0.925 blue:0.871 alpha:1.000];
			minorMarkColor = majorMarkColor;
			handColor = majorMarkColor;
			textColor = majorMarkColor;
			secondHandColor = [SKColor colorWithRed:0.949 green:0.491 blue:0.619 alpha:1.000];
			break;
		}
		case ThemeLiquid:
		{
			colorRegionColor = [SKColor colorWithWhite:0.2 alpha:1.0];
			faceBackgroundColor = colorRegionColor;
			inlayColor = [SKColor colorWithWhite:0.3 alpha:1.0];
			majorMarkColor = [SKColor colorWithWhite:0.5 alpha:1.0];
			minorMarkColor = majorMarkColor;
			handColor = [SKColor whiteColor];
			textColor = [SKColor whiteColor];
			secondHandColor = majorMarkColor;
			break;
		}
		case ThemeAngler:
		{
			colorRegionColor = [SKColor blackColor];
			faceBackgroundColor = [SKColor blackColor];
			inlayColor = [SKColor colorWithRed:0.180 green:0.800 blue:0.482 alpha:1.000];
			majorMarkColor = inlayColor;
			minorMarkColor = majorMarkColor;
			handColor = [inlayColor colorWithAlphaComponent:0.4];
			textColor = inlayColor;
			secondHandColor = majorMarkColor;
			break;
		}
		case ThemeSculley:
		{
			colorRegionColor = [SKColor colorWithRed:0.180 green:0.800 blue:0.482 alpha:1.000];
			faceBackgroundColor = [SKColor colorWithRed:0.180 green:0.600 blue:0.282 alpha:1.000];
			inlayColor = [SKColor colorWithRed:0.180 green:0.800 blue:0.482 alpha:1.000];
			majorMarkColor = [SKColor colorWithRed:0.080 green:0.300 blue:0.082 alpha:1.000];
			minorMarkColor = majorMarkColor;
			handColor = [SKColor colorWithRed:0.080 green:0.300 blue:0.082 alpha:1.000];
			textColor = [SKColor colorWithRed:0.080 green:0.300 blue:0.082 alpha:1.000];
			secondHandColor = majorMarkColor;
			break;
		}
		case ThemeKitty:
		{
			colorRegionColor = [SKColor colorWithRed:0.447 green:0.788 blue:0.796 alpha:1.000];
			faceBackgroundColor = [SKColor colorWithRed:0.459 green:0.471 blue:0.706 alpha:1.000];
			inlayColor = colorRegionColor;
			majorMarkColor = [SKColor colorWithRed:0.259 green:0.271 blue:0.506 alpha:1.000];
			minorMarkColor = majorMarkColor;
			handColor = [SKColor colorWithRed:0.159 green:0.171 blue:0.406 alpha:1.000];
			textColor = handColor;
			secondHandColor = majorMarkColor;
			break;
		}
		case ThemeDelay:
		{
			colorRegionColor = [SKColor colorWithRed:0.941 green:0.408 blue:0.231 alpha:1.000];
			faceBackgroundColor = [SKColor colorWithWhite:0.282 alpha:1.000];
			inlayColor = colorRegionColor;
			majorMarkColor = [SKColor colorWithRed:0.941 green:0.708 blue:0.531 alpha:1.000];
			minorMarkColor = majorMarkColor;
			handColor = [SKColor whiteColor];
			textColor = handColor;
			secondHandColor = majorMarkColor;
			break;
		}
		case ThemeDiesel:
		{
			colorRegionColor = [SKColor colorWithRed:0.702 green:0.212 blue:0.231 alpha:1.000];
			faceBackgroundColor = [SKColor colorWithRed:0.027 green:0.251 blue:0.502 alpha:1.000];
			inlayColor = [SKColor colorWithRed:0.502 green:0.212 blue:0.231 alpha:1.000];
			majorMarkColor = [SKColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.8];
			minorMarkColor = majorMarkColor;
			handColor = [SKColor whiteColor];
			textColor = handColor;
			secondHandColor = [SKColor colorWithRed:0.802 green:0.412 blue:0.431 alpha:1.000];
			break;
		}
		case ThemeLuxe:
		{
			colorRegionColor = [SKColor colorWithWhite:0.082 alpha:1.000];
			faceBackgroundColor = [SKColor colorWithWhite:0.082 alpha:1.000];
			inlayColor = [SKColor colorWithRed:0.969 green:0.878 blue:0.780 alpha:1.000];
			majorMarkColor = [SKColor colorWithRed:0.804 green:0.710 blue:0.639 alpha:1.000];
			minorMarkColor = majorMarkColor;
			handColor = majorMarkColor;
			textColor = handColor;
			secondHandColor = inlayColor;
			break;
		}
		case ThemeSage:
		{
			colorRegionColor = [SKColor colorWithRed:0.357 green:0.678 blue:0.600 alpha:1.000];
			faceBackgroundColor = [SKColor colorWithRed:0.264 green:0.346 blue:0.321 alpha:1.000];
			inlayColor = colorRegionColor;
			majorMarkColor = [SKColor colorWithRed:0.607 green:0.754 blue:0.718 alpha:1.000];
			minorMarkColor = majorMarkColor;
			handColor = [SKColor whiteColor];
			textColor = handColor;
			secondHandColor = inlayColor;
			break;
		}
		case ThemeBondi:
		{
			colorRegionColor = [SKColor colorWithRed:0.086 green:0.584 blue:0.706 alpha:1.000];
			faceBackgroundColor = [SKColor colorWithWhite:0.9 alpha:1];
			inlayColor = colorRegionColor;
			majorMarkColor = [SKColor colorWithWhite:0.9 alpha:1.0];
			minorMarkColor = majorMarkColor;
			handColor = [SKColor whiteColor];
			textColor = [SKColor colorWithWhite:1.0 alpha:1.0];
			secondHandColor = [SKColor colorWithRed:0.486 green:0.784 blue:0.906 alpha:1.000];
			
			alternateTextColor = [SKColor colorWithWhite:0.6 alpha:1];
			alternateMinorMarkColor = [SKColor colorWithWhite:0.6 alpha:1];
			alternateMajorMarkColor = [SKColor colorWithWhite:0.6 alpha:1];
			
			self.useMasking = YES;
			break;
		}
		case ThemeTangerine:
		{
			colorRegionColor = [SKColor colorWithRed:0.992 green:0.502 blue:0.192 alpha:1.000];
			faceBackgroundColor = [SKColor colorWithWhite:0.9 alpha:1];
			inlayColor = colorRegionColor;
			majorMarkColor = [SKColor colorWithWhite:0.9 alpha:1.0];
			minorMarkColor = majorMarkColor;
			handColor = [SKColor whiteColor];
			textColor = [SKColor colorWithWhite:1.0 alpha:1.0];
			secondHandColor = [SKColor colorWithRed:0.992 green:0.702 blue:0.392 alpha:1.000];
			
			alternateTextColor = [SKColor colorWithWhite:0.6 alpha:1];
			alternateMinorMarkColor = [SKColor colorWithWhite:0.6 alpha:1];
			alternateMajorMarkColor = [SKColor colorWithWhite:0.6 alpha:1];
			
			self.useMasking = YES;
			break;
		}
		case ThemeStrawberry:
		{
			colorRegionColor = [SKColor colorWithRed:0.831 green:0.161 blue:0.420 alpha:1.000];
			faceBackgroundColor = [SKColor colorWithWhite:0.9 alpha:1];
			inlayColor = colorRegionColor;
			majorMarkColor = [SKColor colorWithWhite:0.9 alpha:1.0];
			minorMarkColor = majorMarkColor;
			handColor = [SKColor whiteColor];
			textColor = [SKColor colorWithWhite:1.0 alpha:1];
			secondHandColor = [SKColor colorWithRed:0.912 green:0.198 blue:0.410 alpha:1.000];
			
			alternateTextColor = [SKColor colorWithWhite:0.6 alpha:1];
			alternateMinorMarkColor = [SKColor colorWithWhite:0.6 alpha:1];
			alternateMajorMarkColor = [SKColor colorWithWhite:0.6 alpha:1];
			
			self.useMasking = YES;
			break;
		}
		case ThemeMarble:
		{
			colorRegionColor = [SKColor colorWithRed:0.196 green:0.329 blue:0.275 alpha:1.000];
			faceBackgroundColor = [SKColor colorWithRed:0.846 green:0.847 blue:0.757 alpha:1.000];
			inlayColor = colorRegionColor;
			majorMarkColor = [SKColor colorWithRed:0.365 green:0.580 blue:0.506 alpha:1.000];
			minorMarkColor = majorMarkColor;
			handColor = [SKColor whiteColor];
			textColor = [SKColor colorWithWhite:1.0 alpha:1];
			secondHandColor = [SKColor colorWithRed:0.912 green:0.198 blue:0.410 alpha:1.000];
			
			alternateTextColor = colorRegionColor;
			alternateMinorMarkColor = colorRegionColor;
			alternateMajorMarkColor = colorRegionColor;
			
			self.useMasking = YES;
			break;
		}
		default:
			break;
	}
	
	self.colorRegionColor = colorRegionColor;
	self.faceBackgroundColor = faceBackgroundColor;
	self.majorMarkColor = majorMarkColor;
	self.minorMarkColor = minorMarkColor;
	self.inlayColor = inlayColor;
	self.textColor = textColor;
	self.handColor = handColor;
	self.secondHandColor = secondHandColor;
	
	self.alternateMajorMarkColor = alternateMajorMarkColor;
	self.alternateMinorMarkColor = alternateMinorMarkColor;
	self.alternateTextColor = alternateTextColor;
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
	SKSpriteNode *colorRegionReflection = (SKSpriteNode *)[face childNodeWithName:@"Color Region Reflection"];
	SKSpriteNode *numbers = (SKSpriteNode *)[face childNodeWithName:@"Numbers"];
	
	hourHand.color = self.handColor;
	hourHand.colorBlendFactor = 1.0;
	
	minuteHand.color = self.handColor;
	minuteHand.colorBlendFactor = 1.0;
	
	secondHand.color = self.secondHandColor;
	secondHand.colorBlendFactor = 1.0;
	
	self.backgroundColor = self.faceBackgroundColor;
	
	colorRegion.color = self.colorRegionColor;
	colorRegion.colorBlendFactor = 1.0;
	
	numbers.color = self.textColor;
	numbers.colorBlendFactor = 1.0;
	
	hourHandInlay.color = self.inlayColor;
	hourHandInlay.colorBlendFactor = 1.0;
	
	minuteHandInlay.color = self.inlayColor;
	minuteHandInlay.colorBlendFactor = 1.0;
	
	SKSpriteNode *numbersLayer = (SKSpriteNode *)[face childNodeWithName:@"Numbers"];

	if (self.useProgrammaticLayout)
	{
		numbersLayer.alpha = 0;
		
		if (self.useRoundFace)
		{
			[self setupTickmarksForRoundFaceWithLayerName:@"Markings"];
		}
		else
		{
			[self setupTickmarksForRectangularFaceWithLayerName:@"Markings"];
		}
	}
	else
	{
		numbersLayer.alpha = 1;
	}
	
	colorRegionReflection.alpha = 0;
}


-(void)setupMasking
{
	SKCropNode *faceMarkings = (SKCropNode *)[self childNodeWithName:@"Markings"];
	SKNode *face = [self childNodeWithName:@"Face"];
	
	SKNode *colorRegion = [face childNodeWithName:@"Color Region"];
	SKNode *colorRegionReflection = [face childNodeWithName:@"Color Region Reflection"];
	
	faceMarkings.maskNode = colorRegion;
	
	self.textColor = self.alternateTextColor;
	self.minorMarkColor = self.alternateMinorMarkColor;
	self.majorMarkColor = self.alternateMajorMarkColor;
	
	
	if (self.useRoundFace)
	{
		[self setupTickmarksForRoundFaceWithLayerName:@"Markings Alternate"];
	}
	else
	{
		[self setupTickmarksForRectangularFaceWithLayerName:@"Markings Alternate"];
	}
	
	SKCropNode *alternateFaceMarkings = (SKCropNode *)[self childNodeWithName:@"Markings Alternate"];
	colorRegionReflection.alpha = 1;
	alternateFaceMarkings.maskNode = colorRegionReflection;
}

#pragma mark -

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
	SKNode *colorRegionReflection = [face childNodeWithName:@"Color Region Reflection"];

	hourHand.zRotation =  - (2*M_PI)/12.0 * (CGFloat)(components.hour%12 + 1.0/60.0*components.minute);
	minuteHand.zRotation =  - (2*M_PI)/60.0 * (CGFloat)(components.minute + 1.0/60.0*components.second);
	secondHand.zRotation = - (2*M_PI)/60 * (CGFloat)(components.second + 1.0/NSEC_PER_SEC*components.nanosecond);
	
	colorRegion.zRotation =  M_PI_2 -(2*M_PI)/60.0 * (CGFloat)(components.minute + 1.0/60.0*components.second);
	colorRegionReflection.zRotation =  M_PI_2 - (2*M_PI)/60.0 * (CGFloat)(components.minute + 1.0/60.0*components.second);
}

-(void)refreshTheme
{
	SKNode *existingMarkings = [self childNodeWithName:@"Markings"];
	SKNode *existingDualMaskMarkings = [self childNodeWithName:@"Markings 2"];

	[existingMarkings removeAllChildren];
	[existingMarkings removeFromParent];
	
	[existingDualMaskMarkings removeAllChildren];
	[existingDualMaskMarkings removeFromParent];
	
	[self setupColors];
	[self setupScene];
	
	if (self.useMasking)
	{
		[self setupMasking];
	}
}

@end
