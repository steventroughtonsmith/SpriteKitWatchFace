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
	NumeralStyleNone
} NumeralStyle;

typedef enum : NSUInteger {
	TickmarkStyleAll,
	TickmarkStyleMajor,
	TickmarkStyleMinor,
	TickmarkStyleNone
} TickmarkStyle;

@interface FaceScene : SKScene <SKSceneDelegate>

-(void)refreshTheme;

@property Theme theme;
@property NumeralStyle numeralStyle;
@property TickmarkStyle tickmarkStyle;

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

@property BOOL useProgrammaticLayout;
@property BOOL useRoundFace;
@property BOOL useMasking;
@property BOOL showDate;
@property BOOL showLogo;

@property CGSize faceSize;

@end





NS_ASSUME_NONNULL_END
