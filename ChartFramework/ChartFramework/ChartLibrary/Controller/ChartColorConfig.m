//
//  ChartColorConfig.m
//  ChartLibraryDemo
//
//  Created by william on 21/6/2021.
//  Copyright Â© 2021 william. All rights reserved.
//

#import "ChartColorConfig.h"

@implementation ChartColorConfig

+ (UIColor *)color255WithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:alpha];
}

+ (UIColor *)color255WithString:(NSString *)colorComma{
    if (colorComma && [colorComma length] >0){
        NSArray * colorAry = [colorComma componentsSeparatedByString:@","];
        if (colorAry && [colorAry count] >= 3){
            CGFloat alpha = 1;
            if ([colorAry count] >= 4){
                alpha = [[colorAry objectAtIndex:3] doubleValue];
            }
            return [self color255WithRed:[[colorAry objectAtIndex:0] doubleValue] green:[[colorAry objectAtIndex:1] doubleValue] blue:[[colorAry objectAtIndex:2] doubleValue] alpha:alpha];
        }
    }
    return [UIColor blackColor];
}

+ (CGFloat)floatFromHexColor:(NSString *)colorCode{
    const NSArray * hexList = @[@"0",@"1", @"2", @"3",@"4",@"5",@"6",@"7",@"8",@"9",@"A",@"B",@"C",@"D",@"E",@"F"];
    if (colorCode && [colorCode length] == 2){
        CGFloat value = 0.f;
        NSString * digit10 = [colorCode substringToIndex:1];
        NSString * digit1 = [colorCode substringFromIndex:1];
        
        NSInteger digit10Int = [hexList indexOfObject:digit10];
        NSInteger digit1Int = [hexList indexOfObject:digit1];
        if (digit10Int != NSNotFound && digit1Int != NSNotFound ){
            value += digit10Int * 16;
            value += digit1Int;
        }
        return value;
    }
    return 0.f;
}

+ (UIColor *)colorHexString:(NSString *)hexColor{
    if (hexColor && [hexColor length] >= 6){
        if ([[hexColor substringToIndex:1] isEqualToString:@"#"]){
            hexColor = [hexColor substringFromIndex:1];
        }
        CGFloat red = 0.f;
        CGFloat green = 0.f;
        CGFloat blue = 0.f;
        CGFloat alpha = 1.f;
        NSString * redString = [hexColor substringWithRange:NSMakeRange(0, 2)];
        NSString * greenString = [hexColor substringWithRange:NSMakeRange(2, 2)];
        NSString * blueString = [hexColor substringWithRange:NSMakeRange(4, 2)];
        
        red = [self floatFromHexColor:redString];
        green = [self floatFromHexColor:greenString];
        blue = [self floatFromHexColor:blueString];
        
        if ([hexColor length] >= 8){
            NSString * alphaString = [hexColor substringWithRange:NSMakeRange(8, 2)];
            alpha = [self floatFromHexColor:alphaString];
        }
        return [self color255WithRed:red green:green blue:blue alpha:alpha/255.f];
        
    }
    return [UIColor blackColor];
//    return [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:alpha];
}

