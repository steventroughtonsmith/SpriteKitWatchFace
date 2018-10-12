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

// Adapted from https://www.particleincell.com/2013/cubic-line-intersection/
NSArray<NSValue *> *intersectionBetweenCubicCurveAndLine(CGPoint curvePointA, CGPoint curvePointB, CGPoint curvePointC, CGPoint curvePointD, CGPoint linePointA, CGPoint linePointB)
{
    CGFloat xAmB = linePointA.x - linePointB.x;
    CGFloat xBmA = linePointB.x - linePointA.x;
    CGFloat yAmB = linePointA.y - linePointB.y;
    CGFloat yBmA = linePointB.y - linePointA.y;
    CGFloat lineConstant = linePointA.x*yAmB + linePointA.y*xBmA;
    
    
    CGPoint bezierCoefficient0 = CGPointMake(-curvePointA.x + 3.*curvePointB.x - 3.*curvePointC.x + curvePointD.x,
                                             -curvePointA.y + 3.*curvePointB.y - 3.*curvePointC.y + curvePointD.y);
    
    CGPoint bezierCoefficient1 = CGPointMake(3.*curvePointA.x - 6.*curvePointB.x + 3.*curvePointC.x,
                                             3.*curvePointA.y - 6.*curvePointB.y + 3.*curvePointC.y);
    
    CGPoint bezierCoefficient2 = CGPointMake(-3.*curvePointA.x + 3.*curvePointB.x,
                                             -3.*curvePointA.y + 3.*curvePointB.y);
    
    CGPoint bezierCoefficient3 = CGPointMake(curvePointA.x,
                                             curvePointA.y);
    
    CGFloat polynomialCoefficient0 = yBmA*bezierCoefficient0.x + xAmB*bezierCoefficient0.y; // t^3
    CGFloat polynomialCoefficient1 = yBmA*bezierCoefficient1.x + xAmB*bezierCoefficient1.y; // t^2
    CGFloat polynomialCoefficient2 = yBmA*bezierCoefficient2.x + xAmB*bezierCoefficient2.y; // t^1
    CGFloat polynomialCoefficient3 = yBmA*bezierCoefficient3.x + xAmB*bezierCoefficient3.y + lineConstant; // t^0
    
    if (polynomialCoefficient0 == 0) return nil;
    
    CGFloat A = polynomialCoefficient1/polynomialCoefficient0;
    CGFloat B = polynomialCoefficient2/polynomialCoefficient0;
    CGFloat C = polynomialCoefficient3/polynomialCoefficient0;
    
    CGFloat Q = (3.*B - A*A)/9.;
    CGFloat R = (9.*A*B - 27*C - 2.*A*A*A)/54.;
    
    CGFloat discriminant = Q*Q*Q + R*R;
    
    // Possible roots
    CGFloat root0 = -1;
    CGFloat root1 = -1;
    CGFloat root2 = -1;
    
    if (discriminant >= 0) { // Complex or duplicate roots
        CGFloat S = ((R + sqrt(discriminant)) < 0 ? -1. : 1.)*pow(ABS(R + sqrt(discriminant)), 1./3.);
        CGFloat T = ((R - sqrt(discriminant)) < 0 ? -1. : 1.)*pow(ABS(R - sqrt(discriminant)), 1./3.);
        
        root0 = -A/3. + (S + T); // Real root
        root1 = -A/3. - (S + T)/2.; // real part of complex root
        root2 = -A/3. - (S + T)/2.; // real part of other complex root
        CGFloat complexComponent = ABS(sqrt(3.)*(S - T)/2.);
        
        if (complexComponent) { // We are uninterested in complex roots
            root1 = -1;
            root2 = -1;
        }
    } else { // distinct real roots
        CGFloat theta = acos(R/sqrt(-Q*Q*Q));
        
        root0 = 2.*sqrt(-Q)*cos(theta/3.) - A/3.;
        root1 = 2.*sqrt(-Q)*cos((theta + 2.*M_PI)/3.) - A/3.;
        root2 = 2.*sqrt(-Q)*cos((theta + 4.*M_PI)/3.) - A/3.;
    }
    
    NSMutableArray<NSNumber *> *roots = [[NSMutableArray alloc] init];
    
    if (root0 >= 0 && root0 <= 1) [roots addObject:@(root0)];
    if (root1 >= 0 && root1 <= 1) [roots addObject:@(root1)];
    if (root2 >= 0 && root2 <= 1) [roots addObject:@(root2)];
    
    NSMutableArray<NSValue *> *intersections = [[NSMutableArray alloc] init];
    
    for (NSNumber *root in roots) {
        CGFloat curveTime = root.doubleValue;
        CGFloat t = curveTime;
        
        CGPoint intersectionPoint = CGPointMake(t*t*t*bezierCoefficient0.x + t*t*bezierCoefficient1.x + t*bezierCoefficient2.x + bezierCoefficient3.x,
                                                t*t*t*bezierCoefficient0.y + t*t*bezierCoefficient1.y + t*bezierCoefficient2.y + bezierCoefficient3.y);
        
        CGFloat lineTime = 0;
        
        if (xBmA) {
            lineTime = (intersectionPoint.x - linePointA.x)/xBmA;
        } else {
            lineTime = (intersectionPoint.y - linePointA.y)/yBmA;
        }
    
        if (curveTime >= 0 && curveTime <= 1. && lineTime >= 0. && lineTime <= 1.)  {
            [intersections addObject:[NSValue valueWithPoint:intersectionPoint]];
        }
    }
    
    return intersections;
}

