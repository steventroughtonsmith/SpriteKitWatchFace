//
//  FaceScene.h
//  SpriteKitWatchFace
//
//  Created by Steven Troughton-Smith on 10/10/2018.
//  Copyright © 2018 Steven Troughton-Smith. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
	ThemeHermesPink,
	ThemeHermesOrange,
	ThemeNavy,
	ThemeTidepod,
	ThemeBretonnia,
	ThemeNoir,
	ThemeContrast,
	ThemeVictoire,
	ThemeLiquid,
	ThemeAngler,
	ThemeSculley,
	ThemeKitty,
	ThemeDelay,
	ThemeDiesel,
	ThemeLuxe,
	ThemeSage,
	ThemeBondi,
	ThemeTangerine,
	ThemeStrawberry,
	ThemePawn,
	ThemeRoyal,
	ThemeMarques,
	ThemeVox,
	ThemeSummer,
	ThemeMAX
} Theme;

typedef enum : NSUInteger {
	NumeralStyleAll,
	NumeralStyleCardinal,
	NumeralStyleNone,
	NumeralStyleMAX
} NumeralStyle;

typedef enum : NSUInteger {
	TickmarkStyleAll,
	TickmarkStyleMajor,
	TickmarkStyleMinor,
	TickmarkStyleStackMajor,
	TickmarkStyleNone,
	TickmarkStyleMAX
} TickmarkStyle;

typedef enum : NSUInteger {
	FaceStyleRound,
	FaceStyleRectangular,
	FaceStyleMAX
} FaceStyle;

typedef enum : NSUInteger {
	ColorRegionStyleNone,
	ColorRegionStyleDynamicDuo,
	ColorRegionStyleHalf,
	ColorRegionStyleCircle,
	ColorRegionStyleRing,
	ColorRegionStyleMAX
} ColorRegionStyle;

typedef enum : NSUInteger {
	TickmarkShapeRectangular,
	TickmarkShapeCircular,
	TickmarkShapeTriangular,
	TickmarkShapeMAX
} TickmarkShape;

typedef enum : NSUInteger {
	DateStyleNone,
	DateStyleDay,
	DateStyleDate,
	DateStyleDayDate,
	DateStyleMAX
} DateStyle;

typedef enum : NSUInteger {
	DateQuadrantRight,
	DateQuadrantBottom,
	DateQuadrantLeft,
	DateQuadrantTop,
	DateQuadrantMAX
} DateQuadrant;

typedef enum : NSUInteger {
	CenterDiscStyleNone,
	CenterDiscStyleEnabled,
	CenterDiscStyleMAX,
} CenterDiscStyle;

@interface FaceScene : SKScene <SKSceneDelegate>

-(void)refreshTheme;

@property Theme theme;
@property NumeralStyle numeralStyle;
@property TickmarkStyle tickmarkStyle;
@property TickmarkShape majorTickmarkShape;
@property TickmarkShape minorTickmarkShape;
@property FaceStyle faceStyle;
@property ColorRegionStyle colorRegionStyle;
@property DateStyle dateStyle;
@property DateQuadrant dateQuadrant;
@property CenterDiscStyle centerDiscStyle;

@property SKColor *colorRegionColor;
@property SKColor *faceBackgroundColor;
@property SKColor *handColor;
@property SKColor *secondHandColor;
@property SKColor *inlayColor;

@property SKColor *majorMarkColor;
@property SKColor *minorMarkColor;
@property SKColor *textColor;

@property SKColor *alternateMajorMarkColor;
@property SKColor *alternateMinorMarkColor;
@property SKColor *alternateTextColor;

@property NSString *monogram;

@property BOOL useBackgroundImageOverlay;
@property BOOL useMasking;

@property BOOL showLogo;

@property CGSize faceSize;

@property CGFloat majorTickHeight;
@property CGFloat majorTickWidth;
@property CGFloat minorTickHeight;

@end





NS_ASSUME_NONNULL_END
