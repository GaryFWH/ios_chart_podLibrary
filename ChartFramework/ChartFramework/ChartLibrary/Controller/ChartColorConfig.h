//
//  ChartColorConfig.h
//  ChartLibraryDemo
//
//  Created by william on 21/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ChartConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChartColorConfig : NSObject

@property(nonatomic, strong) UIColor * axisTextColor;
@property(nonatomic, strong) UIColor * axisLineColor;
@property(nonatomic, strong) UIColor * axisBackgroundColor;
@property(nonatomic, strong) UIColor * chartBackgroundColor;
@property(nonatomic, strong) UIColor * chartBottomLineColor;

@property(nonatomic, strong) UIColor * cursorLineColor;
    
@property(nonatomic, strong) UIColor * mainLineColor;
@property(nonatomic, strong) UIColor * mainCandleUpColor;
@property(nonatomic, strong) UIColor * mainCandleDownColor;
@property(nonatomic, strong) UIColor * mainBarUpColor;
@property(nonatomic, strong) UIColor * mainBarDownColor;
@property(nonatomic, strong) UIColor * mainAreaLineColor;
@property(nonatomic, strong) UIColor * mainAreaFillTopColor;
@property(nonatomic, strong) UIColor * mainAreaFillMainColor;

@property(nonatomic, strong) NSArray * tiSMAColorList;
@property(nonatomic, strong) NSArray * tiEMAColorList;
@property(nonatomic, strong) NSArray * tiWMAColorList;

@property(nonatomic, strong) UIColor * tiBBUpper;
@property(nonatomic, strong) UIColor * tiBBMiddle;
@property(nonatomic, strong) UIColor * tiBBLower;

@property(nonatomic, strong) UIColor * tiSAR;

@property(nonatomic, strong) UIColor * tiDmiADI;
@property(nonatomic, strong) UIColor * tiDmiBDI;
@property(nonatomic, strong) UIColor * tiDmiADX;
@property(nonatomic, strong) UIColor * tiDmiADXR;

@property(nonatomic, strong) UIColor * tiMACD1;
@property(nonatomic, strong) UIColor * tiMACD2;
@property(nonatomic, strong) UIColor * tiMACDZero;
@property(nonatomic, strong) UIColor * tiMACDAboveDiff;
@property(nonatomic, strong) UIColor * tiMACDBelowDiff;

@property(nonatomic, strong) UIColor * tiRSIRSI;
@property(nonatomic, strong) UIColor * tiRSISMA;

@property(nonatomic, strong) UIColor * tiWillWill;
@property(nonatomic, strong) UIColor * tiWillSMA;

@property(nonatomic, strong) UIColor * tiSTCFastK;
@property(nonatomic, strong) UIColor * tiSTCFastD;

@property(nonatomic, strong) UIColor * tiSTCSlowK;
@property(nonatomic, strong) UIColor * tiSTCSlowD;

@property(nonatomic, strong) UIColor * tiOBV;

@property(nonatomic, strong) UIColor * tiMOM;

@property(nonatomic, strong) UIColor * tiROC;
@property(nonatomic, strong) UIColor * tiROCAvg;

@property(nonatomic, strong) UIColor * tiVol;
@property(nonatomic, strong) UIColor * tiVolSma;
@property(nonatomic, strong) UIColor * tiVolUp;
@property(nonatomic, strong) UIColor * tiVolDown;

@property(nonatomic, strong) UIColor * tiFutureCandleUp;
@property(nonatomic, strong) UIColor * tiFutureCandleDown;

@property(nonatomic, strong) UIColor * ohlcBGColor;
@property(nonatomic, strong) UIColor * ohlcVal;
@property(nonatomic, strong) UIColor * ohlcTitle;
@property(nonatomic, strong) UIColor * dateColor;

@property(nonatomic, strong) UIColor * sessionPreBGColor;
@property(nonatomic, strong) UIColor * sessionPostBGColor;

@property(nonatomic, strong) UIColor * minValColor;
@property(nonatomic, strong) UIColor * maxValColor;

@property(nonatomic, strong) UIColor * selectDataColor;
@property(nonatomic, strong) UIColor * selectDataBGColor;

+ (UIColor *)color255WithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
+ (UIColor *)color255WithString:(NSString *)colorComma;
+ (CGFloat)floatFromHexColor:(NSString *)colorCode;
+ (UIColor *)colorHexString:(NSString *)hexColor;

+ (ChartColorConfig *)getColorConfigForColorType:(ChartColorTypeSelection)colorType;
+ (ChartColorConfig *)defaultLightConfig;
+ (ChartColorConfig *)defaultDarkConfig;

- (void)applyDefaultLightConfig;
- (void)applyDefaultDarkConfig;


@end

NS_ASSUME_NONNULL_END
