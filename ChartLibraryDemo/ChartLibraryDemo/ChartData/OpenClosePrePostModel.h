//
//  OpenClosePrePostModel.h
//  ChartLibraryDemo
//
//  Created by william on 11/8/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "OpenCloseModel.h"
//#import "ChartBackground.h"
//#import "ChartColorConfig.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenClosePrePostModel : OpenCloseModel
{
    int PRE_OPEN;
    int PRE_CLOSE;
    int POST_OPEN;
    int POST_CLOSE;
}

+ (OpenClosePrePostModel *)usMarketOC;

//- (NSString *)groupingKeyForyyyyMMddHHmm:(NSString *)formatedDate forInterval:(ChartDataInterval)dataInterval session:(ChartSession)session;

- (NSArray *)groupingKeyListForPreForDate:(NSString *)date forInterval:(ChartDataInterval)dataInterval;
- (NSString *)groupingKeyForPreyyyyMMddHHmm:(NSString *)formatedDate forInterval:(ChartDataInterval)dataInterval;
- (CGFloat)percentageOfPreForyyyyMMddHHmm:(NSString *)formatedDate forInterval:(ChartDataInterval)dataInterval;

- (NSArray *)groupingKeyListForPostForDate:(NSString *)date forInterval:(ChartDataInterval)dataInterval;
- (NSString *)groupingKeyForPostyyyyMMddHHmm:(NSString *)formatedDate forInterval:(ChartDataInterval)dataInterval;
- (CGFloat)percentageOfPostForyyyyMMddHHmm:(NSString *)formatedDate forInterval:(ChartDataInterval)dataInterval;

- (ChartBackgroundColor*)getChartBGColor:(NSDate *)nowDate PrevDate:(NSDate *)prevDate forInterval:(ChartDataInterval)dataInterval ColorConfig:(ChartColorConfig*)colorConfig;
- (CGFloat)getBGColorRatio:(NSDate *)date forInterval:(ChartDataInterval)dataInterval;

@end

NS_ASSUME_NONNULL_END
