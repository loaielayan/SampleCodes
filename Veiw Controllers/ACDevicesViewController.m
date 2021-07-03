//
//  ACDevicesViewController.m
//  Air Conditioner
//
//  Created by loai elayan on 9/5/19.
//  Copyright © 2019 Converged Technology. All rights reserved.
//

#import "ACDevicesViewController.h"

#import "BLDeviceService.h"
#import "BLUserDefaults.h"
//#import <MBProgressHUD/MBProgressHUD.h>
#import <ProgressHUD/ProgressHUD.h>
#import <SideMenu/SideMenu-Swift.h>
#import "Air_Conditioner-Swift.h"
@import CoreTelephony;



@interface ACDevicesViewController ()

@property (nonatomic, strong) NSString *theNewName;
@property (strong, nonatomic) NSMutableArray *showDevices;


@end

@implementation ACDevicesViewController


- (IBAction)revealMenu:(id)sender
{
    
    SideMenuNavigationController *menu = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    SideMenuListViewController *list = menu.viewControllers[0];
    [list setPresentedFromHomePage];
   
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"ar"]){

       menu.leftSide = NO;
    }else{
     
        menu.leftSide = YES;
    }
    
    menu.delegate = self;
    
    
    BridgeViewController *vc = [[BridgeViewController alloc] init];
    [vc setPresentationStyleFor:menu];
    [self presentViewController:menu animated:YES completion: nil];
    
}

UIRefreshControl *refreshControl;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self->canRefresh = true;
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"ar"])
    {
        self.navigationItem.title = @"قائمة الأجهزة";

    }
    
    self.MyDeviceTable.allowsMultipleSelectionDuringEditing = NO;
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"ar"])
    {
            refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"إسحب للأسفل للتحديث"];
    }
    [refreshControl addTarget:self action: @selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    
    [self.MyDeviceTable addSubview:refreshControl];

    
//    __weak typeof(self) weakSelf = self;
//    [NSTimer scheduledTimerWithTimeInterval:10.0f repeats:YES block:^(NSTimer * _Nonnull timer) {
//        [weakSelf.MyDeviceTable reloadData];
//    }];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:true];
    
    [ProgressHUD show];
    [self.MyDeviceTable reloadData];
    
    ///////
//    BLController *controller = [BLLet sharedLet].controller;
//    BLDeviceService *deviceService = [BLDeviceService sharedDeviceService];
//    NSString *did = deviceService.manageDevices.allKeys[0];
//    BLDNADevice *device = [deviceService.manageDevices objectForKey:did];
//    NSString *gatewayDid = device.ownerId ? device.deviceId : device.did;
//    NSString *dataString = @"{}";
//    NSString *result = [controller dnaControl:gatewayDid subDevDid:nil dataStr:dataString command:@"dev_online" scriptPath:nil sendcount:1];
//
//    NSDictionary *retDic = [BLCommonTools deserializeMessageJSON:result];
//    int status = [retDic[@"status"] intValue];
//
//    NSLog(@"%@", retDic);
    //
    
}


-(void) refresh
{
    [self.MyDeviceTable reloadData];
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    if (scrollView.contentOffset.y < -50 ){ //change 100 to whatever you want
        
        if (canRefresh && ![refreshControl isRefreshing]) {
            
            self->canRefresh = false;
            [refreshControl beginRefreshing];
            
            [self refresh]; // your viewController refresh function
        }
    }else if (scrollView.contentOffset.y >= 0) {
        
        self->canRefresh = true;
    }
    
}

- (IBAction)addNewDevice:(UIBarButtonItem *)sender
{
    [self pairDevices];
}

- (void)pairDevices
{
    
    BLDeviceService *deviceService = [BLDeviceService sharedDeviceService];
    self.showDevices = [[NSMutableArray alloc] init];
    
    if (deviceService.scanDevices.allKeys.count != 0){
        for (int i = 0; i < deviceService.scanDevices.allKeys.count; i++)
        {
            NSString *did = deviceService.scanDevices.allKeys[i];
            BLDNADevice *manageDevice = [deviceService.manageDevices objectForKey:did];
            if (!manageDevice)
            {
                [self.showDevices addObject:deviceService.scanDevices.allValues[i]];
                UINavigationController *vc =  [self.storyboard instantiateViewControllerWithIdentifier:@"AvaillableDevicesNavigation"];
                AvaillableDevicesListViewController *dvc = vc.viewControllers[0];
                [dvc setAvaillableDevices:self.showDevices];
                [self presentViewController:vc animated:true completion:nil];
                return;
                
            }
        }
        
        
        UINavigationController *vc =  [self.storyboard instantiateViewControllerWithIdentifier:@"AddDeviceInstructionNavigation"];
        [self presentViewController:vc animated:true completion:nil];

    }else{
        UINavigationController *vc =  [self.storyboard instantiateViewControllerWithIdentifier:@"AddDeviceNavigation"];
        [self presentViewController:vc animated:true completion:nil];
    }
    
    
}




