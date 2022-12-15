//
//  ChartEtnetDataSource.m
//  EtnetPod_Chart
//
//  Created by william on 24/5/2021.
//

#import "ChartEtnetDataSource.h"
#import "OpenCloseModel.h"
#import "OpenClosePrePostModel.h"

#define HTTP_BMPSERVER_URL_IQLOGIN @"http://chartse.etnet.com.hk/HttpServer/bmp_login.jsp?uid=BMPuser&pwd=ETnetBMPuser"
#define SECCHARTSERVER @"http://chartse.etnet.com.hk/HttpServer/TransServer/servlet/SecServlet?minType=5&code=%@&uid=BMPuser&token=%@&limit=400&dataType=hist_today&isDelay=y"

#define CHART_GET_CODEANDNAME @"http://quotese.etnet.com.hk/content/mq3/quoteTitle.php?code=%@"


@interface ChartEtnetDataSource ()

@property (nonatomic, strong) NSString * uid;
@property (nonatomic, strong) NSString * token;

@property (nonatomic, strong) NSTimer * randomTimer;

@property (nonatomic, strong) ChartData * latestData;
@property (nonatomic, assign) ChartDataInterval currentRequestIntervalForTimer;

@property (nonatomic, copy, nullable) void (^streamingResponseBlock)(ChartData *);

@end

@implementation ChartEtnetDataSource

+ (ChartEtnetDataSource *)sharedInstance {
    static ChartEtnetDataSource * sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ChartEtnetDataSource alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (void)loginBMPUserWithCompltion:(void(^)(void))completion {
    self.uid = @"BMPuser";
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:HTTP_BMPSERVER_URL_IQLOGIN]];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data){
    //            NSString * jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if (json){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.token = [json objectForKey:@"token"];
                        completion();
                    });
                }
            }
        }] resume];
}

- (void)loginWithUid:(NSString *)uid token:(NSString *)token {
    self.uid = uid;
    self.token = token;
}

- (void)requestTNominal:(NSString *)code completion:(void (^)(NSString * _Nonnull))completion{
    NSString *urlString = [NSString stringWithFormat:@"http://quotese.etnet.com.hk/content/etnetApp/hks_idxContentQuote.php?code=%@", code];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString * body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString * timestamp = nil;
        NSArray * result = [self receiveDataBody:body timestamp:&timestamp isAh:0];
        for (NSDictionary * dict in result){
            completion([dict objectForKey:@"49"]);
        }
    }] resume];
}

- (void)requestChartNameForCode:(NSString *)code completion:(void (^)(NSString * _Nonnull))completion {
    NSString * urlString = [NSString stringWithFormat:CHART_GET_CODEANDNAME, code];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString * body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString * timestamp = nil;
        NSArray * result = [self receiveDataBody:body timestamp:&timestamp isAh:0];
        for (NSDictionary * dict in result){
            completion([dict objectForKey:@"2"]);
        }
    }] resume];
}

- (void)requestChartDataDictForCode:(NSString *)code completion:(void (^)(NSArray * _Nonnull))completion {
    NSString * urlString = [NSString stringWithFormat:CHART_GET_CODEANDNAME, code];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString * body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString * timestamp = nil;
        NSArray * result = [self receiveDataBody:body timestamp:&timestamp isAh:0];
        completion(result);
    }] resume];
}

- (NSMutableArray*) receiveDataBody:(NSString *) body timestamp:(NSString*__strong*)timestamp isAh:(int)isAh
{
    NSArray *temp_list = [body componentsSeparatedByString:@"\n"]; //2 row
    // 1,2,3,4,5...
    if ([temp_list count] <3) {
        return nil;
    }
    NSArray *timestamps = [temp_list[1] componentsSeparatedByString:@","];
    NSArray *temp_head = [[temp_list objectAtIndex:2] componentsSeparatedByString:@","];
    NSArray *last_array = [[temp_list objectAtIndex:[temp_list count]-1] componentsSeparatedByString:@","];
    if ([temp_list count] <= 3 || ([temp_list count] == 4 && [last_array count] == 1))
    {
        if ([temp_list count] > 2)
        {
            if (isAh && [timestamps count] > 2)
                *timestamp = timestamps[2];
            else
                *timestamp = timestamps[0];
            NSArray *temp_head = [[temp_list objectAtIndex:2] componentsSeparatedByString:@","];
            if ([temp_head count] > 0)
            {
                NSMutableDictionary *dictionary = [[NSDictionary dictionaryWithObject:temp_head forKey:@"1"] mutableCopy];
                return [NSMutableArray arrayWithObject:dictionary];
            }
        }
        return nil;
    }
    
    if (isAh && [timestamps count] > 2){
        if (isAh == 0) {
            *timestamp = timestamps[0];
        }else if (isAh == 1){
            *timestamp = timestamps[1];
        }else if (isAh == 2){
            *timestamp = timestamps[2];
        }
    }
    else
        *timestamp = timestamps[0];
    
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (int i = 3; i < [temp_list count]; i++)
    {
        NSString *row = [temp_list objectAtIndex:i]; // get content: v1,v2,v3
        NSArray *cloumn = [self separatedByString:@"," targetString:row expectString:@"\""];
        
        NSMutableDictionary *temp_dict = [[NSMutableDictionary alloc] init];
        if ([cloumn count] > [temp_head count])
        {
            continue;
        }
        for (int j = 0; j < [cloumn count]; j++)
        {
            [temp_dict setValue:[cloumn objectAtIndex:j] forKey:[temp_head objectAtIndex:j]];
        }
        [result addObject:temp_dict];
    }
    return result;
}
#define ReplaceDoubleQuotationMarkChart @"^"
- (NSArray *)separatedByString:(NSString *)separator targetString:(NSString *)targetString expectString:(NSString *)expector
{
    if ([targetString rangeOfString:@"\"\""].location != NSNotFound) {
        targetString = [targetString stringByReplacingOccurrencesOfString:@"\"\"" withString:ReplaceDoubleQuotationMarkChart];
    }
    NSUInteger lastSeparatorPos = 0;
    NSUInteger lastExpectorPos = 0;
    NSString *tempString;
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i <= (int)([targetString length] - [separator length]);)
    {
        tempString = [targetString substringWithRange:NSMakeRange(i, [separator length])];
        if ([tempString isEqualToString:expector])
        {
            for (i += [expector length]; i <= (int)([targetString length] - [expector length]);) {
                if ([[targetString substringWithRange:NSMakeRange(i, [separator length])] isEqualToString:expector])
                {
                    tempString = [targetString substringWithRange:NSMakeRange(lastExpectorPos + [expector length], i - [expector length] - lastExpectorPos)];
                    i += [expector length];
                    lastExpectorPos = lastSeparatorPos = i;
                    tempString =  [tempString stringByReplacingOccurrencesOfString:ReplaceDoubleQuotationMarkChart withString:@"\""];
                    [tempArray addObject:tempString];
                    i++;
                    lastExpectorPos = lastSeparatorPos = i;
                    break;
                }
                else
                {
                    i++;
                }
            }
        }
        else
        {
            if ([tempString isEqualToString:separator])
            {
//                if (i == lastSeparatorPos) {
//                    NSLog(@"0000000000000");
//                }
                tempString = [targetString substringWithRange:NSMakeRange(lastSeparatorPos, i - lastSeparatorPos)];
                i += [separator length];
                lastSeparatorPos = lastExpectorPos = i;
//                if (tempString.length) {
                tempString =  [tempString stringByReplacingOccurrencesOfString:ReplaceDoubleQuotationMarkChart withString:@"\""];
                [tempArray addObject:tempString];
//                }else{
//                    NSLog(@"0000000000000");
//                }
                
//                if (i == [targetString length] )
//                {
//                    [tempArray addObject:@""];
//                }
            }
            else
            {
                if (i == [targetString length] - 1)
                {
                    tempString = [targetString substringWithRange:NSMakeRange(lastSeparatorPos, i + [separator length] - lastSeparatorPos)];
                    tempString =  [tempString stringByReplacingOccurrencesOfString:ReplaceDoubleQuotationMarkChart withString:@"\""];
                    [tempArray addObject:tempString];
                }
                i++;
            }
        }
    }
    
    return tempArray;
}


