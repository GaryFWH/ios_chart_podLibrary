//
//  TIChartClass.h
//  ChartLibraryDemo
//
//  Created by william on 22/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "ChartClass.h"
#import "ChartTI.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TIChartClassDisplayDelegate;
@interface TIChartClass : ChartClass

@property (nonatomic, assign) ChartTI * chartTI;

- (instancetype)initWithChartTI:(ChartTI *)chartTI withChartData:(NSArray *)chartDataList displayDelegate:(id<TIChartClassDisplayDelegate>)displayDelegate;

@end

@protocol TIChartClassDisplayDelegate <ChartClassDisplayDelegate>

- (ChartTIConfig *)tiConfig;

@end

NS_ASSUME_NONNULL_END
