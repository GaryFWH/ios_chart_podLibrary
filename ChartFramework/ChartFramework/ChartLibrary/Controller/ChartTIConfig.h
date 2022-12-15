//
//  ChartTIConfig.h
//  ChartLibraryDemo
//
//  Created by william on 25/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ChartConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChartTIConfig : NSObject

@property (nonatomic, assign) ChartMainTIEnum selectedMainTI;
@property (nonatomic, strong) NSArray * selectedSubTI;

@property (nonatomic, strong) NSArray * tiSMADayList;
@property (nonatomic, strong) NSArray * tiWMADayList;
@property (nonatomic, strong) NSArray * tiEMADayList;

@property (nonatomic, assign) NSInteger tiBBIntervals;
@property (nonatomic, assign) CGFloat tiBBStdDev;

@property (nonatomic, assign) CGFloat tiSARaccFactor;
@property (nonatomic, assign) CGFloat tiSARmaxAccFactor;

@property (nonatomic, assign) NSInteger tiDMIInterval;
@property (nonatomic, assign) NSInteger tiDMIADXRShow;

@property (nonatomic, assign) NSInteger tiMACDMACD1;
@property (nonatomic, assign) NSInteger tiMACDMACD2;
@property (nonatomic, assign) NSInteger tiMACDDiff;

@property (nonatomic, assign) BOOL tiOBVisWeighted;

@property (nonatomic, assign) NSInteger tiROCIntervals;

@property (nonatomic, assign) NSInteger tiRSIIntervals;
@property (nonatomic, assign) NSInteger tiRSISMA;
@property (nonatomic, assign) BOOL tiRSISMAShow;

@property (nonatomic, assign) NSInteger tiSTCFastK;
@property (nonatomic, assign) NSInteger tiSTCFastD;

@property (nonatomic, assign) NSInteger tiSTCSlowSK;
@property (nonatomic, assign) NSInteger tiSTCSlowSD;

@property (nonatomic, assign) NSInteger tiVOLSMA;
@property (nonatomic, assign) BOOL tiVOLSMAShow;

@property (nonatomic, assign) NSInteger tiWillInterval;
@property (nonatomic, assign) NSInteger tiWillSma;
@property (nonatomic, assign) BOOL tiWillSmaShow;

- (instancetype)initDefault;
- (void)resetDefault;
@end

NS_ASSUME_NONNULL_END
