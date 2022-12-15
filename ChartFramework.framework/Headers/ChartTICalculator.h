//
//  ChartTICalculator.h
//  ChartLibraryDemo
//
//  Created by william on 29/7/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChartTIConfig.h"
#import "ChartData.h"

NS_ASSUME_NONNULL_BEGIN

#define kChartCalState @"state"
#define kChartCalData @"data"

#define kChartCalOHLC @"ohlc"
#define kChartCalOHLCOpen @"open"
#define kChartCalOHLCClose @"close"
#define kChartCalOHLCHigh @"high"
#define kChartCalOHLCLow @"low"
#define kChartCalOHLCVolume @"volume"
#define kChartCalOHLCTime @"time"

#define kChartCalMainTi @"mainTi"
#define kChartCalMainTiSMA @"SMA"
#define kChartCalMainTiEMA @"EMA"
#define kChartCalMainTiWMA @"WMA"
#define kChartCalMainTiBB @"BB"
#define kChartCalMainTiSAR @"SAR"

#define kChartCalMainTiStateMAPeriod @"timePeriod"
#define kChartCalMainTiStateBBStd @"standardDeviation"
#define kChartCalMainTiStateBBPeriod @"timePeriod"
#define kChartCalMainTiStateSARAcc @"accelerationFactor"
#define kChartCalMainTiStateSARMaxAcc @"maxAccelerationFactor"
#define kChartCalMainTiDataSMA @"SMA#"
#define kChartCalMainTiDataWMA @"WMA#"
#define kChartCalMainTiDataEMA @"EMA#"
#define kChartCalMainTiDataBBUpper @"Upper BB"
#define kChartCalMainTiDataBBMiddle @"Middle BB"
#define kChartCalMainTiDataBBLower @"Lower BB"
#define kChartCalMainTiDataSARSAR @"SAR"

#define kChartCalExtraTi @"extraTi"
#define kChartCalExtraTiMACD @"MACD"
#define kChartCalExtraTiDMI @"DMI"
#define kChartCalExtraTiRSI @"RSI"
#define kChartCalExtraTiSTCSlow @"STC_SLOW"
#define kChartCalExtraTiSTCFast @"STC_FAST"
#define kChartCalExtraTiVOL @"VOL"
#define kChartCalExtraTiROC @"ROC"
#define kChartCalExtraTiWill @"WILL_R"
#define kChartCalExtraTiOBV @"OBV"

#define kChartCalExtraTiStateMACD1 @"timePeriod1"
#define kChartCalExtraTiStateMACD2 @"timePeriod2"
#define kChartCalExtraTiStateMACDDiff @"diff"
#define kChartCalExtraTiDataMACD1 @"MACD1"
#define kChartCalExtraTiDataMACD2 @"MACD2"
#define kChartCalExtraTiDataMACDDiff @"diff"

#define kChartCalExtraTiStateDMI @"timePeriod"
#define kChartCalExtraTiDataDMIpDI @"+DI"
#define kChartCalExtraTiDataDMInDI @"-DI"
#define kChartCalExtraTiDataDMIADX @"ADX"
#define kChartCalExtraTiDataDMIADXR @"ADXR"

#define kChartCalExtraTiStateRSIPeriod @"timePeriod"
#define kChartCalExtraTiStateRSISMA @"timePeriodSma"
#define kChartCalExtraTiDataRSIRSI @"RSI"
#define kChartCalExtraTiDataRSISMA @"SMA"

#define kChartCalExtraTiStateSTCSlowK @"timePeriodK"
#define kChartCalExtraTiStateSTCSlowD @"timePeriodD"
#define kChartCalExtraTiDataSTCSlowK @"%SK"
#define kChartCalExtraTiDataSTCSlowD @"%SD"

#define kChartCalExtraTiStateSTCFastK @"timePeriodK"
#define kChartCalExtraTiStateSTCFastD @"timePeriodD"
#define kChartCalExtraTiDataSTCFastK @"%K"
#define kChartCalExtraTiDataSTCFastD @"%D"

#define kChartCalExtraTiStateVOL @"timePeriodSma"
#define kChartCalExtraTiDataVOL @"VOL"
#define kChartCalExtraTiDataVOLSMA @"SMA"

#define kChartCalExtraTiStateROC @"timePeriod"
#define kChartCalExtraTiDataROC @"ROC"

#define kChartCalExtraTiStateWillPeriod @"timePeriod"
#define kChartCalExtraTiStateWillPeriodSMA @"timePeriodSma"
#define kChartCalExtraTiDataWillR @"Williams %R"
#define kChartCalExtraTiDataWillSma @"SMA"

#define kChartCalExtraTiStateOBV @"isUseWeightedClosingPrice"
#define kChartCalExtraTiDataOBV @"OBV"

@interface ChartTICalculator : NSObject

+ (NSDictionary *)getDictionaryFromChartConfig:(ChartTIConfig *)config forChartData:(NSArray<ChartData *> *)dataList;

@end

NS_ASSUME_NONNULL_END