- (NSString *)urlForRequest:(ChartDataRequest *)request {
    NSString * basicURL = @"";
    switch (request.codeType){
        case ChartCodeTypeHKStock:
        {
            basicURL = @"http://chartse.etnet.com.hk/HttpServer/TransServer/servlet/SecServlet?";
        }
            break;
        case ChartCodeTypeHKIndex:
        {
            basicURL = @"http://chartse.etnet.com.hk/HttpServer/TransServer/servlet/IndexServlet?";
        }
            break;
        case ChartCodeTypeHKFuture:
        case ChartCodeTypeHKNightFuture:
        {
            basicURL = @"http://chartse.etnet.com.hk/HttpServer/TransServer/servlet/FutServlet?";
        }
            break;
        case ChartCodeTypeAShare:
        {
            basicURL = @"http://chartse.etnet.com.hk/HttpServer/TransServer/servlet/SecServlet?";
        }
            break;
        case ChartCodeTypeUS:
        {
            basicURL = @"http://chartse.etnet.com.hk/HttpServer/TransServer/servlet/SecServlet?";
        }
            break;
    }
    NSMutableArray * mutArray = [NSMutableArray array];
    NSString * minType;
    switch (request.interval) {
        case ChartDataInterval1Min:
            minType = @"1";
            break;
        case ChartDataInterval5Min:
            minType = @"5";
            break;
        case ChartDataInterval15Min:
            minType = @"15";
            break;
        case ChartDataInterval30Min:
            minType = @"30";
            break;
        case ChartDataInterval60Min:
            minType = @"60";
            break;
        case ChartDataIntervalDay:
            minType = @"100";
            break;
        case ChartDataIntervalWeek:
            minType = @"101";
            break;
        case ChartDataIntervalMonth:
            minType = @"102";
            break;
        default:
            break;
    }
    NSString * dataType;
    switch (request.dataType) {
        case ChartDataTypeHist:
            dataType = @"hist";
            break;
        case ChartDataTypeToday:
            dataType = @"today";
            break;
        case ChartDataTypeAll:
            dataType = @"hist_today";
            break;
            
        default:
            break;
    }
    NSString * session;
    switch (request.session) {
        case ChartSessionTypePre:
            session = @"pre";
            break;
        case ChartSessionTypeCore:
            session = @"core";
            break;
        case ChartSessionTypePost:
            session = @"post";
            break;
        case ChartSessionTypeCombine:
            session = @"combine";
            break;
        default:
            break;
    }
    if (minType){
//        basicURL = [basicURL stringByAppendingFormat:@"minType=%@",minType];
        [mutArray addObject:[NSString stringWithFormat:@"minType=%@", minType]];
    }
    if (dataType){
        [mutArray addObject:[NSString stringWithFormat:@"dataType=%@", dataType]];
    }
    if (request.code){
//        basicURL = [basicURL stringByAppendingFormat:@"&code=%@",request.code];
        [mutArray addObject:[NSString stringWithFormat:@"code=%@", request.code]];
    }
    [mutArray addObject:[NSString stringWithFormat:@"uid=%@", self.uid]];
    [mutArray addObject:[NSString stringWithFormat:@"token=%@", self.token]];
    if (request.codeType != ChartCodeTypeUS){
//        basicURL = [basicURL stringByAppendingFormat:@"&uid=%@",self.uid];
//        basicURL = [basicURL stringByAppendingFormat:@"&token=%@",self.token];
    } else {
        if (session){
//        basicURL = [basicURL stringByAppendingFormat:@"&session=%@"]
            [mutArray addObject:[NSString stringWithFormat:@"session=%@", session]];
        }
        [mutArray addObject:@"market=US"];
    }
    if (request.limit > 0){
//        basicURL = [basicURL stringByAppendingFormat:@"&limit=%zd",request.limit];
        [mutArray addObject:[NSString stringWithFormat:@"limit=%zd", request.limit]];
    }
    if (request.isDelay){
        [mutArray addObject:@"isDelay=y"];
    }
    basicURL = [basicURL stringByAppendingFormat:@"%@", [mutArray componentsJoinedByString:@"&"]];
    
    return basicURL;
}