// returned data
// bb 00 07 00 00 00 0f 00 01 11 57 00 29 40 00 20 00 00 00 00 08 00 00 a58d
//                               a  b  c  d  e  f  g  h  i  j  k  l  m

typedef void(^myCompletion)(NSString*);

-(NSString *) getStatus:(NSInteger) index withComp: (myCompletion) compblock
{
    //[ProgressHUD show];
    //[MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString *srcString = @"bb0006800000020011012b7e";
    NSData *srcData = [self hexString2Bytes:srcString];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BLDeviceService *deviceService = [BLDeviceService sharedDeviceService];
        NSString *did = deviceService.manageDevices.allKeys[index];
        BLDNADevice *device = [deviceService.manageDevices objectForKey:did];
        BLPassthroughResult *result = [[BLLet sharedLet].controller dnaPassthrough: device.ownerId ? device.deviceId : [device getDid] passthroughData:srcData];

        
        if ([result succeed]) {
            NSString *resStr = [self data2hexString:[result getData]];
            self->statusResult = resStr;
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%@", resStr);
                [self setCommandAsReadFromStatus:resStr];
//                Command *com = Command.shared;
//                [com setTempAndSwingUpDownWithValue:[resStr substringWithRange:NSMakeRange(20, 2)]];
                
                

                compblock(resStr);
                [ProgressHUD dismiss];
                //[MBProgressHUD hideHUDForView:self.view animated:true];
                
                
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                compblock(nil);
                
                NSLog(@"%@", [NSString stringWithFormat:@"Code(%ld) Msg(%@)", (long)result.getError, result.getMsg]);
                
                [refreshControl endRefreshing];
                [self.MyDeviceTable setContentOffset:CGPointZero animated:true];
                [ProgressHUD dismiss];
                //[MBProgressHUD hideHUDForView:self.view animated:true];
            });
            
        }
    });
    
    return statusResult;
}

-(void)setCommandAsReadFromStatus:(NSString *)command
{
    NSString *dataString = [command substringWithRange:NSMakeRange(20, 26)];
    Command *com = Command.shared;
    [com setDataFramestoCmdArrayWithDataString:dataString];
    
}



- (NSString*)readTemp:(NSString *)command
{
    NSString *AData = [command substringWithRange:NSMakeRange(20, 2)];
    NSString *binaryAData = [self toBinary:AData];
    
    NSLog(@"%@", AData);
    NSLog(@"%@", binaryAData);
    
    NSString *tempData = [binaryAData substringWithRange:NSMakeRange(0, 5)];
    
    NSLog(@"%@", tempData);
    
    
    return tempData; // returns binary value as string
}

- (NSString*)readSwingUpAndDown:(NSString *)command
{
    NSString *AData = [command substringWithRange:NSMakeRange(20, 2)];
    NSString *binaryAData = [self toBinary:AData];
    
    NSString *swingData = [binaryAData substringWithRange:NSMakeRange(4, 3)];
    
    return swingData; // returns binary value as string
    
}

- (NSString*)readOnOff: (NSString *)command
{
    NSString *IData = [command substringWithRange:NSMakeRange(36, 2)];
    NSLog(@"%@", IData);
    NSString *binaryIData = [self toBinary:IData];
    NSLog(@"%@", binaryIData);
    NSString *onOffData = [binaryIData substringWithRange:NSMakeRange(2, 1)];
    NSLog(@"%@", onOffData);
    
    return onOffData; // returns binary value as string
}

-(NSString*)toBinary:(NSString *)hex
{
    
    NSString *binary = @"";
    
    for (int position=0; position < hex.length; position++) {
        

        NSString *ch = [hex substringWithRange:NSMakeRange(position, 1)];
        
        if ([ch isEqualToString:@"0"]) {
            binary = [binary stringByAppendingString:@"0000"];
        } else if ([ch isEqualToString:@"1"]) {
            binary = [binary stringByAppendingString:@"0001"];
        } else if ([ch isEqualToString:@"2"]) {
            binary = [binary stringByAppendingString:@"0010"];
        } else if ([ch isEqualToString:@"3"]) {
            binary = [binary stringByAppendingString:@"0011"];
        } else if ([ch isEqualToString:@"4"]) {
            binary = [binary stringByAppendingString:@"0100"];
        } else if ([ch isEqualToString:@"5"]) {
            binary = [binary stringByAppendingString:@"0101"];
        } else if ([ch isEqualToString:@"6"]) {
            binary = [binary stringByAppendingString:@"0110"];
        } else if ([ch isEqualToString:@"7"]) {
            binary = [binary stringByAppendingString:@"0111"];
        } else if ([ch isEqualToString:@"8"]) {
            binary = [binary stringByAppendingString:@"1000"];
        } else if ([ch isEqualToString:@"9"]) {
            binary = [binary stringByAppendingString:@"1001"];
        } else if ([[ch uppercaseString] isEqualToString:@"A"]) {
            binary = [binary stringByAppendingString:@"1010"];
        } else if ([[ch uppercaseString] isEqualToString:@"B"]) {
            binary = [binary stringByAppendingString:@"1011"];
        } else if ([[ch uppercaseString] isEqualToString:@"C"]) {
            binary = [binary stringByAppendingString:@"1100"];
        } else if ([[ch uppercaseString] isEqualToString:@"D"]) {
           binary = [binary stringByAppendingString:@"1101"];
        } else if ([[ch uppercaseString] isEqualToString:@"E"]) {
            binary = [binary stringByAppendingString:@"1110"];
        } else if ([[ch uppercaseString] isEqualToString:@"F"]) {
            binary = [binary stringByAppendingString:@"1111"];
        }
        
        

    }
    
    return binary;

}

