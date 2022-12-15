//
//  TISelectCollectionViewController.m
//  ChartLibraryDemo
//
//  Created by william on 18/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "TISelectCollectionViewController.h"
#import "TISelectCollectionViewCell.h"

//struct TIOption {
//    NSString * displayName;
//    NSString * tiClassName;
//};

@interface TISelectCollectionViewController () <UICollectionViewDelegateFlowLayout>

//@property (nonatomic, strong) NSArray * mainTIList;
//@property (nonatomic, strong) NSArray * subTIList;
@property (nonatomic, strong) UIButton *tiSetupBtn;
@property (nonatomic, strong) UIButton *tiDoneBtn;
//@property (nonatomic, weak) UILabel *headerLabel;


@property (nonatomic, strong) TIConfigViewController * tiConfigViewController;

@end

@implementation TISelectCollectionViewController

static NSString * const reuseIdentifier = @"Cell";
static NSString * const reuseMainTIHeaderIdentifier = @"MainTIHeader";
static NSString * const reuseSubTIHeaderIdentifier = @"SubTIHeader";

- (instancetype)init {
    if (self = [super initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]]){
        self.collectionView.delegate = self;
    }
    return self;
}

//- (instancetype)initWithMainTIList:(NSArray *)mainTIList subTIList:(NSArray *)subTIList {
//    if (self = [self init]){
//        self.mainTIList = mainTIList;
//        self.subTIList = subTIList;
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.layer.cornerRadius = 3.0;
    self.view.clipsToBounds = YES;
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
//    self.collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    // Register cell classes
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[TISelectCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:[TISelectCollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseMainTIHeaderIdentifier];
    [self.collectionView registerClass:[TISelectCollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseSubTIHeaderIdentifier];

    // Do any additional setup after loading the view.
    [self.collectionView reloadData];
}
//
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initView];
    [self updateColor];
    [self.collectionView reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 2;
}

- (NSString *)displayNameForMainTI:(ChartMainTIEnum)mainTI {
    switch (mainTI) {
        case ChartMainTINone:
            return @"None";
        case ChartMainTIEnumSMA:
            return @"SMA\n簡單移動平均線";
            break;
        case ChartMainTIEnumWMA:
            return @"WMA\n加權移動平均線";
            break;
        case ChartMainTIEnumEMA:
            return @"EMA\n指數移動平均線";
            break;
        case ChartMainTIEnumSAR:
            return @"SAR\n拋物線";
            break;
        case ChartMainTIEnumBB:
            return @"BB\n保力加通道";
            break;
            
        default:
            return @"";
            break;
    }
}

