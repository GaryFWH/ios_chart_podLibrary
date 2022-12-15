//
//  ChartDataRequest.h
//  EtnetPod_Chart
//
//  Created by william on 25/5/2021.
//

#import <Foundation/Foundation.h>
#import <ChartFramework/ChartFramework.h>
//#import "ChartConst.h"

typedef NS_ENUM(NSUInteger, ChartDataInterval){
    ChartDataInterval1Min = 1,
    ChartDataInterval5Min = 5,
    ChartDataInterval15Min = 15,
    ChartDataInterval30Min = 30,
    ChartDataInterval60Min = 60,
    ChartDataIntervalDay = 100,
    ChartDataIntervalWeek = 101,
    ChartDataIntervalMonth = 102,
};

typedef NS_ENUM(NSUInteger, ChartCodeType){
    ChartCodeTypeHKStock = 0,
    ChartCodeTypeHKIndex,
    ChartCodeTypeHKFuture,
    ChartCodeTypeHKNightFuture,
    ChartCodeTypeAShare,
    ChartCodeTypeUS
};
//
//typedef NS_ENUM(NSUInteger, ChartSession){
//    ChartSessionTypeCore = 0,
//    ChartSessionTypePre,
//    ChartSessionTypePost,
//    ChartSessionTypeCombine,
//};

typedef NS_ENUM(NSUInteger, ChartDataType){
    ChartDataTypeHist = 0,
    ChartDataTypeToday,
    ChartDataTypeAll,
};

NS_ASSUME_NONNULL_BEGIN

@interface ChartDataRequest : NSObject

@property (nonatomic, strong) NSString * code;
@property (nonatomic, assign) ChartDataInterval interval;
@property (nonatomic, assign) ChartDataType dataType;
@property (nonatomic, assign) ChartCodeType codeType;
@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, assign) ChartSessionType session;
@property (nonatomic, assign) BOOL isDelay;

- (instancetype)initWithCode:(NSString *)code interval:(ChartDataInterval)interval dataType:(ChartDataType)dataType codeType:(ChartCodeType)codeType;

- (instancetype)initWithCode:(NSString *)code interval:(ChartDataInterval)interval dataType:(ChartDataType)dataType codeType:(ChartCodeType)codeType session:(ChartSessionType)session;

@end

NS_ASSUME_NONNULL_END