//- (NSString *)urlForHKStock:(NSString *)code minType:(NSString *)minType uid:(NSString *)uid token:(NSString *)token limit:(NSInteger)limit dataType:(NSString *)dataType isDelay:(BOOL)isDalay {
//    NSString * basicURL = @"http://chartse.etnet.com.hk/HttpServer/TransServer/servlet/SecServlet?";
//    basicURL = [basicURL stringByAppendingFormat:@"minType=%@",minType];
//    basicURL = [basicURL stringByAppendingFormat:@"&code=%@",code];
//    basicURL = [basicURL stringByAppendingFormat:@"&uid=%@",uid];
//    basicURL = [basicURL stringByAppendingFormat:@"&token=%@",token];
//    basicURL = [basicURL stringByAppendingFormat:@"&limit=%zd",limit];
//    if (dataType){
////        basicURL = [basicURL stringByAppendingFormat:@"&dataType=%@",@"today"];
////    } else {
//        basicURL = [basicURL stringByAppendingFormat:@"&dataType=%@",dataType];
//    }
//    if (isDalay){
//        basicURL = [basicURL stringByAppendingFormat:@"&isDelay=%@",@"y"];
//    }
//    return basicURL;
//}
- (NSArray *)getDateListFromData:(NSArray *)dataList timezone:(NSTimeZone *) timezone {
    NSMutableArray * array = [NSMutableArray array];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timezone];
    [formatter setDateFormat:@"dd"];
    
    NSString * tempDay;
    for (ChartData * data in dataList){
        NSDate * date = data.date;
        NSString * formatted = [formatter stringFromDate:date];
        if (!tempDay || ![tempDay isEqualToString:formatted]){
//                if ([@"0930" isEqualToString:[formatter stringFromDate:date]]){
            [array addObject:data.groupingKey];
            tempDay = formatted;
        }
    }
    return array;
}

//- (NSArray *)getDateListFromData:(NSArray *)dataList {
//    NSMutableArray * array = [NSMutableArray array];
//    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"dd"];
//
//    NSString * tempDay;
//    for (ChartData * data in dataList){
//        NSDate * date = data.date;
//        NSString * formatted = [formatter stringFromDate:date];
//        if (!tempDay || ![tempDay isEqualToString:formatted]){
////                if ([@"0930" isEqualToString:[formatter stringFromDate:date]]){
//            [array addObject:data.groupingKey];
//            tempDay = formatted;
//        }
//    }
//    return array;
//}

//- (void)requestChartTodayDataForStockInfo:(ChartDataRequest *)request completion:(void (^)(NSArray<ChartData *> * _Nonnull))completion {
//    NSString * code = request.code;
//    NSString * chartfid = @"";
//    switch (request.interval) {
//        case ChartDataInterval1Min:
//            chartfid = @"1";
//            break;
//        case ChartDataInterval5Min:
//            chartfid = @"5";
//            break;
//        case ChartDataInterval15Min:
//            chartfid = @"15";
//            break;
//        case ChartDataInterval30Min:
//            chartfid = @"30";
//            break;
//        case ChartDataInterval60Min:
//            chartfid = @"60";
//            break;
//        case ChartDataIntervalDay:
//            chartfid = @"100";
//            break;
//        case ChartDataIntervalWeek:
//            chartfid = @"101";
//            break;
//        case ChartDataIntervalMonth:
//            chartfid = @"102";
//            break;
//        default:
//            break;
//    }
//    if (!self.uid || !self.token){
//        [self loginBMPUserWithCompltion:^{
//            [self requestChartTodayDataForStockInfo:request completion:completion];
//        }];
//        return;
//    }
//    NSString * dataType = nil;
//    switch (request.dataType){
//        case ChartDataTypeHist:
//            dataType = @"hist";
//            break;
//        case ChartDataTypeToday:
//            dataType = @"today";
//            break;
//        case ChartDataTypeAll:
//            dataType = @"hist_today";
//            break;
//    }
//    NSString * urlString = [self urlForHKStock:code minType:chartfid uid:self.uid token:self.token limit:400 dataType:dataType isDelay:YES];
//    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//    NSLog(@"URL:%@", urlString);
//    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//
//        NSString * result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSArray * resultArray = [result componentsSeparatedByString:@"\n"];
//        NSArray * chartData = [self extractDataFromResult:resultArray forInterval:request.interval];
//        chartData = [[chartData reverseObjectEnumerator] allObjects];
//
//        self.currentRequestIntervalForTimer = request.interval;
//        self.latestData = [chartData lastObject];
//
//        NSMutableArray * newDataList = [NSMutableArray array];
//        for (NSString * groupingKey in [self getDateListFromData:chartData]){
//            OpenCloseModel * model = [[OpenCloseModel alloc] initWithString:@"MDF,DEFAULT,930,1200,1230,1300,1600,"];
//            NSArray * keyList = [model groupingKeyListForDate:groupingKey forInterval:request.interval];
//            NSInteger i = 0;
//            NSInteger j = 0;
//
//            while (j < [keyList count]){
//                if (i == [chartData count]){
//                    NSString * groupKey = [keyList objectAtIndex:j];
//                    ChartData * newData = [[ChartData alloc] initEmptyDataWithGroupingKey:groupKey date:[self convertDateFromyyyyMMddHHmm:groupKey]];
//                    [newDataList addObject:newData];
//                    j++;
//                    continue;
//                }
//                ChartData * cData = [chartData objectAtIndex:i];
//                NSString * groupKey = [keyList objectAtIndex:j];
//                if ([cData.groupingKey integerValue] == [groupKey integerValue] ){
//                    [newDataList addObject:cData];
//                    i++;
//                    j++;
//                    continue;
//                }
//                if ([cData.groupingKey integerValue] > [groupKey integerValue]){
//                    ChartData * newData = [[ChartData alloc] initEmptyDataWithGroupingKey:groupKey date:[self convertDateFromyyyyMMddHHmm:groupKey]];
//                    [newDataList addObject:newData];
//                    j++;
//                    continue;
//                }
//                if ([cData.groupingKey integerValue] < [groupKey integerValue]){
//                    i++;
//                    continue;
//                }
//            }
//        }
//        completion([NSArray arrayWithArray:newDataList]);
//    }];
//}
//
//- (NSArray *)groupKeyListForHKForDate:(NSDate *)date forInterval:(ChartDataInterval)interval {
//    OpenCloseModel * model = [[OpenCloseModel alloc] initWithString:@"MDF,DEFAULT,930,1200,1230,1300,1600,"];
//    NSArray * keyList = [model groupingKeyListForDate:[self convertDateTimeFromDate:date forInterval:interval] forInterval:interval];
//    return keyList;
//}
//
//
//
//- (void)requestChartHistoryDataForStockInfo:(ChartDataRequest *)request completion:(void (^)(NSArray<ChartData *> * _Nonnull))completion {
//    NSString * code = request.code;
//    NSString * chartfid = @"";
//    switch (request.interval) {
//        case ChartDataInterval1Min:
//            chartfid = @"1";
//            break;
//        case ChartDataInterval5Min:
//            chartfid = @"5";
//            break;
//        case ChartDataInterval15Min:
//            chartfid = @"15";
//            break;
//        case ChartDataInterval30Min:
//            chartfid = @"30";
//            break;
//        case ChartDataInterval60Min:
//            chartfid = @"60";
//            break;
//        case ChartDataIntervalDay:
//            chartfid = @"100";
//            break;
//        case ChartDataIntervalWeek:
//            chartfid = @"101";
//            break;
//        case ChartDataIntervalMonth:
//            chartfid = @"102";
//            break;
//        default:
//            break;
//    }
//    int codeType = 0;
//    NSString * dataType;
//    switch (request.dataType) {
//        case ChartDataTypeHist:
//            dataType = @"hist";
//            break;
//        case ChartDataTypeToday:
//            dataType = @"today";
//            break;
//        case ChartDataTypeAll:
//            dataType = @"hist_today";
//            break;
//
//        default:
//            break;
//    }
////    NSString * today = request.isToday?@"1":@"0";
////    [[ConnectionUtil instance] getChartHistoryData:code withID:chartfid isToday:today withCodeType:codeType withCol:@"" completionBlock:^(NSData *result) {
////    NSData * result = nil;
//    if (!self.uid || !self.token){
//        [self loginBMPUserWithCompltion:^{
//            [self requestChartHistoryDataForStockInfo:request completion:completion];
//        }];
//        return;
//    }
//    NSString * urlString = [self urlForHKStock:code minType:chartfid uid:self.uid token:self.token limit:request.limit dataType:dataType isDelay:YES];
//    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//    NSLog(@"URL:%@", urlString);
//    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//
//        NSString * result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSArray * resultArray = [result componentsSeparatedByString:@"\n"];
//        NSArray * chartData = [self extractDataFromResult:resultArray forInterval:request.interval];
////        chartData = [[chartData reverseObjectEnumerator] allObjects];
////        [resultArray sortUsingComparator:^NSComparisonResult(ChartData * obj1, ChartData * obj2) {
////            if ([obj1.datetime doubleValue] == [obj2.datetime doubleValue]){
////                return NSOrderedSame;
////            } else if ([obj1.datetime doubleValue] < [obj2.datetime doubleValue]){
////                return NSOrderedAscending;
////            } else {
////                return NSOrderedDescending;
////            }
////        }];
////
//        self.currentRequestIntervalForTimer = request.interval;
//        self.latestData = [chartData lastObject];
//        completion(chartData);
////    }];
//    }];
//}

