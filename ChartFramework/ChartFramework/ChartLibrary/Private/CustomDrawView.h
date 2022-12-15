//
//  TIValueView.h
//  ChartLibraryDemo
//
//  Created by william on 21/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CustomDrawViewDelegate;
@interface CustomDrawView : UIView

@property (nonatomic, assign) id<CustomDrawViewDelegate> delegate;

- (instancetype)initWithDelegate:(id<CustomDrawViewDelegate>)delegate;


@end

@protocol CustomDrawViewDelegate <NSObject>

- (void)customDrawView:(CustomDrawView *)valueView drawRect:(CGRect)rect context:(CGContextRef)context;

@end

NS_ASSUME_NONNULL_END