-(int)toDecimal:(NSString *)binary
{
    
    NSInteger decimal = 0;
   
    for (NSInteger position=binary.length - 1; position >= 0; position--)
    {
        
        NSInteger lastIndex = (binary.length - 1);
        
        NSString *ch = [binary substringWithRange:NSMakeRange(position, 1)];
        
        if ([ch  isEqual: @"1"])
        {
            decimal = decimal + pow(2.0, (lastIndex - position));
        }

        
    }
    
    NSLog(@"%d", (int) decimal);
    
    return (int) decimal;
}

bool deviceIsOn = NO;
//- (IBAction)turnON:(UIButton *)sender
//{
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [ProgressHUD show];
//
//    });
//
//    BLDeviceService *deviceService = [BLDeviceService sharedDeviceService];
//    NSString *did = deviceService.manageDevices.allKeys[0];
//    if ([[self getstate:did] isEqualToString:@"OFFLINE"]){
//        return;
//    }
//
//    Command *shared = Command.shared;
//    if (deviceIsOn){
//        [shared setOnOffStatusWithStatus:@"OFF"];
//    }else{
//        [shared setOnOffStatusWithStatus:@"ON"];
//    }
//
//
//    NSString *srcString = [shared getFinalCommand]; /*@"BB00068000000F0001014F0000E00000000020000E00009E6B";*///@"bb00068000000f0001014f0000e00000000020000e0000b09d";
//    NSData *srcData = [self hexString2Bytes:srcString];
//
////    NSLog(@"%@", srcString);
////    NSLog(@"%@", srcData);
//
//
//    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        BLDeviceService *deviceService = [BLDeviceService sharedDeviceService];
//        NSString *did = deviceService.manageDevices.allKeys[0];
//        BLDNADevice *device = [deviceService.manageDevices objectForKey:did];
//        BLPassthroughResult *result = [[BLLet sharedLet].controller dnaPassthrough: device.ownerId ? device.deviceId : [device getDid] passthroughData:srcData];
//        //[MBProgressHUD hideHUDForView:self.view animated:YES];
//
////        NSLog(@"%@", result.msg);
////        NSLog(@"%ld", (long)result.error);
////        NSLog(@"%@", result.data);
////        NSLog(@"%@", [result getData]);
//
//        if ([result succeed]) {
//            NSString *resStr = [self data2hexString:[result getData]];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSLog(@"%@", resStr);
//
//                [self.MyDeviceTable reloadData];
//                [ProgressHUD dismiss];
//
//            });
//
//        } else {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [ProgressHUD dismiss];
//                NSLog(@"%@", [NSString stringWithFormat:@"Code(%ld) Msg(%@)", (long)result.getError, result.getMsg]);
//            });
//
//        }
//    });
//}

- (void)turnOnTheAC:(NSInteger)index{
   
    BLDeviceService *deviceService = [BLDeviceService sharedDeviceService];
    NSString *did = deviceService.manageDevices.allKeys[index];
    if ([[self getstate:did] isEqualToString:@"OFFLINE"]){
        NSString *title = @"The device is offline. Please check your network.";
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"ar"])
        {
            title = @"الجهاز غير متصل. الرجاء التحقق من الشبكة.";
        }
        [self showToastWithMessage:title font:[UIFont systemFontOfSize:16.0]];
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD show];
        
    });
    

    Command *shared = Command.shared;
    if (deviceIsOn){
        [shared setOnOffStatusWithStatus:@"OFF"];
    }else{
        [shared setOnOffStatusWithStatus:@"ON"];
    }
    
    
    NSString *srcString = [shared getFinalCommand]; /*@"BB00068000000F0001014F0000E00000000020000E00009E6B";*///@"bb00068000000f0001014f0000e00000000020000e0000b09d";
    NSData *srcData = [self hexString2Bytes:srcString];
    
    //    NSLog(@"%@", srcString);
    //    NSLog(@"%@", srcData);
    
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BLDeviceService *deviceService = [BLDeviceService sharedDeviceService];
        NSString *did = deviceService.manageDevices.allKeys[0];
        BLDNADevice *device = [deviceService.manageDevices objectForKey:did];
        BLPassthroughResult *result = [[BLLet sharedLet].controller dnaPassthrough: device.ownerId ? device.deviceId : [device getDid] passthroughData:srcData];
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        
        //        NSLog(@"%@", result.msg);
        //        NSLog(@"%ld", (long)result.error);
        //        NSLog(@"%@", result.data);
        //        NSLog(@"%@", [result getData]);
        
        if ([result succeed]) {
            NSString *resStr = [self data2hexString:[result getData]];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%@", resStr);
                
                [self.MyDeviceTable reloadData];
                [ProgressHUD dismiss];
                
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ProgressHUD dismiss];
                NSLog(@"%@", [NSString stringWithFormat:@"Code(%ld) Msg(%@)", (long)result.getError, result.getMsg]);
            });
            
        }
    });
}