//- (NSArray *)extractDataFromResult:(NSArray *)resultArray forInterval:(ChartDataInterval)interval{
////    NSMutableArray * array = [NSMutableArray array];
//    BOOL isFirst = YES;
//    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
//    for (NSString * dataStr in resultArray){
//        NSArray * valueAry = [dataStr componentsSeparatedByString:@","];
//        if ([valueAry count] > 5){
//            NSString * key = [valueAry objectAtIndex:0];
//            NSString * open = [valueAry objectAtIndex:1];
//            NSString * high = [valueAry objectAtIndex:2];
//            NSString * low = [valueAry objectAtIndex:3];
//            NSString * close = [valueAry objectAtIndex:4];
//            NSString * volume = [valueAry objectAtIndex:5];
//
//            ChartData * data = [[ChartData alloc] init];
//
////            data.groupingKey = key;
//            data.groupingKey = [self convertDateTimeFromTimestamp:key forInterval:interval];
//            data.date = [self convertDateFromTimestamp:key];
//            if (interval < ChartDataIntervalDay){
//                if (isFirst){
//                    isFirst = NO;
//                } else {
//                    data.date = [self convertDateFromyyyyMMddHHmm:data.groupingKey];
//                }
//            }
//            data.open = [open floatValue];
//            data.high = [high floatValue];
//            data.low = [low floatValue];
//            data.close = [close floatValue];
//            data.volume = [volume floatValue];
////            [array addObject:data];
//            if ([dictionary objectForKey:data.groupingKey]){
//                ChartData * dt = [dictionary objectForKey:data.groupingKey];
//                [dt mergeWithData:data];
////                dt.high = (dt.high>data.high)?dt.high:data.high;
////                dt.low = (dt.low<data.low)?dt.low:data.low;
////                dt.open = ([dt.date timeIntervalSince1970]>[data.date timeIntervalSince1970])?dt.open:data.open;
////                dt.close = ([dt.date timeIntervalSince1970]<[data.date timeIntervalSince1970])?dt.close:data.close;
////                dt.volume += data.volume;
//            } else {
//                [dictionary setObject:data forKey:data.groupingKey];
//            }
//        }
//    }
//    NSArray * sortedKey = [[dictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *  _Nonnull obj1, NSString *  _Nonnull obj2) {
////        return [obj1 ]
//        if ([obj1 integerValue] == [obj2 integerValue]){
//            return NSOrderedSame;
//        } else if ([obj1 integerValue] < [obj2 integerValue]){
//            return NSOrderedAscending;
//        } else {
//            return NSOrderedDescending;
//        }
//    }];
//    NSMutableArray * array = [NSMutableArray array];
//    for (NSString * key in sortedKey){
//        ChartData * data = [dictionary objectForKey:key];
//        [array addObject:data];
//    }
//    return array;
//}
//- (NSDate *)convertDateFromyyyyMMddHHmm:(NSString *)dateStr {
////    NSDate *date = [NSDate dateWithTimeIntervalSince1970:datetime];
//    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
//    [objDateformat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*60*60]];
//    [objDateformat setDateFormat:@"yyyyMMddHHmm"];
//    NSDate * date = [objDateformat dateFromString:dateStr];
//    return date;
//
//}

- (NSDate *)convertDateFromTimestamp:(NSString *)timestamp {
    unsigned long datetime = [[timestamp substringToIndex:[timestamp length] - 3] longLongValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:datetime];
    return date;
}