// Adapted from https://stackoverflow.com/a/565282/1565236
NSValue *intersectionBetweenLineAndLine(CGPoint line1PointA, CGPoint line1PointB, CGPoint line2PointA, CGPoint line2PointB)
{
    line1PointB.x -= line1PointA.x;
    line1PointB.y -= line1PointA.y;
    line2PointB.x -= line2PointA.x;
    line2PointB.y -= line2PointA.y;
    
    CGFloat denomenator = line1PointB.x*line2PointB.y - line1PointB.y*line2PointB.x;
    
    if (denomenator == 0) return nil; // lines are parallel/colinear // handle case when line1 is a point here? Or maybe not necessary
    
    CGPoint difference = CGPointMake(line2PointA.x - line1PointA.x,
                                   line2PointA.y - line1PointA.y);
    
    
    CGFloat line1Time = (difference.x*line2PointB.y - difference.y*line2PointB.x)/denomenator;
    CGFloat line2Time = (difference.x*line1PointB.y - difference.y*line1PointB.x)/denomenator;
    
    if (line1Time >= 0. && line1Time <= 1. && line2Time >= 0. && line2Time <= 1.) {
        CGPoint intersection = CGPointMake(line1PointA.x + line1Time*line1PointB.x,
                                           line1PointA.y + line1Time*line1PointB.y);
        
        return [NSValue valueWithPoint:intersection];
    } else {
        return nil;
    }

    return nil;
}