#pragma mark - table delegate

//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    BLDeviceService *deviceService = [BLDeviceService sharedDeviceService];
//    NSArray *dids = deviceService.manageDevices.allKeys;
//
//    return dids.count;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//
//    static NSString* cellIdentifier = @"MY_DEVICE_LIST_CELL";
//    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
//
//    BLDeviceService *deviceService = [BLDeviceService sharedDeviceService];
//    NSString *did = deviceService.manageDevices.allKeys[indexPath.row];
//    BLDNADevice *device = [deviceService.manageDevices objectForKey:did];
//
//    UILabel *nameLabel = (UILabel *)[cell viewWithTag:102];
//    nameLabel.text = [device getName];
//
//
//    [self getStatus:indexPath.row withComp:^(NSString *result) {
//
//        if (result){
//            UILabel *tempLabel = (UILabel *)[cell viewWithTag:101];
//            tempLabel.text = [NSString stringWithFormat:@"%i",[self toDecimal:[self readTemp:result]] + 8];
//
//            UILabel *onOffLabel = (UILabel *)[cell viewWithTag:106];
//            UIImageView *switchImage = (UIImageView *)[cell viewWithTag:103];
//            UIImageView *backgroundImage = (UIImageView *)[cell viewWithTag:104];
//            UIView *onImagesView = (UIView *)[cell viewWithTag:105];
//            if ([[self readOnOff:result]  isEqual: @"1"]){
//                switchImage.image = [UIImage imageNamed:@"15xhdpi"];
//                backgroundImage.image = [UIImage imageNamed:@"Asset 33xhdpi-1"];
//                [onImagesView setHidden:NO];
//                [onOffLabel setHidden:YES];
//
//                Command *com = Command.shared;
//                NSString *mode = [com getMode];
//
//
//                if ([mode isEqualToString:@"Auto"]){
//
//                }else if ([mode isEqualToString:@"Cool"]){
//
//                }else if ([mode isEqualToString:@"Dry"]){
//
//                }else if ([mode isEqualToString:@"Heat"]){
//
//                }
//
//                deviceIsOn = YES;
//            }else{
//               deviceIsOn = NO;
//                switchImage.image = [UIImage imageNamed:@"Asset 16xhdpi"];
//                backgroundImage.image = [UIImage imageNamed:@"Asset 34xhdpi-1"];
//                UILabel *onOffLabel = (UILabel *)[cell viewWithTag:106];
//                [onOffLabel setHidden:NO];
//                onOffLabel.text = @"Off";
//                if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"ar"])
//                {
//                    onOffLabel.text = @"مطفئ";
//
//                }
//                [onImagesView setHidden:YES];
//
//            }
//
//        }else{
//
//            UIImageView *switchImage = (UIImageView *)[cell viewWithTag:103];
//            UIImageView *backgroundImage = (UIImageView *)[cell viewWithTag:104];
//            UILabel *onOffLabel = (UILabel *)[cell viewWithTag:106];
//            UIView *onImagesView = (UIView *)[cell viewWithTag:105];
//
//            switchImage.image = [UIImage imageNamed:@"14xhdpi"];
//            backgroundImage.image = [UIImage imageNamed:@"Asset 32xhdpi-1"];
//            [onOffLabel setHidden:NO];
//            [onImagesView setHidden:YES];
//            onOffLabel.text = @"Offline";
//            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"ar"])
//            {
//                onOffLabel.text = @"غير متصل";
//
//            }
//            deviceIsOn = NO;
//
//        }
//    }];
//
//
//    return cell;
//
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    BLDeviceService *deviceService = [BLDeviceService sharedDeviceService];
//    NSString *did = deviceService.manageDevices.allKeys[indexPath.row];
//    BLDNADevice *device = [deviceService.manageDevices objectForKey:did];
//    deviceService.selectDevice = device;
//
//    [self performSegueWithIdentifier:@"OperateView" sender:device];
//}