//- (NSString *)convertDateTimeFromDate:(NSDate *)date forInterval:(ChartDataInterval) interval{
//    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
//    [objDateformat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*60*60]];
//    NSString * dateFormat = @"";
//    switch (interval){
//        case ChartDataInterval1Min:
//        case ChartDataInterval5Min:
//        case ChartDataInterval15Min:
//        case ChartDataInterval30Min:
//        case ChartDataInterval60Min:
//        {
//            dateFormat = @"yyyyMMddHHmm";
//        }
//            break;
//        case ChartDataIntervalDay:
//        case ChartDataIntervalWeek:
//        {
//            dateFormat = @"yyyyMMdd";
//        }
//            break;
//        case ChartDataIntervalMonth:
//        {
//            dateFormat = @"yyyyMM";
//        }
//            break;
//    }
//    [objDateformat setDateFormat:dateFormat];
//    NSString * dateStr = [objDateformat stringFromDate:date];
//    if (interval < ChartDataIntervalDay){
//        dateStr = [self groupingToNearestKeyForTimestamp:dateStr forInterval:interval];
//    }
//    return dateStr;
//}

//- (NSString *)convertDateTimeFromTimestamp:(NSString *)timestamp forInterval:(ChartDataInterval) interval{
//    unsigned long datetime = [[timestamp substringToIndex:[timestamp length] - 3] longLongValue];
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:datetime];
//    return [self convertDateTimeFromDate:date forInterval:interval];
//}

//- (NSString *)groupingToNearestKeyForTimestamp:(NSString *)timestamp forInterval:(ChartDataInterval) interval {
//    OpenCloseModel * model = [[OpenCloseModel alloc] initWithString:@"MDF,DEFAULT,930,1200,1230,1300,1600,"];
//
//    return [model groupingKeyForyyyyMMddHHmm:timestamp forInterval:interval];
//}

- (void)startRandomTimer {
    if (self.randomTimer){
        [self.randomTimer invalidate];
    }
    self.randomTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(setRandomChartData) userInfo:nil repeats:YES];
}

- (void)setRandomChartData {
    //60.4|484000|U|-|16:08:19|1526
    NSString * currentKey = self.latestData.groupingKey;
    NSDate * currentDate = self.latestData.date;
    
    //Add 1 sec
    NSDate * newDate = [NSDate dateWithTimeIntervalSince1970:([currentDate timeIntervalSince1970] + 60)];
    OpenCloseModel * model = [[OpenCloseModel alloc] initWithString:@"MDF,DEFAULT,930,1200,1230,1300,1600,"];
    NSString * newKey = [self convertDateTimeFromDate:newDate forInterval:self.currentRequestIntervalForTimer openCloseModel:model session:ChartSessionTypeCore timezone:model.timezone];
    
    ChartData * newChartData;
    bool isNew = NO;
    if ([newKey isEqualToString:currentKey]){
        newChartData = self.latestData;
    } else {
        newChartData = [[ChartData alloc] initEmptyDataWithGroupingKey:newKey date:newDate];
        isNew = YES;
    }
    
    newChartData.date = newDate;
    newChartData.groupingKey = newKey;
    CGFloat randomNumber = (float)rand() / RAND_MAX * 2 - 1;
    CGFloat newClose = self.latestData.close + randomNumber;
    newChartData.close = newClose;
    if (isNew || newClose > newChartData.high){
        newChartData.high = newClose;
    }
    if (isNew || newClose < newChartData.low){
        newChartData.low = newClose;
    }
    if (isNew){
        newChartData.open = newClose;
    }
    NSInteger randomVolume = self.latestData.volume + arc4random() % 1000  * 10;
    newChartData.volume = randomVolume;
    
    self.latestData = newChartData;
    
    self.streamingResponseBlock(newChartData);
}

- (void)streamingDataForStockInfo:(NSString *)code handlingBlock:(void (^)(ChartData *))completion {
    self.streamingResponseBlock = completion;
    
    [self startRandomTimer];
}

- (void)stopStreamingForStockInfo:(ChartDataRequest *)code {
    if (self.randomTimer){
        [self.randomTimer invalidate];
    }
    self.randomTimer = nil;
}

#pragma mark - US Chart
//- (NSString *)urlForUSStock:(NSString *)code minType:(NSString *)minType uid:(NSString *)uid token:(NSString *)token limit:(NSInteger)limit dataType:(NSString *)dataType session:(ChartSessionType)session {
//    NSString * basicURL = @"http://10.1.16.191/TransServer/servlet/SecServlet?";
//    basicURL = [basicURL stringByAppendingFormat:@"minType=%@",minType];
//    basicURL = [basicURL stringByAppendingFormat:@"&code=%@",code];
////    basicURL = [basicURL stringByAppendingFormat:@"&uid=%@",uid];
////    basicURL = [basicURL stringByAppendingFormat:@"&token=%@",token];
//    basicURL = [basicURL stringByAppendingFormat:@"&limit=%zd",limit];
//    if (dataType){
//        basicURL = [basicURL stringByAppendingFormat:@"&dataType=%@",dataType];
//    }
//    switch (session) {
//        case ChartSessionTypePre:
//            basicURL = [basicURL stringByAppendingFormat:@"&session=%@",@"pre"];
//            break;
//        case ChartSessionTypeCore:
//            basicURL = [basicURL stringByAppendingFormat:@"&session=%@",@"core"];
//            break;
//        case ChartSessionTypePost:
//            basicURL = [basicURL stringByAppendingFormat:@"&session=%@",@"post"];
//            break;
//        case ChartSessionTypeCombine:
//            basicURL = [basicURL stringByAppendingFormat:@"&session=%@",@"combine"];
//            break;
//        default:
//            break;
//    }
//    return basicURL;
//}