- (void)applyDefaultDarkConfig {
    self.chartBackgroundColor   = [ChartColorConfig color255WithRed:10.f green:15.f blue:30.f alpha:1.f];
    self.axisTextColor          = [ChartColorConfig color255WithRed:255.f green:255.f blue:255.f alpha:1.f];
    self.axisLineColor          = [ChartColorConfig color255WithRed:102.f green:102.f blue:102.f alpha:1.f];
    self.axisBackgroundColor    = [ChartColorConfig color255WithRed:26.f green:26.f blue:26.f alpha:1.f];
    self.chartBottomLineColor   = [UIColor clearColor];
    
    self.cursorLineColor        = [ChartColorConfig color255WithRed:255.f green:255.f blue:255.f alpha:1.f];
    
    self.mainCandleUpColor      = [ChartColorConfig color255WithRed:255.f green:27.f blue:86.f alpha:1.f];
    self.mainCandleDownColor    = [ChartColorConfig color255WithRed:0.f green:180.f blue:211.f alpha:1.f];
    self.mainLineColor          = [ChartColorConfig color255WithRed:162.f green:252.f blue:233.f alpha:1.f];
//    self.mainBarUpColor           = [ChartColorConfig color255WithRed:162.f green:252.f blue:233.f alpha:1.f];
//    self.mainBarDownColor           = [ChartColorConfig color255WithRed:162.f green:252.f blue:233.f alpha:1.f];
    self.mainBarUpColor      = [ChartColorConfig color255WithRed:255.f green:27.f blue:86.f alpha:1.f];
    self.mainBarDownColor    = [ChartColorConfig color255WithRed:0.f green:180.f blue:211.f alpha:1.f];
//    self.mainAreaLineColor      = [ChartColorConfig color255WithString:@"0,180,220"];
    self.mainAreaLineColor      = [ChartColorConfig color255WithRed:15.f green:121.f blue:191.f alpha:1.f];

    self.mainAreaFillTopColor   = [ChartColorConfig color255WithRed:207.f green:235.f blue:241.f alpha:0.84f];
    self.mainAreaFillMainColor  = [ChartColorConfig color255WithRed:255.f green:255.f blue:255.f alpha:0.84f];

    
    self.tiSMAColorList = @[
        [ChartColorConfig color255WithRed:255.f green:125.f blue:0.f alpha:1.f],
        [ChartColorConfig color255WithRed:204.f green:90.f blue:255.f alpha:1.f],
        [ChartColorConfig color255WithRed:255.f green:216.f blue:0.f alpha:1.f],
        [ChartColorConfig color255WithRed:70.f green:255.f blue:20.f alpha:1.f]
    ];
    
    self.tiWMAColorList = @[
        [ChartColorConfig color255WithRed:255.f green:125.f blue:0.f alpha:1.f],
        [ChartColorConfig color255WithRed:204.f green:90.f blue:255.f alpha:1.f],
        [ChartColorConfig color255WithRed:255.f green:216.f blue:0.f alpha:1.f],
        [ChartColorConfig color255WithRed:70.f green:255.f blue:20.f alpha:1.f]
    ];
    
    self.tiEMAColorList = @[
        [ChartColorConfig color255WithRed:255.f green:125.f blue:0.f alpha:1.f],
        [ChartColorConfig color255WithRed:204.f green:90.f blue:255.f alpha:1.f],
        [ChartColorConfig color255WithRed:255.f green:216.f blue:0.f alpha:1.f],
        [ChartColorConfig color255WithRed:70.f green:255.f blue:20.f alpha:1.f]
    ];
    
    self.tiBBUpper          = [ChartColorConfig color255WithString:@"0,180,211"];
    self.tiBBLower          = [ChartColorConfig color255WithString:@"0,180,211"];
    self.tiBBMiddle         = [ChartColorConfig color255WithString:@"255,27,86"];
    
    self.tiDmiADI           = [ChartColorConfig color255WithString:@"0,180,211"];
    self.tiDmiBDI           = [ChartColorConfig color255WithString:@"255,27,86"];
    self.tiDmiADX           = [ChartColorConfig color255WithString:@"255,216,0"];
    self.tiDmiADXR          = [ChartColorConfig color255WithString:@"125,168,0"];
    
    self.tiSAR              = [ChartColorConfig color255WithString:@"70,255,20"];
    
    self.tiMACD1            = [ChartColorConfig color255WithString:@"0,180,211"];
    self.tiMACD2            = [ChartColorConfig color255WithString:@"255,27,86"];
    self.tiMACDZero         = [ChartColorConfig color255WithString:@"255,255,255"];
    self.tiMACDAboveDiff    = [ChartColorConfig color255WithString:@"255,27,86"];
    self.tiMACDBelowDiff    = [ChartColorConfig color255WithString:@"0,180,211"];
    
    self.tiRSIRSI           = [ChartColorConfig color255WithString:@"0,180,211"];
    self.tiRSISMA           = [ChartColorConfig color255WithString:@"255,27,86"];
    
    self.tiWillWill         = [ChartColorConfig color255WithString:@"0,180,211"];
    self.tiWillSMA          = [ChartColorConfig color255WithString:@"255,27,86"];
    
    self.tiSTCFastK         = [ChartColorConfig color255WithString:@"0,180,211"];
    self.tiSTCFastD         = [ChartColorConfig color255WithString:@"255,27,86"];
    
    self.tiSTCSlowK         = [ChartColorConfig color255WithString:@"0,180,211"];
    self.tiSTCSlowD         = [ChartColorConfig color255WithString:@"255,27,86"];
    
    self.tiOBV              = [ChartColorConfig color255WithString:@"0,180,211"];
    
    self.tiMOM              = [ChartColorConfig color255WithString:@"255,153,0"];
    
    self.tiROC              = [ChartColorConfig color255WithString:@"0,180,211"];
    self.tiROCAvg           = [ChartColorConfig color255WithString:@"255,255,255"];
    
    //self.tiVol =
    self.tiVolSma           = [ChartColorConfig color255WithString:@"70,255,20"];
    self.tiVolUp            = [ChartColorConfig color255WithString:@"255,27,86"];
    self.tiVolDown          = [ChartColorConfig color255WithString:@"0,180,211"];
    
    self.ohlcBGColor        = [ChartColorConfig color255WithString:@"51,51,51"];
    self.ohlcTitle          = [ChartColorConfig color255WithString:@"255,255,255"];
    self.ohlcVal            = [ChartColorConfig color255WithString:@"0,207,235"];
    self.dateColor          = [ChartColorConfig color255WithString:@"255,255,255"];
    
    self.sessionPreBGColor   = [ChartColorConfig color255WithRed:246 green:152 blue:3 alpha:0.2];
    self.sessionPostBGColor  = [ChartColorConfig color255WithRed:42 green:98 blue:255 alpha:0.2];
    
    self.tiFutureCandleUp      = [ChartColorConfig color255WithRed:255.f green:27.f blue:86.f alpha:1.f];
    self.tiFutureCandleDown    = [ChartColorConfig color255WithRed:0.f green:180.f blue:211.f alpha:1.f];

    self.minValColor    = [UIColor orangeColor];
    self.maxValColor    = [UIColor orangeColor];
    
    self.selectDataColor = [UIColor blackColor];
    self.selectDataBGColor = [UIColor whiteColor];
}