NSInteger i = 0;
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier  isEqual: @"OperateView"]){
        ACDetailsViewController *details = segue.destinationViewController;
        [details setIndexWithIndex:i];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BLDeviceService *deviceService = [BLDeviceService sharedDeviceService];
    NSArray *dids = deviceService.manageDevices.allKeys;
    
    return dids.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"MY_DEVICE_LIST_CELL";
    ACTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ACTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setWithIndex:indexPath.row delegate:self];

    BLDeviceService *deviceService = [BLDeviceService sharedDeviceService];
    NSString *did = deviceService.manageDevices.allKeys[indexPath.row];
    BLDNADevice *device = [deviceService.manageDevices objectForKey:did];

    UILabel *nameLabel = (UILabel *)[cell viewWithTag:102];
    nameLabel.text = [device getName];


    [self getStatus:indexPath.row withComp:^(NSString *result) {

        if (result){
            UILabel *tempLabel = (UILabel *)[cell viewWithTag:101];
            tempLabel.text = [NSString stringWithFormat:@"%i",[self toDecimal:[self readTemp:result]] + 8];
            UILabel *tempUnitLabel = (UILabel *)[cell viewWithTag:110];
            BridgeViewController *vc = [[BridgeViewController alloc] init];
            if ([[vc getTempUnit]  isEqual: @"f"]){
                tempUnitLabel.text = @"℉";
                int tempDecimal = [self toDecimal:[self readTemp:result]];
                tempLabel.text = [NSString stringWithFormat:@"%i",( ((tempDecimal + 8) * 9/5) + 32 )];
            }else{
                tempUnitLabel.text = @"℃";
            }

            UILabel *onOffLabel = (UILabel *)[cell viewWithTag:106];
            UIImageView *switchImage = (UIImageView *)[cell viewWithTag:103];
            UIImageView *backgroundImage = (UIImageView *)[cell viewWithTag:104];
            UIView *onImagesView = (UIView *)[cell viewWithTag:105];
            UIImageView *modeImageView = (UIImageView *)[cell viewWithTag:107];
            UIImageView *fanSpeedImageView = (UIImageView *)[cell viewWithTag:108];

            if ([[self readOnOff:result]  isEqual: @"1"]){
                switchImage.image = [UIImage imageNamed:@"15xhdpi"];
                backgroundImage.image = [UIImage imageNamed:@"Asset 33xhdpi-1"];
                [onImagesView setHidden:NO];
                [onOffLabel setHidden:YES];

                Command *com = Command.shared;
                NSString *mode = [com getMode];


                if ([mode isEqualToString:@"Auto"]){
                    modeImageView.image = [UIImage imageNamed:@"AutoModeHomePage"];

                }else if ([mode isEqualToString:@"Cool"]){
                    modeImageView.image = [UIImage imageNamed:@"coolModeHomePage"];

                }else if ([mode isEqualToString:@"Dry"]){
                    modeImageView.image = [UIImage imageNamed:@"dryModeHomePage"];

                }else if ([mode isEqualToString:@"Heat"]){
                    modeImageView.image = [UIImage imageNamed:@"heatModeHomePage"];

                }else if ([mode isEqualToString:@"Fan"]){
                    modeImageView.image = [UIImage imageNamed:@"fanModeHomePage"];

                }

                if ([com.cmdArray[14 - 1] intValue] == 96){
                   fanSpeedImageView.image = [UIImage imageNamed:@"FixationLowHomePage"];
                }else if ([com.cmdArray[14 - 1] intValue] == 32){
                    fanSpeedImageView.image = [UIImage imageNamed:@"FixationHighHomepage"];
                    //fanSpeedImageView.image = [UIImage imageNamed:@"FixationMidHomePage"];
                }else if ([com.cmdArray[14 - 1] intValue] == 64){
                    fanSpeedImageView.image = [UIImage imageNamed:@"FixationMidHomePage"];
                }
//                else if ([com.cmdArray[14 - 1] intValue] == 160){
//                    fanSpeedImageView.image = [UIImage imageNamed:@"FixationHighHomepage"];
//                }

                deviceIsOn = YES;
            }else{
                deviceIsOn = NO;
                switchImage.image = [UIImage imageNamed:@"14xhdpi"];
                backgroundImage.image = [UIImage imageNamed:@"Asset 32xhdpi-1"];

                UILabel *onOffLabel = (UILabel *)[cell viewWithTag:106];
                [onOffLabel setHidden:NO];
                onOffLabel.text = @"Off";
                if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"ar"])
                {
                    onOffLabel.text = @"مطفئ";

                }
                [onImagesView setHidden:YES];

            }

        }else{

            UIImageView *switchImage = (UIImageView *)[cell viewWithTag:103];
            UIImageView *backgroundImage = (UIImageView *)[cell viewWithTag:104];
            UILabel *onOffLabel = (UILabel *)[cell viewWithTag:106];
            UIView *onImagesView = (UIView *)[cell viewWithTag:105];

            switchImage.image = [UIImage imageNamed:@"Asset 16xhdpi"];
            backgroundImage.image = [UIImage imageNamed:@"Asset 34xhdpi-1"];
            [onOffLabel setHidden:NO];
            [onImagesView setHidden:YES];
            onOffLabel.text = @"Offline";
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"ar"])
            {
                onOffLabel.text = @"غير متصل";

            }
            deviceIsOn = NO;

        }

        [refreshControl endRefreshing];
        [self.MyDeviceTable setContentOffset:CGPointZero animated:true];
    }];

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!deviceIsOn){
        return;
    }
    
    BLDeviceService *deviceService = [BLDeviceService sharedDeviceService];
    NSString *did = deviceService.manageDevices.allKeys[indexPath.row];
    BLDNADevice *device = [deviceService.manageDevices objectForKey:did];
    deviceService.selectDevice = device;
    i = indexPath.row;
    [self performSegueWithIdentifier:@"OperateView" sender:device];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad){
        return 250;
    }
    return 190;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}



- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title: ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Change Name" : @"تغيير الأسم" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        // Action begining

        BridgeViewController *vc = [[BridgeViewController alloc] init];
        if ([vc isConnectedToCellulerNetwork]){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Name Can't be changed over celluler data network" : @"لا يمكن تغيير الأسم باستخدام شبكة الهاتف المحمول " message: @"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Ok" : @"موافق" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:true completion:nil];
            return;
        }

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Change Name" : @"تغيير الأسم" message:([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Please choose device name" : @"الرجاء اختيار أسم جديد للجهاز" preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.text = @"";
            textField.placeholder = ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Change Name" : @"تغيير الأسم";
        }];
        UIAlertAction *changeNameAction = [UIAlertAction actionWithTitle:([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Ok" : @"موافق" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

            NSString *newDeviceName = alert.textFields.firstObject.text;
            if (newDeviceName.length == 0){
                
                return;
            }
            [ProgressHUD show];
            //[MBProgressHUD showHUDAddedTo:self.view animated:true];
            BLController *controller = [BLLet sharedLet].controller;
            BLDeviceService *deviceService = [BLDeviceService sharedDeviceService];
            NSString *did = deviceService.manageDevices.allKeys[indexPath.row];
            BLDNADevice *device = [deviceService.manageDevices objectForKey:did];
            NSString *gatewayDid = device.ownerId ? device.deviceId : device.did;
            NSString *dataString = [NSString stringWithFormat:@"{\"data\":{\"name\":\"%@\",\"lock\":false}}", newDeviceName];
            NSString *result = [controller dnaControl:gatewayDid subDevDid:nil dataStr:dataString command:@"dev_info" scriptPath:nil sendcount:1];
            
            NSDictionary *retDic = [BLCommonTools deserializeMessageJSON:result];
            int status = [retDic[@"status"] intValue];

            __weak typeof(self) weakSelf = self;
            [NSTimer scheduledTimerWithTimeInterval:4.0f repeats:NO block:^(NSTimer * _Nonnull timer) {
                [ProgressHUD dismiss];
                //[MBProgressHUD hideHUDForView:self.view animated:true];
                [weakSelf.MyDeviceTable reloadData];
            }];
            
            NSLog(@"%d", status);
         // Action  End
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Cancel" : @"إلغاء" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:changeNameAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:true completion:nil];
    }];
    editAction.backgroundColor = [UIColor colorWithRed:168/255.0f green:192/255.0f blue:41/255.0f alpha:1.0f];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Delete" : @"حذف" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Delete Device" : @"حذف الجهاز" message: ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Are you sure you want to delete device" : @"هل أنت متأكد من حذف الجهاز" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Delete" : @"حذف" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            BLDeviceService *deviceService = [BLDeviceService sharedDeviceService];
            NSString *did = deviceService.manageDevices.allKeys[indexPath.row];
            [deviceService removeDevice:did];
            [self.MyDeviceTable reloadData];
        
            
            if (deviceService.manageDevices.count == 0){
                [self pairDevices];
//                UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddDeviceNavigation"];
//                [self presentViewController:navVC animated:true completion:nil];
            }
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Cancel" : @"إلغاء" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:deleteAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:true completion:nil];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    return @[deleteAction,editAction];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Detemine if it's in editing mode

//    if (tableView.editing)
//    {
//        return UITableViewCellEditingStyleDelete;
//    }

    return UITableViewCellEditingStyleNone;

}

//- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    NSString *title = NSLocalizedString(@"Favorite", comment: "Favorite");
//
//    UIContextualAction *action = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:title
//                                                                       handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
//
//                                                                       }];
//
//
//    action.backgroundColor = UIColor.redColor;
//    UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:[NSArray arrayWithObject:action]];
//    return configuration;
//}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIContextualAction *editAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Change Name" : @"تغيير الأسم"
                                                                           handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
                                                                               
                                                                               BridgeViewController *vc = [[BridgeViewController alloc] init];
                                                                               if ([vc isConnectedToCellulerNetwork]){
                                                                                   UIAlertController *alert = [UIAlertController alertControllerWithTitle:([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Name Can't be changed over celluler data network" : @"لا يمكن تغيير الأسم باستخدام شبكة الهاتف المحمول " message: @"" preferredStyle:UIAlertControllerStyleAlert];
                                                                                   UIAlertAction *action = [UIAlertAction actionWithTitle:([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Ok" : @"موافق" style:UIAlertActionStyleCancel handler:nil];
                                                                                   [alert addAction:action];
                                                                                   [self presentViewController:alert animated:true completion:nil];
                                                                                   return;
                                                                               }
                                                                               
                                                                               UIAlertController *alert = [UIAlertController alertControllerWithTitle:([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Change Name" : @"تغيير الأسم" message:([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Please enter a new name or cancel to keep existing name" : @" الرجاء اختيار أسم جديد للجهاز" preferredStyle:UIAlertControllerStyleAlert];
                                                                               [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                                                                                   textField.text = @"";
                                                                                   textField.placeholder = ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Change Name" : @"تغيير الأسم";
                                                                               }];
                                                                               UIAlertAction *changeNameAction = [UIAlertAction actionWithTitle:([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Ok" : @"موافق" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                                                                                   
                                                                                   NSString *newDeviceName = alert.textFields.firstObject.text;
                                                                                   if (newDeviceName.length == 0){
                                                                                       //
                                                                                       [alert dismissViewControllerAnimated:true completion:nil];
                                                                                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Change Name" : @"تغيير الأسم" message:([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Please enter a new name or cancel to keep existing name" : @" الرجاء اختيار أسم جديد للجهاز" preferredStyle:UIAlertControllerStyleAlert];
                                                                                       UIAlertAction *action = [UIAlertAction actionWithTitle:([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Ok" : @"موافق" style:UIAlertActionStyleCancel handler:nil];
                                                                                       [alert addAction:action];
                                                                                       [self presentViewController:alert animated:true completion:nil];
                                                                                       //
                                                                                       return;
                                                                                   }
                                                                                   [ProgressHUD show];
                                                                                   //[MBProgressHUD showHUDAddedTo:self.view animated:true];
                                                                                   BLController *controller = [BLLet sharedLet].controller;
                                                                                   BLDeviceService *deviceService = [BLDeviceService sharedDeviceService];
                                                                                   NSString *did = deviceService.manageDevices.allKeys[indexPath.row];
                                                                                   BLDNADevice *device = [deviceService.manageDevices objectForKey:did];
                                                                                   NSString *gatewayDid = device.ownerId ? device.deviceId : device.did;
                                                                                   NSString *dataString = [NSString stringWithFormat:@"{\"data\":{\"name\":\"%@\",\"lock\":false}}", newDeviceName];
                                                                                   NSString *result = [controller dnaControl:gatewayDid subDevDid:nil dataStr:dataString command:@"dev_info" scriptPath:nil sendcount:1];
                                                                                   
                                                                                   NSDictionary *retDic = [BLCommonTools deserializeMessageJSON:result];
                                                                                   int status = [retDic[@"status"] intValue];
                                                                                   
                                                                                   __weak typeof(self) weakSelf = self;
                                                                                   [NSTimer scheduledTimerWithTimeInterval:4.0f repeats:NO block:^(NSTimer * _Nonnull timer) {
                                                                                       [ProgressHUD dismiss];
                                                                                       //[MBProgressHUD hideHUDForView:self.view animated:true];
                                                                                       [weakSelf.MyDeviceTable reloadData];
                                                                                   }];
                                                                                   
                                                                                   NSLog(@"%d", status);
                                                                                   
                                                                               }];
                                                                               UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Cancel" : @"إلغاء" style:UIAlertActionStyleCancel handler:nil];
                                                                               [alert addAction:changeNameAction];
                                                                               [alert addAction:cancelAction];
                                                                               [self presentViewController:alert animated:true completion:nil];
                                                                               
                                                                           }];
    
    editAction.backgroundColor = [UIColor colorWithRed:168/255.0f green:192/255.0f blue:41/255.0f alpha:1.0f];
    
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Delete" : @"حذف"
                                                                             handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
                                                                                 
                                                                                 UIAlertController *alert = [UIAlertController alertControllerWithTitle:([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Delete Device" : @"حذف الجهاز" message: ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Are you sure you want to delete device" : @"هل أنت متأكد من حذف الجهاز" preferredStyle:UIAlertControllerStyleActionSheet];
                                                                                 UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Delete" : @"حذف" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                                                                                     BLDeviceService *deviceService = [BLDeviceService sharedDeviceService];
                                                                                     NSString *did = deviceService.manageDevices.allKeys[indexPath.row];
                                                                                     [deviceService removeDevice:did];
                                                                                     [self.MyDeviceTable reloadData];
                                                                                     
                                                                                     
                                                                                     if (deviceService.manageDevices.count == 0){
                                                                                         [self pairDevices];
                                                                                         //                UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddDeviceNavigation"];
                                                                                         //                [self presentViewController:navVC animated:true completion:nil];
                                                                                     }
                                                                                     
                                                                                 }];
                                                                                 UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Cancel" : @"إلغاء" style:UIAlertActionStyleCancel handler:nil];
                                                                                 [alert addAction:deleteAction];
                                                                                 [alert addAction:cancelAction];
                                                                                 [self presentViewController:alert animated:true completion:nil];
                                                                                 
                                                                             }];
    
    
    deleteAction.backgroundColor = [UIColor redColor];
    
    BLDeviceService *deviceService = [BLDeviceService sharedDeviceService];
    NSString *did = deviceService.manageDevices.allKeys[indexPath.row];
    
    if ([[self getstate:did] isEqualToString:@"OFFLINE"] || [[self getstate:did] isEqualToString:@"REMOTE"]) {
        UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:[NSArray arrayWithObjects: deleteAction, nil]];
        configuration.performsFirstActionWithFullSwipe = false;
        return configuration;
    }
    

    UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:[NSArray arrayWithObjects: deleteAction,editAction, nil]];
    configuration.performsFirstActionWithFullSwipe = false;
    return configuration;
}


//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Device" message:@"Are you sure you want to delete device" preferredStyle:UIAlertControllerStyleActionSheet];
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//            BLDeviceService *deviceService = [BLDeviceService sharedDeviceService];
//            NSString *did = deviceService.manageDevices.allKeys[indexPath.row];
//            [deviceService removeDevice:did];
//            [self.MyDeviceTable reloadData];
//
//        }];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
//        [alert addAction:action];
//        [alert addAction:cancelAction];
//        [self presentViewController:alert animated:true completion:nil];
//
//    }else if (editingStyle == UITableViewCellEditingStyleInsert){
//
//    }
//}



- (NSString *)getstate:(NSString *)did
{
    BLDeviceStatusEnum state = [[BLLet sharedLet].controller queryDeviceState:did];
    
    NSString *stateString = @"State UnKown";
    switch (state) {
        case BL_DEVICE_STATE_LAN:
            stateString = @"LAN";
            break;
        case BL_DEVICE_STATE_REMOTE:
            stateString = @"REMOTE";
            break;
        case BL_DEVICE_STATE_OFFLINE:
            stateString = @"OFFLINE";
            break;
        default:
            break;
    }
    return stateString;
}



#pragma mark - private method
- (NSData *)hexString2Bytes:(NSString *)hexStr
{
    const char *hex = [[hexStr lowercaseString] cStringUsingEncoding:NSUTF8StringEncoding];
    int length = (int)strlen(hex);
    int i;
    NSMutableData *result = [[NSMutableData alloc] init];
    
    if (length % 2) {
        NSLog(@"%@ not a valid hex string ,length = %d", hexStr, length);
        return nil;
    }
    
    for (i=0; i<length/2; i++) {
        unsigned int value;
        unsigned char bin;
        NSString *hexCharStr = [hexStr substringWithRange:NSMakeRange(i*2, 2)];
        NSScanner *scanner = [[NSScanner alloc] initWithString:[NSString stringWithFormat:@"0x%@", hexCharStr]];
        
        if (![scanner scanHexInt:&value]) {
            NSLog(@"hexStr: %@, i: %d", hexStr, i);
            NSLog(@"%@ not a valid hex char", hexCharStr);
            return nil;
        }
        
        bin = value & 0xff;
        
        [result appendBytes:&bin length:1];
    }
    
    
    return result;
}


- (NSString *)data2hexString:(NSData *)data {
    int count = (int)data.length;
    const unsigned char* temp = (const unsigned char*)data.bytes;
    NSMutableString *string = [[NSMutableString alloc] init];
    for (int i = 0; i < count; i++)
    {
        [string appendFormat:@"%02x",*(temp+i)];
    }
    return string;
}

#pragma mark - Side Menu Navigation delegate

- (void)sideMenuDidAppearWithMenu:(SideMenuNavigationController *)menu animated:(BOOL)animated{
    
}

- (void)sideMenuWillAppearWithMenu:(SideMenuNavigationController *)menu animated:(BOOL)animated{
    
    //[self.view setAlpha:0.5f];
}

- (void)sideMenuDidDisappearWithMenu:(SideMenuNavigationController *)menu animated:(BOOL)animated{
    
}

- (void)sideMenuWillDisappearWithMenu:(SideMenuNavigationController *)menu animated:(BOOL)animated{
 
    //[self.view setAlpha:1.0f];
}

@end
