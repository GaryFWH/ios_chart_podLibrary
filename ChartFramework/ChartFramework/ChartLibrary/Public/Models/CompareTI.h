//
//  CompareTI.h
//  ChartLibraryDemo
//
//  Created by william on 18/8/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "ChartTI.h"
#import "ChartConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface CompareTI : ChartTI

@property (nonatomic, assign) CGFloat prevSelfData;
@property (nonatomic, assign) CGFloat prevCompareData;
@property (nonatomic, strong) NSArray * comparedDataList;

// temp
@property (nonatomic, assign) ChartConfig * chartConfig;

@end

NS_ASSUME_NONNULL_END
