//
//  TISelectCollectionViewController.h
//  ChartLibraryDemo
//
//  Created by william on 18/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ChartFramework/ChartFramework.h>
//#import "ChartConst.h"
#import "TIConfigViewController.h"
//#import "ChartColorConfig.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TISelectCollectionViewControllerDelegate;
@interface TISelectCollectionViewController : UICollectionViewController

@property (assign, nonatomic) id<TISelectCollectionViewControllerDelegate> tiDelegate;
//- (instancetype)initWithMainTIList:(NSArray *)mainTIList subTIList:(NSArray *)subTIList;

@end

@protocol TISelectCollectionViewControllerDelegate <NSObject>

//- (BOOL)mainTICurrentSelected:(NSString *)mainTI;
//- (BOOL)subTICurrentSelected:(NSString *)subTI;
//
//- (void)selectedMainTI:(NSString *)mainTI;
//- (void)selectedSubTI:(NSString *)subTI;

- (BOOL)mainTIIsCurrentSelected:(ChartMainTIEnum)mainTI;
- (BOOL)subTICurrentSelected:(ChartSubTIEnum)subTI;

- (void)selectedMainTI:(ChartMainTIEnum)mainTI;
- (void)selectedSubTI:(ChartSubTIEnum)subTI;
- (void)didClickTISetup;
- (void)didClickTIDone;

@end

NS_ASSUME_NONNULL_END