NSArray<NSValue *> *intersectionsBetweenPathAndLinePassingThroughPoints(CGPathRef path, CGPoint linePointA, CGPoint linePointB)
{
    NSMutableArray *intersections = [[NSMutableArray alloc] init];
    
    __block CGPoint firstPoint;
    __block CGPoint lastPoint;
    
    CGPathApplyWithBlock(path, ^(const CGPathElement * _Nonnull elementPointer) {
        CGPathElement element = *elementPointer;
        
        if (element.type == kCGPathElementMoveToPoint) {
            firstPoint = element.points[0];
            lastPoint = element.points[0];
        } else if (element.type == kCGPathElementAddLineToPoint) {
            // get intersection between both lines
            
            NSValue *localIntersection = intersectionBetweenLineAndLine(lastPoint, element.points[0], linePointA, linePointB);
            if (localIntersection) [intersections addObject:localIntersection];
            
            lastPoint = element.points[0];
        } else if (element.type == kCGPathElementAddQuadCurveToPoint) {
            // get intersection between line and quad curve
            
            // cheat for now
            NSValue *localIntersection = intersectionBetweenLineAndLine(lastPoint, element.points[1], linePointA, linePointB);
            if (localIntersection) [intersections addObject:localIntersection];
            
            lastPoint = element.points[1];
        } else if (element.type == kCGPathElementAddCurveToPoint) {
            // get intersection between line and cubic curve
            
            NSArray *localIntersections = intersectionBetweenCubicCurveAndLine(lastPoint, element.points[0], element.points[1], element.points[2], linePointA, linePointB);
            if (localIntersections.count) [intersections addObjectsFromArray:localIntersections];
            
            lastPoint = element.points[2];
        } else if (element.type == kCGPathElementCloseSubpath) {
            // get intersection between both lines
            
            NSValue *localIntersection = intersectionBetweenLineAndLine(lastPoint, firstPoint, linePointA, linePointB);
            if (localIntersection) [intersections addObject:localIntersection];
            
            lastPoint = firstPoint;
        }
    });
    
    if (intersections.count == 0) {
        NSLog(@"No intersections for %@ - %@", NSStringFromPoint(linePointA), NSStringFromPoint(linePointB));
    }
    
    return intersections;
}

CGPoint intersectionBetweenPathAndLinePassingThroughPoints(CGPathRef path, CGPoint linePointA, CGPoint linePointB)
{
    NSArray<NSValue *> *intersections = intersectionsBetweenPathAndLinePassingThroughPoints(path, linePointA, linePointB);
    
    return intersections.firstObject.pointValue;
}

