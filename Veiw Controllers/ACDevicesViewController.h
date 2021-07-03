//
//  ACDevicesViewController.h
//  Air Conditioner
//
//  Created by loai elayan on 9/5/19.
//  Copyright © 2019 Converged Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SideMenu/SideMenu-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACDevicesViewController : UIViewController<SideMenuNavigationControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>{
    NSString *statusResult;
    BOOL canRefresh;
    
    
}

typedef void(^myCompletion)(NSString*);

@property (weak, nonatomic) IBOutlet UITableView *MyDeviceTable;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (NSData *)hexString2Bytes:(NSString *)hexStr;
- (NSString *)data2hexString:(NSData *)data;
- (NSString*)readTemp:(NSString *)command;
-(int)toDecimal:(NSString *)binary;
-(NSString *) getStatus:(NSInteger) index withComp: (myCompletion) compblock;
- (void)turnOnTheAC:(NSInteger)index;


@end

NS_ASSUME_NONNULL_END