- (void)applyDefaultLightConfig {
    self.chartBackgroundColor   = [ChartColorConfig color255WithRed:255.f green:255.f blue:255.f alpha:1.f];
    self.axisTextColor          = [ChartColorConfig color255WithRed:0.f green:0.f blue:0.f alpha:1.f];
    self.axisLineColor          = [ChartColorConfig color255WithRed:102.f green:102.f blue:102.f alpha:1.f];
    self.axisBackgroundColor    = [ChartColorConfig color255WithRed:230.f green:230.f blue:230.f alpha:1.f];
    self.chartBottomLineColor   = [UIColor clearColor];
    
    self.cursorLineColor        = [ChartColorConfig color255WithRed:125.f green:125.f blue:125.f alpha:1.f];
    
    self.mainCandleUpColor      = [ChartColorConfig color255WithRed:204.f green:0.f blue:0.f alpha:1.f];
    self.mainCandleDownColor    = [ChartColorConfig color255WithRed:16.f green:84.f blue:169.f alpha:1.f];
    self.mainLineColor          = [ChartColorConfig color255WithRed:0.f green:161.f blue:189.f alpha:1.f];

//    self.mainBarUpColor           = [ChartColorConfig color255WithRed:0.f green:161.f blue:189.f alpha:1.f];
//    self.mainBarDownColor           = [ChartColorConfig color255WithRed:0.f green:161.f blue:189.f alpha:1.f];
    self.mainBarUpColor      = [ChartColorConfig color255WithRed:204.f green:0.f blue:0.f alpha:1.f];
    self.mainBarDownColor    = [ChartColorConfig color255WithRed:16.f green:84.f blue:169.f alpha:1.f];
//    self.mainAreaLineColor      = [ChartColorConfig color255WithRed:175.f green:221.f blue:232.f alpha:1.f];
//    self.mainAreaLineColor      = [ChartColorConfig color255WithString:@"0,161,189"];
    
    self.mainAreaLineColor      = [ChartColorConfig color255WithRed:15.f green:121.f blue:191.f alpha:1.f];
    self.mainAreaFillTopColor   = [ChartColorConfig color255WithRed:207.f green:235.f blue:241.f alpha:0.84f];
    self.mainAreaFillMainColor  = [ChartColorConfig color255WithRed:255.f green:255.f blue:255.f alpha:0.84f];
    
    self.tiSMAColorList = @[
        [ChartColorConfig color255WithRed:204.f green:0.f blue:0.f alpha:1.f],
        [ChartColorConfig color255WithRed:16.f green:84.f blue:169.f alpha:1.f],
        [ChartColorConfig color255WithRed:244.f green:121.f blue:32.f alpha:1.f],
        [ChartColorConfig color255WithRed:125.f green:168.f blue:0.f alpha:1.f]
    ];
    
    self.tiWMAColorList = @[
        [ChartColorConfig color255WithRed:204.f green:0.f blue:0.f alpha:1.f],
        [ChartColorConfig color255WithRed:16.f green:84.f blue:169.f alpha:1.f],
        [ChartColorConfig color255WithRed:244.f green:121.f blue:32.f alpha:1.f],
        [ChartColorConfig color255WithRed:125.f green:168.f blue:0.f alpha:1.f]
    ];
    
    self.tiEMAColorList = @[
        [ChartColorConfig color255WithRed:204.f green:0.f blue:0.f alpha:1.f],
        [ChartColorConfig color255WithRed:16.f green:84.f blue:169.f alpha:1.f],
        [ChartColorConfig color255WithRed:244.f green:121.f blue:32.f alpha:1.f],
        [ChartColorConfig color255WithRed:125.f green:168.f blue:0.f alpha:1.f]
    ];
    
    self.tiBBUpper          = [ChartColorConfig color255WithString:@"164,84,169"];
    self.tiBBLower          = [ChartColorConfig color255WithString:@"164,84,169"];
    self.tiBBMiddle         = [ChartColorConfig color255WithString:@"204,0,0"];
    
    self.tiDmiADI           = [ChartColorConfig color255WithString:@"16,84,169"];
    self.tiDmiBDI           = [ChartColorConfig color255WithString:@"204,0,0"];
    self.tiDmiADX           = [ChartColorConfig color255WithString:@"244,121,32"];
    self.tiDmiADXR          = [ChartColorConfig color255WithString:@"70,255,20"];
    
    self.tiSAR              = [ChartColorConfig color255WithString:@"125,168,0"];
    
    self.tiMACD1            = [ChartColorConfig color255WithString:@"16,84,169"];
    self.tiMACD2            = [ChartColorConfig color255WithString:@"204,0,0"];
    self.tiMACDZero         = [ChartColorConfig color255WithString:@"0,0,0"];
    self.tiMACDAboveDiff    = [ChartColorConfig color255WithString:@"204,0,0"];
    self.tiMACDBelowDiff    = [ChartColorConfig color255WithString:@"16,84,169"];
    
    self.tiRSIRSI           = [ChartColorConfig color255WithString:@"16,84,169"];
    self.tiRSISMA           = [ChartColorConfig color255WithString:@"204,0,0"];

    self.tiWillWill         = [ChartColorConfig color255WithString:@"16,84,169"];
    self.tiWillSMA          = [ChartColorConfig color255WithString:@"204,0,0"];
    
    self.tiSTCFastK         = [ChartColorConfig color255WithString:@"16,84,169"];
    self.tiSTCFastD         = [ChartColorConfig color255WithString:@"204,0,0"];
    
    self.tiSTCSlowK         = [ChartColorConfig color255WithString:@"16,84,169"];
    self.tiSTCSlowD         = [ChartColorConfig color255WithString:@"204,0,0"];
    
    self.tiOBV              = [ChartColorConfig color255WithString:@"16,84,169"];
    
    self.tiMOM              = [ChartColorConfig color255WithString:@"255,153,0"];
    
    self.tiROC              = [ChartColorConfig color255WithString:@"16,84,169"];
    self.tiROCAvg           = [ChartColorConfig color255WithString:@"0,0,0"];
    
//    self.tiVol =
    self.tiVolSma           = [ChartColorConfig color255WithString:@"125,168,0"];
    self.tiVolUp            = [ChartColorConfig color255WithString:@"204,0,0"];
    self.tiVolDown          = [ChartColorConfig color255WithString:@"16,84,169"];

    self.ohlcBGColor        = [ChartColorConfig color255WithString:@"255,255,255"];
    self.ohlcTitle          = [ChartColorConfig color255WithString:@"20,38,71"];
    self.ohlcVal            = [ChartColorConfig color255WithString:@"0,122,255"];
    self.dateColor          = [ChartColorConfig color255WithString:@"0,0,0"];
    
    self.sessionPreBGColor   = [ChartColorConfig color255WithRed:246 green:152 blue:3 alpha:0.2];
    self.sessionPostBGColor  = [ChartColorConfig color255WithRed:42 green:98 blue:255 alpha:0.2];
    
    self.tiFutureCandleUp      = [ChartColorConfig color255WithRed:204.f green:0.f blue:0.f alpha:1.f];
    self.tiFutureCandleDown    = [ChartColorConfig color255WithRed:16.f green:84.f blue:169.f alpha:1.f];
    
    self.minValColor    = [UIColor orangeColor];
    self.maxValColor    = [UIColor orangeColor];
    
    self.selectDataColor = [UIColor whiteColor];
    self.selectDataBGColor = [UIColor blackColor];
}

+ (ChartColorConfig *)getColorConfigForColorType:(ChartColorTypeSelection)colorType {
    ChartColorConfig *config = [self defaultLightConfig];
    
    if (colorType == ChartColorTypeSelectionLight) {
        config = [self defaultLightConfig];
    } else if (colorType == ChartColorTypeSelectionDark) {
        config = [self defaultDarkConfig];
    }
    
    return config;
}

+ (ChartColorConfig *)defaultLightConfig {
    static ChartColorConfig * lightConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lightConfig = [[ChartColorConfig alloc] init];
        // Do any other initialisation stuff here
        [lightConfig applyDefaultLightConfig];
    });
    return lightConfig;
}

+ (ChartColorConfig *)defaultDarkConfig {
    static ChartColorConfig * darkConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        darkConfig = [[ChartColorConfig alloc] init];
        // Do any other initialisation stuff here
        [darkConfig applyDefaultDarkConfig];
    });
    return darkConfig;
}

@end