//- (void)requestUSChartHistoryDataForStockInfo:(ChartDataRequest *)request completion:(void (^)(NSArray<ChartData *> * _Nonnull))completion {
//    NSString * code = request.code;
//    NSString * chartfid = @"";
//    switch (request.interval) {
//        case ChartDataInterval1Min:
//            chartfid = @"1";
//            break;
//        case ChartDataInterval5Min:
//            chartfid = @"5";
//            break;
//        case ChartDataInterval15Min:
//            chartfid = @"15";
//            break;
//        case ChartDataInterval30Min:
//            chartfid = @"30";
//            break;
//        case ChartDataInterval60Min:
//            chartfid = @"60";
//            break;
//        case ChartDataIntervalDay:
//            chartfid = @"100";
//            break;
//        case ChartDataIntervalWeek:
//            chartfid = @"101";
//            break;
//        case ChartDataIntervalMonth:
//            chartfid = @"102";
//            break;
//        default:
//            break;
//    }
//    int codeType = 0;
//    NSString * dataType;
//    switch (request.dataType) {
//        case ChartDataTypeHist:
//            dataType = @"hist";
//            break;
//        case ChartDataTypeToday:
//            dataType = @"today";
//            break;
//        case ChartDataTypeAll:
//            dataType = @"hist_today";
//            break;
//
//        default:
//            break;
//    }
////    [[ConnectionUtil instance] getChartHistoryData:code withID:chartfid isToday:today withCodeType:codeType withCol:@"" completionBlock:^(NSData *result) {
////    NSData * result = nil;
//    if (!self.uid || !self.token){
//        [self loginBMPUserWithCompltion:^{
//            [self requestUSChartHistoryDataForStockInfo:request completion:completion];
//        }];
//        return;
//    }
//    NSString * urlString = [self urlForUSStock:code minType:chartfid uid:self.uid token:self.token limit:request.limit dataType:dataType session:request.session];
//    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//    NSLog(@"URL:%@", urlString);
//
//    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        NSString * result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSArray * resultArray = [result componentsSeparatedByString:@"\n"];
//        NSArray * chartData = [self extractUSDataFromResult:resultArray forInterval:request.interval];
////        chartData = [[chartData reverseObjectEnumerator] allObjects];
//        completion(chartData);
//    }];
//}

//- (NSArray *)extractUSDataFromResult:(NSArray *)resultArray forInterval:(ChartDataInterval)interval{
////    NSMutableArray * array = [NSMutableArray array];
//    BOOL isFirst = YES;
//    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
//    for (NSString * dataStr in resultArray){
//        NSArray * valueAry = [dataStr componentsSeparatedByString:@","];
//        if ([valueAry count] > 5){
//            NSString * key = [valueAry objectAtIndex:0];
//            NSString * open = [valueAry objectAtIndex:1];
//            NSString * high = [valueAry objectAtIndex:2];
//            NSString * low = [valueAry objectAtIndex:3];
//            NSString * close = [valueAry objectAtIndex:4];
//            NSString * volume = [valueAry objectAtIndex:5];
//
//            ChartData * data = [[ChartData alloc] init];
//
//            data.groupingKey = key;
////            data.groupingKey = [self convertUSDateTimeFromTimestamp:key forInterval:interval];
//            data.date = [self convertDateFromTimestamp:key];
////            if (interval < ChartDataIntervalDay){
////                if (isFirst){
////                    isFirst = NO;
////                } else {
////                    data.date = [self convertUSDateFromyyyyMMddHHmm:data.groupingKey];
////                }
////            }
//            data.open = [open floatValue];
//            data.high = [high floatValue];
//            data.low = [low floatValue];
//            data.close = [close floatValue];
//            data.volume = [volume floatValue];
////            [array addObject:data];
//            if ([dictionary objectForKey:data.groupingKey]){
//                ChartData * dt = [dictionary objectForKey:data.groupingKey];
//                [dt mergeWithData:data];
////                dt.high = (dt.high>data.high)?dt.high:data.high;
////                dt.low = (dt.low<data.low)?dt.low:data.low;
////                dt.open = ([dt.date timeIntervalSince1970]>[data.date timeIntervalSince1970])?dt.open:data.open;
////                dt.close = ([dt.date timeIntervalSince1970]<[data.date timeIntervalSince1970])?dt.close:data.close;
////                dt.volume += data.volume;
//
//            } else {
//                [dictionary setObject:data forKey:data.groupingKey];
//            }
//        }
//    }
//    NSArray * sortedKey = [[dictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *  _Nonnull obj1, NSString *  _Nonnull obj2) {
////        return [obj1 ]
//        if ([obj1 integerValue] == [obj2 integerValue]){
//            return NSOrderedSame;
//        } else if ([obj1 integerValue] < [obj2 integerValue]){
//            return NSOrderedAscending;
//        } else {
//            return NSOrderedDescending;
//        }
//    }];
//    NSMutableArray * array = [NSMutableArray array];
//    for (NSString * key in sortedKey){
//        ChartData * data = [dictionary objectForKey:key];
//        [array addObject:data];
//    }
//    return array;
//}
//
//- (NSDate *)convertUSDateFromyyyyMMddHHmm:(NSString *)dateStr {
//    OpenClosePrePostModel * model = [OpenClosePrePostModel usMarketOC];
//    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
//    [objDateformat setTimeZone:model.timezone];
//    [objDateformat setDateFormat:@"yyyyMMddHHmm"];
//    NSDate * date = [objDateformat dateFromString:dateStr];
//    return date;
//}
//
//- (NSString *)convertUSDateTimeFromTimestamp:(NSString *)timestamp forInterval:(ChartDataInterval) interval{
//    unsigned long datetime = [[timestamp substringToIndex:[timestamp length] - 3] longLongValue];
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:datetime];
//
//    OpenClosePrePostModel * model = [OpenClosePrePostModel usMarketOC];
//    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
//    [objDateformat setTimeZone:model.timezone];
//    NSString * dateFormat = @"";
//    switch (interval){
//        case ChartDataInterval1Min:
//        case ChartDataInterval5Min:
//        case ChartDataInterval15Min:
//        case ChartDataInterval30Min:
//        case ChartDataInterval60Min:
//        {
//            dateFormat = @"yyyyMMddHHmm";
//        }
//            break;
//        case ChartDataIntervalDay:
//        case ChartDataIntervalWeek:
//        {
//            dateFormat = @"yyyyMMdd";
//        }
//            break;
//        case ChartDataIntervalMonth:
//        {
//            dateFormat = @"yyyyMM";
//        }
//            break;
//    }
//    [objDateformat setDateFormat:dateFormat];
//    NSString * dateStr = [objDateformat stringFromDate:date];
//    if (interval < ChartDataIntervalDay){
////        dateStr = [self groupingToNearestKeyForTimestamp:dateStr forInterval:interval];
//        dateStr = [model groupingKeyForyyyyMMddHHmm:dateStr forInterval:interval];
//    }
//    return dateStr;
//
//}


#pragma mark - Combine Request

- (void)requestChartDataForStockInfo:(ChartDataRequest *)request completion:(void (^)(NSArray<ChartData *> * _Nonnull))completion {
    [self requestChartDataForStockInfo:request completion:completion fillEmpty:NO];
}

