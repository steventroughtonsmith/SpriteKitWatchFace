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
	ThemeLuxe
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

@property Theme theme;
@property NumeralStyle numeralStyle;
@property TickmarkStyle tickmarkStyle;

@property SKColor *lightColor;
@property SKColor *darkColor;
@property SKColor *handColor;
@property SKColor *secondHandColor;
@property SKColor *inlayColor;
@property SKColor *majorMarkColor;
@property SKColor *minorMarkColor;

@property SKColor *textColor;

@property BOOL useProgrammaticLayout;
@property BOOL useRoundFace;

@property CGSize majorMarkSize;
@property CGSize minorMarkSize;

@end





NS_ASSUME_NONNULL_END