- (NSString *)displayNameForSubTI:(ChartSubTIEnum)subTI {
    switch (subTI) {
        case ChartSubTIEnumDMI:
            return @"DMI\n趨向指標";
            break;
        case ChartSubTIEnumMACD:
            return @"MACD\n移動平均匯聚背馳指標";
            break;
        case ChartSubTIEnumOBV:
            return @"OBV\n淨值成交量";
        case ChartSubTIEnumROC:
            return @"ROC\n發動速度指標";
        case ChartSubTIEnumRSI:
            return @"RSI\n相對強弱指數";
        case ChartSubTIEnumSTCFast:
            return @"STC-Fast\n快步隨機指數";
        case ChartSubTIEnumSTCSlow:
            return @"STC-Slow\n慢步隨機指數";
        case ChartSubTIEnumVOL:
            return @"VOL\n成交量";
        case ChartSubTIEnumWill:
            return @"WILL %R\n威廉指數";
        default:
            return @"";
            break;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (section == 0){
        return ChartMainTITotalCount;
    }
    if (section == 1){
        return ChartSubTITotalCount;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TISelectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [cell.tiSelectLabel setText:@""];

    // Configure the cell
    switch (indexPath.section){
        case 0:
        {
            if (indexPath.item < ChartMainTITotalCount){
//                [cell.tiSelectLabel setText:[[self.mainTIList objectAtIndex:indexPath.item] objectForKey:@"displayName"]];
                [cell.tiSelectLabel setText:[self displayNameForMainTI:(ChartMainTIEnum)indexPath.item]];
            }
            cell.tiSelectLabel.backgroundColor = [UIColor whiteColor];
            if (self.tiDelegate && [self.tiDelegate respondsToSelector:@selector(mainTIIsCurrentSelected:)]){
//                if ([self.tiDelegate mainTIIsCurrentSelected:[[self.mainTIList objectAtIndex:indexPath.item] objectForKey:@"tiname"]]){
//                    cell.tiSelectLabel.backgroundColor = [UIColor yellowColor];
//                }
                if ([self.tiDelegate mainTIIsCurrentSelected:(ChartMainTIEnum)indexPath.item]){
//                    cell.tiSelectLabel.backgroundColor = [UIColor yellowColor];
                    cell.tiSelectLabel.backgroundColor = [ChartColorConfig color255WithRed:217 green:235 blue:255 alpha:1];
                }
            }
            
        }
            break;
        case 1:
        {
            if (indexPath.item < ChartSubTITotalCount){
//                [cell.tiSelectLabel setText:[[self.subTIList objectAtIndex:indexPath.item] objectForKey:@"displayName"]];
                [cell.tiSelectLabel setText:[self displayNameForSubTI:(ChartSubTIEnum)indexPath.item]];
            }
            cell.tiSelectLabel.backgroundColor = [UIColor whiteColor];
            if (self.tiDelegate && [self.tiDelegate respondsToSelector:@selector(subTICurrentSelected:)]){
//                if ([self.tiDelegate subTICurrentSelected:[[self.subTIList objectAtIndex:indexPath.item] objectForKey:@"tiname"]]){
//                    cell.tiSelectLabel.backgroundColor = [UIColor yellowColor];
//                }
                if ([self.tiDelegate subTICurrentSelected:(ChartSubTIEnum)indexPath.item]){
//                    cell.tiSelectLabel.backgroundColor = [UIColor yellowColor];
                    cell.tiSelectLabel.backgroundColor = [ChartColorConfig color255WithRed:217 green:235 blue:255 alpha:1];
                }
            }
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView * reusableView = nil;
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 40)];
    headerLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    headerLabel.textColor = [UIColor blackColor];
    
    if (kind == UICollectionElementKindSectionHeader) {
        switch (indexPath.section) {
            case 0:
            {
                reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseMainTIHeaderIdentifier forIndexPath:indexPath];
                headerLabel.text = @"Main-TI (1 at most)";
                
                if (self.tiSetupBtn) {
                    self.tiSetupBtn.frame = CGRectMake(reusableView.frame.size.width - 110, 0, 50, 40);
                    [reusableView addSubview:self.tiSetupBtn];
                }
                if (self.tiDoneBtn) {
                    self.tiDoneBtn.frame = CGRectMake(reusableView.frame.size.width - 50, 0, 50, 40);
                    [reusableView addSubview:self.tiDoneBtn];
                }
                break;
            }
            case 1:
            {
                reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseSubTIHeaderIdentifier forIndexPath:indexPath];
                headerLabel.text = @"Sub-TI";
                break;
            }
                
            default:
                break;
        }

    }
    [reusableView addSubview:headerLabel];
    return reusableView;
}

#pragma mark <UICollectionViewDelegate>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width /2 - 10, 50.f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    return CGSizeMake(self.view.frame.size.width, 20.f);
    return CGSizeMake(self.view.frame.size.width, 40.f);

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section){
        case 0:
        {
            if (indexPath.item < ChartMainTITotalCount){
                if (self.tiDelegate && [self.tiDelegate respondsToSelector:@selector(selectedMainTI:)]){
                    ChartMainTIEnum mainTI = (ChartMainTIEnum)indexPath.item;
                    [self.tiDelegate selectedMainTI:mainTI];
//                    [self.tiDelegate selectedMainTI:[[self.mainTIList objectAtIndex:indexPath.item] objectForKey:@"tiname"]];
                    [collectionView reloadData];
                }
            }
        }
            break;
        case 1:
        {
            if (indexPath.item < ChartSubTITotalCount){
                if (self.tiDelegate && [self.tiDelegate respondsToSelector:@selector(selectedSubTI:)]){
                    ChartSubTIEnum subTI = (ChartSubTIEnum)indexPath.item;
//                    [self.tiDelegate selectedSubTI:[[self.subTIList objectAtIndex:indexPath.item] objectForKey:@"tiname"]];
                    [self.tiDelegate selectedSubTI:subTI];
                    [collectionView reloadData];
                }
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark Delegate
- (void)onBtn_TiSetup {
    [self.tiDelegate didClickTISetup];
}

- (void)onBtn_TiDone {
    [self.tiDelegate didClickTIDone];
}

#pragma mark Private
- (void)initView {
    self.tiSetupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tiSetupBtn setFrame:CGRectMake(self.view.frame.size.width, 0, 50, 40)];
    [self.tiSetupBtn addTarget:self action:@selector(onBtn_TiSetup) forControlEvents:UIControlEventTouchUpInside];
    
    self.tiDoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tiDoneBtn setFrame:CGRectMake(self.view.frame.size.width, 0, 50, 40)];
    [self.tiDoneBtn addTarget:self action:@selector(onBtn_TiDone) forControlEvents:UIControlEventTouchUpInside];
}

- (void)updateColor {
    [self.tiSetupBtn setTitle:@"Setup" forState:UIControlStateNormal];
    [self.tiSetupBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self.tiSetupBtn setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    
    [self.tiDoneBtn setTitle:@"Done" forState:UIControlStateNormal];
    [self.tiDoneBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self.tiDoneBtn setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
}
/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end

