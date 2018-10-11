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
	ThemeLiquid
} Theme;

@interface FaceScene : SKScene <SKSceneDelegate>

@property Theme theme;

@property SKColor *lightColor;
@property SKColor *darkColor;
@property SKColor *handColor;
@property SKColor *inlayColor;
@property SKColor *markColor;
@property SKColor *textColor;

@property BOOL useProgrammaticLayout;
@property BOOL useRoundFace;

@end





NS_ASSUME_NONNULL_END
