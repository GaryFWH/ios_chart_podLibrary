//
//  TIConfigViewController.h
//  ChartLibraryDemo
//
//  Created by william on 16/7/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ChartFramework/ChartFramework.h>
//#import "ChartTIConfig.h"
//#import "ChartColorConfig.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TIConfigViewControllerDelegate;

@interface TIConfigViewController : UIViewController <UITextFieldDelegate>

@property (assign, nonatomic) id<TIConfigViewControllerDelegate> delegate;

- (instancetype)initWithTiConfig:(ChartTIConfig*)tiConfig;

@end

@protocol TIConfigViewControllerDelegate <NSObject>

-(void)didClickConfirmBtn:(TIConfigViewController*)tiConfigViewController ChartTIConfig:(ChartTIConfig*)tiConfig;
-(void)didClickBackBtn:(TIConfigViewController*)tiConfigViewController;

@end

NS_ASSUME_NONNULL_END
