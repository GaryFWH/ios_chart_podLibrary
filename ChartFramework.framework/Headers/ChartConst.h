//
//  ChartConst.h
//  ChartLibraryDemo
//
//  Created by william on 13/4/2021.
//  Copyright Â© 2021 william. All rights reserved.
//

#define CHARTTEXTBOXINFOHEIGHT 13.8f

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, ChartLineType){
    ChartLineTypeCandle,
    ChartLineTypeLine,
    ChartLineTypeArea,
    ChartLineTypeBar,
    ChartLineTypeHisto,
};

typedef NS_ENUM(NSInteger, ChartDataDisplayType){
    ChartDataDisplayTypeOpen,
    ChartDataDisplayTypeClose,
    ChartDataDisplayTypeHigh,
    ChartDataDisplayTypeLow,
    ChartDataDisplayTypeVolume,
};

typedef NS_ENUM(NSUInteger, ChartMainTIEnum){
    ChartMainTINone,
    ChartMainTIEnumSMA,
    ChartMainTIEnumWMA,
    ChartMainTIEnumEMA,
    ChartMainTIEnumBB,
    ChartMainTIEnumSAR,
    ChartMainTITotalCount,
    ChartMainTIUnknown
};

typedef NS_ENUM(NSUInteger, ChartSubTIEnum){
    ChartSubTIEnumDMI,
    ChartSubTIEnumMACD,
    ChartSubTIEnumOBV,
    ChartSubTIEnumROC,
    ChartSubTIEnumRSI,
    ChartSubTIEnumSTCFast,
    ChartSubTIEnumSTCSlow,
    ChartSubTIEnumVOL,
    ChartSubTIEnumWill,
    ChartSubTITotalCount,
    ChartSubTIUnknown
};

typedef NS_ENUM(NSUInteger, ChartSessionType){
    ChartSessionTypeCore = 0,
    ChartSessionTypePre,
    ChartSessionTypePost,
    ChartSessionTypeCombine,
};

typedef NS_ENUM(NSInteger, ChartColorTypeSelection)
{
    ChartColorTypeSelectionLight   = 0,
    ChartColorTypeSelectionDark    = 1
};

typedef NS_ENUM(NSUInteger, ChartAxisLineType){
    ChartAxisLineTypeSolid = 0,
    ChartAxisLineTypeDash,
};

typedef NS_ENUM(NSUInteger, ChartYAxisGapType){
    ChartYAxisGapTypePixel = 0,
    ChartYAxisGapTypeScale,
};

