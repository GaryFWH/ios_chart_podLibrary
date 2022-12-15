//
//  OCTime.h
//  ChartRecreate
//
//  Created by william on 7/4/2021.
//  Copyright © 2021 william. All rights reserved.
//

//Class for Open and Close time for market

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCTime : NSObject

//timestamp seconds from 00:00
@property (nonatomic, assign) NSInteger morning_open_timestamp; //0900 =
@property (nonatomic, assign) NSInteger morning_close_timestamp; //1200 =
@property (nonatomic, assign) NSInteger cutoff_timestamp;
@property (nonatomic, assign) NSInteger afternoon_open_timestamp;
@property (nonatomic, assign) NSInteger afternoon_close_timestamp;

@end

NS_ASSUME_NONNULL_END