- (void)requestChartDataForStockInfo:(ChartDataRequest *)request completion:(void (^)(NSArray<ChartData *> *))completion fillEmpty:(BOOL)fillEmpty{
//    NSString * code = request.code;
//    NSString * chartfid = @"";
//    switch (request.interval) {
//        case ChartDataInterval1Min:
//            chartfid = @"1";
//            break;
//        case ChartDataInterval5Min:
//            chartfid = @"5";
//            break;
//        case ChartDataInterval15Min:
//            chartfid = @"15";
//            break;
//        case ChartDataInterval30Min:
//            chartfid = @"30";
//            break;
//        case ChartDataInterval60Min:
//            chartfid = @"60";
//            break;
//        case ChartDataIntervalDay:
//            chartfid = @"100";
//            break;
//        case ChartDataIntervalWeek:
//            chartfid = @"101";
//            break;
//        case ChartDataIntervalMonth:
//            chartfid = @"102";
//            break;
//        default:
//            break;
//    }
//    int codeType = 0;
//    NSString * dataType;
//    switch (request.dataType) {
//        case ChartDataTypeHist:
//            dataType = @"hist";
//            break;
//        case ChartDataTypeToday:
//            dataType = @"today";
//            break;
//        case ChartDataTypeAll:
//            dataType = @"hist_today";
//            break;
//
//        default:
//            break;
//    }
    if (!request.code){
        completion(@[]);
    }
    
    if (!self.uid || !self.token){
        [self loginBMPUserWithCompltion:^{
            [self requestChartDataForStockInfo:request completion:completion fillEmpty:fillEmpty];
        }];
        return;
    }
    
    //Handling
    if (request.dataType == ChartDataTypeAll){
        request.dataType = ChartDataTypeHist;
        [self requestChartDataForStockInfo:request completion:^(NSArray<ChartData *> * _Nonnull chartData) {
            __block NSArray * histData = chartData;
            request.dataType = ChartDataTypeToday;
            [self requestChartDataForStockInfo:request completion:^(NSArray<ChartData *> * _Nonnull chartData2) {
                NSMutableArray * combinedData = [NSMutableArray array];
                [combinedData addObjectsFromArray:histData];
                [combinedData addObjectsFromArray:chartData2];
//                [combinedData sortUsingComparator:^NSComparisonResult(ChartData *  _Nonnull obj1, ChartData *  _Nonnull obj2) {
//                    return [obj1.date compare:obj2.date];
//                }];
                completion([NSArray arrayWithArray:combinedData]);
            } fillEmpty:fillEmpty];
        } fillEmpty:fillEmpty];
        return;
    }
    
    NSString * urlString = nil;
    OpenCloseModel * model = nil;
    NSTimeZone * timezone = [NSTimeZone systemTimeZone];
    urlString = [self urlForRequest:request];
    switch (request.codeType){
        case ChartCodeTypeHKStock:
        {
//            urlString = [self urlForHKStock:code minType:chartfid uid:self.uid token:self.token limit:request.limit dataType:dataType isDelay:YES];
//            model = [[OpenCloseModel alloc] initWithString:@"MDF,DEFAULT,930,1200,1230,1300,1600,"];
            model = [OpenCloseModel hkStockMarketWithCode:request.code];
            timezone = model.timezone;
        }
            break;
        case ChartCodeTypeHKIndex:
        {
            model = [OpenCloseModel hkIndexMarketWithCode:request.code];
            timezone = model.timezone;
        }
            break;
        case ChartCodeTypeHKFuture:
        {
            model = [OpenCloseModel hkFutureMarketWithCode:request.code];
            timezone = model.timezone;
        }
            break;
        case ChartCodeTypeHKNightFuture:
        {
            model = [OpenCloseModel hkNightFutureMarketWithCode:request.code];
            timezone = model.timezone;
        }
            break;
        case ChartCodeTypeUS:
        {
//            urlString = [self urlForUSStock:code minType:chartfid uid:self.uid token:self.token limit:request.limit dataType:dataType session:request.session];
            if (request.dataType == ChartDataTypeToday || fillEmpty){
                model = [OpenClosePrePostModel usMarketOC];
            }
            timezone = [OpenClosePrePostModel usMarketOC].timezone;
        }
            break;
        default:
            break;
    }
    
    
    if (urlString){
        NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        NSLog(@"URL:%@", urlString);
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
            NSString * result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSArray * resultArray = [result componentsSeparatedByString:@"\n"];
            NSArray * chartData = [self extractDataFromResult:resultArray forInterval:request.interval formatter:model session:request.session timezone:timezone];
            
            NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
            if (fillEmpty && request.interval < ChartDataIntervalDay){
                for (NSString * groupingKey in [self getDateListFromData:chartData timezone:model.timezone]){
                    if (request.session == ChartSessionTypeCore || request.session == ChartSessionTypeCombine){
                        NSArray * keyList = [model groupingKeyListForDate:groupingKey forInterval:request.interval];
                        for (NSString * groupKey in keyList){
                            ChartData * emptyData = [[ChartData alloc] initEmptyDataWithGroupingKey:groupKey date:[ChartCommonUtil convertDateFromyyyyMMddHHmm:groupKey timezone:model.timezone]];
                            [dictionary setObject:emptyData forKey:groupKey];
                        }
                        // Intraday .HK code - handle data without 13:00 data
                        if (request.codeType == ChartCodeTypeHKStock) {
                            NSString * sDate = [keyList.firstObject substringToIndex:8];
                            NSString * custKey = [NSString stringWithFormat:@"%@%@", sDate, @"1300" ];
                            if (![keyList containsObject:custKey]) {
                                ChartData * emptyData = [[ChartData alloc] initEmptyDataWithGroupingKey:custKey date:[ChartCommonUtil convertDateFromyyyyMMddHHmm:custKey timezone:model.timezone]];
                                [dictionary setObject:emptyData forKey:custKey];
                            }
                            
                        }
                    }
                    if ([model isKindOfClass:[OpenClosePrePostModel class]]){
                        OpenClosePrePostModel * prePostModel = (OpenClosePrePostModel *)model;
                        if (request.session == ChartSessionTypeCombine || request.session == ChartSessionTypePre){
                            NSArray * keyList = [prePostModel groupingKeyListForPreForDate:groupingKey forInterval:request.interval];
                            for (NSString * groupKey in keyList){
                                ChartData * emptyData = [[ChartData alloc] initEmptyDataWithGroupingKey:groupKey date:[ChartCommonUtil convertDateFromyyyyMMddHHmm:groupKey timezone:prePostModel.timezone]];
                                [dictionary setObject:emptyData forKey:groupKey];
                            }
                        }
                        if (request.session == ChartSessionTypeCombine || request.session == ChartSessionTypePost){
                            NSArray * keyList = [prePostModel groupingKeyListForPostForDate:groupingKey forInterval:request.interval];
                            for (NSString * groupKey in keyList){
                                ChartData * emptyData = [[ChartData alloc] initEmptyDataWithGroupingKey:groupKey date:[ChartCommonUtil convertDateFromyyyyMMddHHmm:groupKey timezone:prePostModel.timezone]];
                                [dictionary setObject:emptyData forKey:groupKey];
                            }
                        }
                    }
                }
                for (ChartData * data in chartData){
                    if ([dictionary objectForKey:data.groupingKey]){
                        ChartData * dt = [dictionary objectForKey:data.groupingKey];
                        [dt mergeWithData:data];
                    } else {
                        [dictionary setObject:data forKey:data.groupingKey];
                    }
                }
                NSArray * sortedKey = [[dictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *  _Nonnull obj1, NSString *  _Nonnull obj2) {
            //        return [obj1 ]
                    if ([obj1 integerValue] == [obj2 integerValue]){
                        return NSOrderedSame;
                    } else if ([obj1 integerValue] < [obj2 integerValue]){
                        return NSOrderedAscending;
                    } else {
                        return NSOrderedDescending;
                    }
                }];
                NSMutableArray * array = [NSMutableArray array];
                for (NSString * key in sortedKey){
                    ChartData * data = [dictionary objectForKey:key];
                    [array addObject:data];
                }
                completion(array);
                return;
            }
            
            completion(chartData);
    //    }];
        }];
    }
}

