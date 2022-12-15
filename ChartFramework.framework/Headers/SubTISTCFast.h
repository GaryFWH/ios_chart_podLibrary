//
//  SubTISTCFast.h
//  ChartLibraryDemo
//
//  Created by Gary on 25/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "ChartTI.h"

NS_ASSUME_NONNULL_BEGIN

@interface SubTISTCFastUnit : NSObject

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger kDay;
@property (nonatomic, assign) NSInteger dDay;

@property (nonatomic, strong) UIColor * kColor;
@property (nonatomic, strong) UIColor * dColor;

- (NSString *)objectKey:(NSString*)lineKey;

@end

@interface SubTISTCFast : ChartTI

@property (nonatomic, strong) SubTISTCFastUnit * unit;

@end

NS_ASSUME_NONNULL_END
