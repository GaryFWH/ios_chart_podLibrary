//
//  OpenCloseModel.h
//  ChartLibraryDemo
//
//  Created by william on 4/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChartDataRequest.h"
//#import "ChartCommonUtil.h"

#define OCTimeList @"MDF,DEFAULT,930,1200,1230,1300,1600|MDF,4362,930,,,,1600|MDF,4363,930,,,,1600|HSIL,DEFAULT,930,1200,1230,1300,1600|HSIL,AHA,,,,,|HSIL,AHP,,,,,|HSIL,AHX,,,,,|HSIL,AHC,,,,,|PRS,DEFAULT,915,1200,1240,1300,1630|PRS,HS1,,,,,|PRS,HH1,,,,,|PRS,MH1,,,,,|PRS,MC1,,,,,|PRS,CU1,,,,,|ETNET,UPG_MTS,845,1200,,1230,1630|CIIS,DEFAULT,930,1130,1200,1300,1500|CSI,DEFAULT,930,1130,1200,1300,1500|SSCC,DEFAULT,930,1130,1230,1300,1500|SZSE,DEFAULT,930,1130,1230,1300,1500|PRS,CUS,830,,,,1630|PRS,CEU,830,,,,1630|PRS,CJP,830,,,,1630|PRS,CAU,830,,,,1630|PRS,UCN,830,,,,1630|PRS,CE1,,,,,|PRS,CJ1,,,,,|PRS,CA1,,,,,|PRS,UC1,,,,,|PRS,GDR,830,,,,1630|PRS,GDU,830,,,,1630|PRS,GR1,,,,,|PRS,GU1,,,,,|PRS,FEM,900,,,,1630|PRS,FEQ,900,,,,1630|PRS,FM1,,,,,|PRS,FQ1,,,,,|MDF,SDQ,930,1130,1230,1300,1500|MDF,ZDQ,930,1130,1230,1300,1500|CSI,HDQ,930,1200,1230,1300,1600|SZSE,KDQ,930,1200,1230,1300,1600|MS,DEFAULT,,,,,|PRS,HT2,,,,,|PRS,MTW,,,,,|PRS,M1W,,,,,|PRS,MJU,,,,,|PRS,MJ1,,,,,|PRS,MCN,,,,,|PRS,M1C,,,,,|PRS,EAN,,,,,|PRS,EA1,,,,,|PRS,MHK,,,,,|PRS,M1H,,,,,|PRS,EMN,,,,,|PRS,EM1,,,,,|PRS,MEE,,,,,|PRS,M1E,,,,,|PRS,MSG,,,,,|PRS,M1G,,,,,|PRS,MJP,,,,,|PRS,M1P,,,,,|PRS,MCF,,,,,|PRS,MC3,,,,,|PRS,MCS,830,,,,1630|PRS,MC4,,,,,"

NS_ASSUME_NONNULL_BEGIN

@interface OpenCloseModel : NSObject
{
    int N_MORNING_OPEN;
    int N_MORNING_CLOSE;
    int N_CUTOFF;
    int N_AFTERNOON_OPEN;
    int N_AFTERNOON_CLOSE;
}
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString * code;
@property (copy) NSTimeZone * timezone;
@property (nonatomic, assign) BOOL extraClose;
@property (nonatomic, assign) BOOL overnight;

- (instancetype)initWithType:(NSString *)type code:(NSString *)code;

+ (OpenCloseModel *)hkStockMarketWithCode:(NSString *)code;
+ (OpenCloseModel *)hkFutureMarketWithCode:(NSString *)code;
+ (OpenCloseModel *)hkNightFutureMarketWithCode:(NSString *)code;
+ (OpenCloseModel *)hkIndexMarketWithCode:(NSString *)code;

- (instancetype)initWithString:(NSString *)ocDateString;

- (NSString *)groupingKeyForyyyyMMddHHmm:(NSString *)formatedDate forInterval:(ChartDataInterval)dataInterval session:(ChartSessionType)session;
//- (NSString *)groupingKeyForyyyyMMddHHmm:(NSString *)formatedDate forInterval:(ChartDataInterval)dataInterval;

- (NSArray *)groupingKeyListForDate:(NSString *)date forInterval:(ChartDataInterval)dataInterval;
@end

NS_ASSUME_NONNULL_END