- (NSArray *)extractDataFromResult:(NSArray *)resultArray forInterval:(ChartDataInterval)interval formatter:(OpenCloseModel *)openCloseModel session:(ChartSessionType)session timezone:(NSTimeZone *)timezone{
    BOOL isFirst = YES;
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    for (NSString * dataStr in resultArray){
//        NSLog(@"ExtractData - dataString %@", dataStr);
        NSArray * valueAry = [dataStr componentsSeparatedByString:@","];
        if ([valueAry count] > 5){
            NSString * key = [valueAry objectAtIndex:0];
            NSString * open = [valueAry objectAtIndex:1];
            NSString * high = [valueAry objectAtIndex:2];
            NSString * low = [valueAry objectAtIndex:3];
            NSString * close = [valueAry objectAtIndex:4];
            NSString * volume = [valueAry objectAtIndex:5];
            
            ChartData * data = [[ChartData alloc] init];
            
            data.date = [self convertDateFromTimestamp:key];
//            NSLog(@"ExtractData - key %@ -> date %@", key, data.date);
            if (openCloseModel){
//            data.groupingKey = key;
//                data.groupingKey = [self convertDateTimeFromTimestamp:key forInterval:interval];
                data.groupingKey = [self convertDateTimeFromDate:data.date forInterval:interval openCloseModel:openCloseModel session:session timezone:timezone];
                if (interval < ChartDataIntervalDay){
                    if (isFirst){
                        isFirst = NO;
                    } else {
                        data.date = [ChartCommonUtil convertDateFromyyyyMMddHHmm:data.groupingKey timezone:openCloseModel.timezone];
                    }
                }
            } else {
                data.groupingKey = [self convertDateTimeFromDate:data.date forInterval:interval openCloseModel:nil session:session timezone:timezone];
            }
            data.open = [open floatValue];
            data.high = [high floatValue];
            data.low = [low floatValue];
            data.close = [close floatValue];
            data.volume = [volume floatValue];
//            [array addObject:data];
            if ([dictionary objectForKey:data.groupingKey]){
                ChartData * dt = [dictionary objectForKey:data.groupingKey];
                [dt mergeWithData:data];
//                dt.high = (dt.high>data.high)?dt.high:data.high;
//                dt.low = (dt.low<data.low)?dt.low:data.low;
//                dt.open = ([dt.date timeIntervalSince1970]>[data.date timeIntervalSince1970])?dt.open:data.open;
//                dt.close = ([dt.date timeIntervalSince1970]<[data.date timeIntervalSince1970])?dt.close:data.close;
//                dt.volume += data.volume;
            } else {
                [dictionary setObject:data forKey:data.groupingKey];
            }
        }
    }
    NSArray * sortedKey = [[dictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *  _Nonnull obj1, NSString *  _Nonnull obj2) {
//        return [obj1 ]
        if ([obj1 integerValue] == [obj2 integerValue]){
            return NSOrderedSame;
        } else if ([obj1 integerValue] < [obj2 integerValue]){
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    NSMutableArray * array = [NSMutableArray array];
    for (NSString * key in sortedKey){
        ChartData * data = [dictionary objectForKey:key];
        [array addObject:data];
    }
    return array;
}

- (NSString *)convertDateTimeFromDate:(NSDate *)date forInterval:(ChartDataInterval)interval openCloseModel:(OpenCloseModel *)openCloseModel session:(ChartSessionType)session timezone:(NSTimeZone *)timezone{
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setTimeZone:timezone];
    NSString * dateFormat = @"";
    switch (interval){
        case ChartDataInterval1Min:
        case ChartDataInterval5Min:
        case ChartDataInterval15Min:
        case ChartDataInterval30Min:
        case ChartDataInterval60Min:
        {
            dateFormat = @"yyyyMMddHHmm";
        }
            break;
        case ChartDataIntervalDay:
        case ChartDataIntervalWeek:
        {
            dateFormat = @"yyyyMMdd";
        }
            break;
        case ChartDataIntervalMonth:
        {
            dateFormat = @"yyyyMM";
        }
            break;
    }
    [objDateformat setDateFormat:dateFormat];
    NSString * dateStr = [objDateformat stringFromDate:date];
//    NSLog(@"ConvertDateTimeFromDate - date %@ -> dateStr %@", date, dateStr);
    if (interval < ChartDataIntervalDay && openCloseModel){
        dateStr = [openCloseModel groupingKeyForyyyyMMddHHmm:dateStr forInterval:interval session:session];
    }
    return dateStr;
}

@end
