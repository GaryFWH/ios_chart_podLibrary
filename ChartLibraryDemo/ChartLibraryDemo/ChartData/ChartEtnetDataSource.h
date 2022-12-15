//
//  ChartEtnetDataSource.h
//  EtnetPod_Chart
//
//  Created by william on 24/5/2021.
//

#import <Foundation/Foundation.h>
//#import "ChartData.h"
#import "ChartDataRequest.h"



NS_ASSUME_NONNULL_BEGIN
@protocol ChartDataSource;
@interface ChartEtnetDataSource : NSObject <ChartDataSource>

+ (ChartEtnetDataSource *)sharedInstance;
- (void)loginBMPUserWithCompltion:(void(^)(void))completion;
- (void)loginWithUid:(NSString *)uid token:(NSString *)token;

- (void)requestChartNameForCode:(NSString *)code completion:(void (^)(NSString *))completion;
- (void)requestChartDataDictForCode:(NSString *)code completion:(void (^)(NSArray * _Nonnull))completion;

- (NSArray *)groupKeyListForHKForDate:(NSDate *)date forInterval:(ChartDataInterval)interval;

- (void)requestTNominal:(NSString *)code completion:(void (^)(NSString * _Nonnull))completion;
@end

@protocol ChartDataSource<NSObject>

//- (void)requestChartTodayDataForStockInfo:(ChartDataRequest *)request completion:(void (^)(NSArray<ChartData *> *))completion;
//- (void)requestChartHistoryDataForStockInfo:(ChartDataRequest *)request completion:(void (^)(NSArray<ChartData *> *))completion;
//- (void)requestUSChartHistoryDataForStockInfo:(ChartDataRequest *)request completion:(void (^)(NSArray<ChartData *> * _Nonnull))completion;

- (void)requestChartDataForStockInfo:(ChartDataRequest *)request completion:(void (^)(NSArray<ChartData *> *))completion;
- (void)requestChartDataForStockInfo:(ChartDataRequest *)request completion:(void (^)(NSArray<ChartData *> *))completion fillEmpty:(BOOL)fillEmpty;

@optional
- (void)streamingDataForStockInfo:(ChartDataRequest *)code handlingBlock:(void (^)(ChartData *))completion;
- (void)stopStreamingForStockInfo:(ChartDataRequest *)code;

@end
NS_ASSUME_NONNULL_END