@implementation FaceScene

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		
		self.theme = ThemeHermesPink;
		self.useProgrammaticLayout = YES;
		self.useRoundFace = NO;
		
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
    CGFloat cornerRadius = 34;
    
    CGFloat workingRadius = sqrt(faceSize.width/2.*faceSize.width/2. + faceSize.height/2.*faceSize.height/2.);
    CGFloat longTickHeight = round(faceSize.width/2./10.);
    CGFloat shortTickHeight = longTickHeight/2.;
    
    CGPathRef outerPath = CGPathCreateWithRoundedRect(CGRectMake(margin - faceSize.width/2., margin - faceSize.height/2., faceSize.width - margin*2., faceSize.height - margin*2.), cornerRadius - margin, cornerRadius - margin, NULL);
    
    CGPathRef largeTickInnerPath = CGPathCreateWithRoundedRect(CGRectMake(margin + longTickHeight - faceSize.width/2., margin + longTickHeight - faceSize.height/2., faceSize.width - margin*2. - longTickHeight*2., faceSize.height - margin*2. - longTickHeight*2.), cornerRadius - margin - longTickHeight, cornerRadius - margin - longTickHeight, NULL);
	
	for (int i = 0; i < 12; i++)
	{
        CGFloat angle = -(2*M_PI)/12.0 * i;
        
        CGAffineTransform rotation = CGAffineTransformMakeRotation(angle);
        
        CGPoint lineLeftPointA = CGPointApplyAffineTransform(CGPointMake(-1, 0), rotation);
        CGPoint lineLeftPointB = CGPointApplyAffineTransform(CGPointMake(-1, workingRadius), rotation);
        CGPoint lineRightPointA = CGPointApplyAffineTransform(CGPointMake(1, 0), rotation);
        CGPoint lineRightPointB = CGPointApplyAffineTransform(CGPointMake(1, workingRadius), rotation);
        
        CGPoint topLeft = intersectionBetweenPathAndLinePassingThroughPoints(outerPath, lineLeftPointA, lineLeftPointB);
        CGPoint topRight = intersectionBetweenPathAndLinePassingThroughPoints(outerPath, lineRightPointA, lineRightPointB);
        CGPoint bottomLeft = intersectionBetweenPathAndLinePassingThroughPoints(largeTickInnerPath, lineLeftPointA, lineLeftPointB);
        CGPoint bottomRight = intersectionBetweenPathAndLinePassingThroughPoints(largeTickInnerPath, lineRightPointA, lineRightPointB);
        
        CGMutablePathRef tickPath = CGPathCreateMutable();
        CGPathMoveToPoint(tickPath, NULL, topLeft.x, topLeft.y);
        CGPathAddLineToPoint(tickPath, NULL, topRight.x, topRight.y);
        CGPathAddLineToPoint(tickPath, NULL, bottomRight.x, bottomRight.y);
        CGPathAddLineToPoint(tickPath, NULL, bottomLeft.x, bottomLeft.y);
        CGPathCloseSubpath(tickPath);
        
        SKShapeNode *tick = [SKShapeNode shapeNodeWithPath:tickPath];
        tick.fillColor = self.markColor;
        tick.strokeColor = [SKColor clearColor];
        tick.position = CGPointZero;
        
        [self addChild:tick];
	}
    
    CGPathRelease(largeTickInnerPath);
	
	/* Minor */
    
    CGPathRef smallTickInnerPath = CGPathCreateWithRoundedRect(CGRectMake(margin + shortTickHeight - faceSize.width/2., margin + shortTickHeight - faceSize.height/2., faceSize.width - margin*2. - shortTickHeight*2., faceSize.height - margin*2. - shortTickHeight*2.), cornerRadius - margin - shortTickHeight, cornerRadius - margin - shortTickHeight, NULL);
    
    for (int i = 0; i < 60; i++)
    {
        if (i % 5 == 0) continue;

        CGFloat angle = - (2*M_PI)/60.0 * i;

        CGAffineTransform rotation = CGAffineTransformMakeRotation(angle);

        CGPoint lineLeftPointA = CGPointApplyAffineTransform(CGPointMake(-0.5, 0), rotation);
        CGPoint lineLeftPointB = CGPointApplyAffineTransform(CGPointMake(-0.5, workingRadius), rotation);
        CGPoint lineRightPointA = CGPointApplyAffineTransform(CGPointMake(0.5, 0), rotation);
        CGPoint lineRightPointB = CGPointApplyAffineTransform(CGPointMake(0.5, workingRadius), rotation);

        CGPoint topLeft = intersectionBetweenPathAndLinePassingThroughPoints(outerPath, lineLeftPointA, lineLeftPointB);
        CGPoint topRight = intersectionBetweenPathAndLinePassingThroughPoints(outerPath, lineRightPointA, lineRightPointB);
        CGPoint bottomLeft = intersectionBetweenPathAndLinePassingThroughPoints(smallTickInnerPath, lineLeftPointA, lineLeftPointB);
        CGPoint bottomRight = intersectionBetweenPathAndLinePassingThroughPoints(smallTickInnerPath, lineRightPointA, lineRightPointB);

        CGMutablePathRef tickPath = CGPathCreateMutable();
        CGPathMoveToPoint(tickPath, NULL, topLeft.x, topLeft.y);
        CGPathAddLineToPoint(tickPath, NULL, topRight.x, topRight.y);
        CGPathAddLineToPoint(tickPath, NULL, bottomRight.x, bottomRight.y);
        CGPathAddLineToPoint(tickPath, NULL, bottomLeft.x, bottomLeft.y);
        CGPathCloseSubpath(tickPath);

        SKShapeNode *tick = [SKShapeNode shapeNodeWithPath:tickPath];
        tick.fillColor = self.markColor;
        tick.strokeColor = [SKColor clearColor];
        tick.position = CGPointZero;

        [self addChild:tick];
    }
    
    CGPathRelease(outerPath);
    CGPathRelease(smallTickInnerPath);
	
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
