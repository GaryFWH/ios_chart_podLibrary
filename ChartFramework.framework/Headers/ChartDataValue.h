//
//  ChartDataValue.h
//  ChartLibraryDemo
//
//  Created by william on 2/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChartDataValue : NSObject

@property (nonatomic, strong) NSString * groupingKey;
@property (nonatomic, assign) CGFloat value;

@end

NS_ASSUME_NONNULL_END
