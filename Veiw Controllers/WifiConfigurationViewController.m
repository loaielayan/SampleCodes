//
//  WifiConfigurationViewController.m
//  Air Conditioner
//
//  Created by loai elayan on 8/7/19.
//  Copyright © 2019 Converged Technology. All rights reserved.
//

#import "WifiConfigurationViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <BLLetBase/BLLetBase.h>
#import <BLLetCore/BLLetCore.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "BLDeviceService.h"
#import "Air_Conditioner-Swift.h"
#import <LanguageManager_iOS/LanguageManager_iOS-Swift.h>
#import <ProgressHUD/ProgressHUD.h>

@interface WifiConfigurationViewController ()

@property (strong, nonatomic) NSMutableArray *showDevices;



@end

@implementation WifiConfigurationViewController

- (IBAction)back:(id)sender
{
   [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"ar"])
    {
        
        [self.navigationItem setTitle:@"إتصال ب WiFi"];
        
        [self.arrowImage setTransform:CGAffineTransformMakeScale(-1, 1)];
        [self.arrowImage2 setTransform:CGAffineTransformMakeScale(-1, 1)];
        
        [self.nextButton setTitle:@"التالي" forState:UIControlStateNormal];
        [self.backButton setTitle:@"السابق" forState:UIControlStateNormal];
        
        self.ssidNameField.placeholder = @"أسم الشبكة";
        self.passwordField.placeholder = @"الرقم السري";
        [self.changeButton setTitle:@"تغيير" forState:UIControlStateNormal];
        [self.showButton setTitle:@"اظهار" forState:UIControlStateNormal];
        
        self.ssidNameField.textAlignment = NSTextAlignmentRight;
        self.passwordField.textAlignment = NSTextAlignmentRight;
        
        
        
    }else{
       [self.navigationItem setTitle:@"Connect WiFi"];
        
        [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
        [self.backButton setTitle:@"Back" forState:UIControlStateNormal];
        
        self.ssidNameField.placeholder = @"Wifi Name";
        self.passwordField.placeholder = @"Password";
        [self.changeButton setTitle:@"Change" forState:UIControlStateNormal];
        [self.showButton setTitle:@"Show" forState:UIControlStateNormal];
        
        self.ssidNameField.textAlignment = NSTextAlignmentLeft;
        self.passwordField.textAlignment = NSTextAlignmentLeft;

    }
    
    
    
    

    
    
    _showDevices = [[NSMutableArray alloc] init];
    
    //self.view.backgroundColor = UIColor.grayColor;
    //self.contentView.backgroundColor = UIColor.whiteColor;
//    self.contentView.layer.borderWidth = 1.0f;
//    self.contentView.layer.borderColor = [UIColor colorWithRed:168.0f/255 green:192.0f/255 blue:41.0f/255 alpha:1].CGColor;
//    self.contentView.layer.cornerRadius = 30.0f;
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    BridgeViewController *vc = [[BridgeViewController alloc] init];
    NSArray *ssids = [vc currentSSIDs];
    NSString *ssid;
    if (ssids.count != 0){
     ssid = ssids[0];
    }
    
    NSLog(@"%@", ssids);
    NSLog(@"%@", ssid);
    self.ssidNameField.text = ssid;//[self getCurrentSSIDInfo];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //[[BLLet sharedLet].controller deviceConfigCancel];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier  isEqual: @"ShowProgress"]){
        ProgressViewController *dvc = segue.destinationViewController;
        dvc.ssidName = self.ssidNameField.text;
        dvc.password = self.passwordField.text;
        dvc.delegate = self;
    }
}



- (IBAction)showButtonAction:(UIButton *)sender
{
    self.passwordField.secureTextEntry = !self.passwordField.secureTextEntry;
    if (self.passwordField.secureTextEntry){
        [sender setTitle: ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Show" : @"إظهار" forState:UIControlStateNormal];
    }else{
        [sender setTitle: ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Hide" : @"إخفاء" forState:UIControlStateNormal];
    }
}


- (IBAction)nextButton:(id)sender
{
    if (self.ssidNameField.text && self.ssidNameField.text.length > 0) //&& self.passwordField.text && self.passwordField.text.length > 0)
    {
//        if (self.passwordField.text.length < 8){
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Password should be at least 8 characters long" : @"كلمة السر يجب أن تكون بطول ٨ أحرف على الأقل" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *action = [UIAlertAction actionWithTitle: ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Ok" : @"موافق" style:UIAlertActionStyleCancel handler:nil];
//            [alert addAction:action];
//            [self presentViewController:alert animated:true completion:nil];
//            return;
//        }
        
        [self performSegueWithIdentifier:@"ShowProgress" sender:self];
    }else{
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message: ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Please Fill Wifi Name" : @"الرجاء تعبئة اسم الشبكة" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Ok" : @"موافق" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:true completion:nil];
        
    }
    
}



bool notScanned = NO;

- (void)startConfigurationWithCompletion: (void (^ _Nonnull)(BOOL))completion {
    //
    //    if (notScanned){
    //        [self pairDevices];
    //        return;
    //    }
    //
    [self.ssidNameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
    NSString *ssidName = self.ssidNameField.text;
    NSString *password = self.passwordField.text;
    
    //[self.resultLabel setHidden:NO];
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDate *date = [NSDate date];
        NSLog(@"====Start Config===");
        BLDeviceConfigResult *result = [[BLLet sharedLet].controller deviceConfig:ssidName password:password version:3 timeout:45];
        NSLog(@"====Config over! Spends(%fs)", [date timeIntervalSinceNow]);
        dispatch_async(dispatch_get_main_queue(), ^{
            //[self hideIndicatorOnWindow];
            if ([result succeed]) {
                
                
                self.resultLabel.text = [NSString stringWithFormat:@"Code(%ld) Msg(%@) Did(%@) Devaddr(%@) Mac(%@)", (long)result.getError, result.getMsg, result.getDid, result.getDevaddr, result.getMac];
                
                //                [NSTimer scheduledTimerWithTimeInterval:3.0
                //                                                 target:self
                //                                               selector:@selector(pairDevices)
                //                                               userInfo:nil
                //                                                repeats:NO];
                completion(YES);
                
            } else {
                
                [self.textFieldsView setHidden:NO];
                
                self.resultLabel.text = [NSString stringWithFormat:@"Code(%ld) Msg(%@)", (long)result.getError, result.getMsg];
                completion(NO);
                //[MBProgressHUD hideHUDForView:self.view animated:YES];
                
            }
        });
    });

}

- (void)complete
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Please choose the device name" : @"الرجاء إختيار إسم جديد للجهاز" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = @"new AC";
        textField.placeholder = ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Change Name" : @"تغيير الأسم";
    }];
    UIAlertAction *changeNameAction = [UIAlertAction actionWithTitle:([[[NSUserDefaults standardUserDefaults] valueForKey:@"LanguageManagerSelectedLanguage"]  isEqual: @"en"]) ? @"Ok" : @"موافق" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *newDeviceName = alert.textFields.firstObject.text;
        if (newDeviceName.length == 0){
            
            return;
        }
        [ProgressHUD show];
        BLController *controller = [BLLet sharedLet].controller;
        BLDeviceService *deviceService = [BLDeviceService sharedDeviceService];
        NSString *did = deviceService.manageDevices.allKeys[0];
        BLDNADevice *device = [deviceService.manageDevices objectForKey:did];
        NSString *gatewayDid = device.ownerId ? device.deviceId : device.did;
        NSString *dataString = [NSString stringWithFormat:@"{\"data\":{\"name\":\"%@\",\"lock\":false}}", newDeviceName];
        NSString *result = [controller dnaControl:gatewayDid subDevDid:nil dataStr:dataString command:@"dev_info" scriptPath:nil sendcount:1];
        
        NSDictionary *retDic = [BLCommonTools deserializeMessageJSON:result];
        int status = [retDic[@"status"] intValue];
        
        __weak typeof(self) weakSelf = self;
        [NSTimer scheduledTimerWithTimeInterval:4.0f repeats:NO block:^(NSTimer * _Nonnull timer) {
            [ProgressHUD dismiss];
            [weakSelf performSegueWithIdentifier:@"ShowDevices" sender:self];
            //[weakSelf.MyDeviceTable reloadData];
        }];
        
        NSLog(@"%d", status);
        
    }];
    [alert addAction:changeNameAction];
    [self presentViewController:alert animated:true completion:nil];
    
    
    
}

- (void)startConfiguration:(void(^)(void))complete
{
//
//    if (notScanned){
//        [self pairDevices];
//        return;
//    }
//
    [self.ssidNameField resignFirstResponder];
    [self.passwordField resignFirstResponder];

    NSString *ssidName = self.ssidNameField.text;
    NSString *password = self.passwordField.text;

    [self.resultLabel setHidden:NO];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDate *date = [NSDate date];
        NSLog(@"====Start Config===");
        BLDeviceConfigResult *result = [[BLLet sharedLet].controller deviceConfig:ssidName password:password version:3 timeout:45];
        NSLog(@"====Config over! Spends(%fs)", [date timeIntervalSinceNow]);
        dispatch_async(dispatch_get_main_queue(), ^{
            //[self hideIndicatorOnWindow];
            if ([result succeed]) {


                self.resultLabel.text = [NSString stringWithFormat:@"Code(%ld) Msg(%@) Did(%@) Devaddr(%@) Mac(%@)", (long)result.getError, result.getMsg, result.getDid, result.getDevaddr, result.getMac];

//                [NSTimer scheduledTimerWithTimeInterval:3.0
//                                                 target:self
//                                               selector:@selector(pairDevices)
//                                               userInfo:nil
//                                                repeats:NO];
                complete();

            } else {

                [self.textFieldsView setHidden:NO];

                self.resultLabel.text = [NSString stringWithFormat:@"Code(%ld) Msg(%@)", (long)result.getError, result.getMsg];
                [MBProgressHUD hideHUDForView:self.view animated:YES];

            }
        });
    });


}



- (void)pairDevices
{
    
    if (notScanned){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    BLDeviceService *deviceService = [BLDeviceService sharedDeviceService];
    NSLog(@"%@", deviceService.scanDevices.allKeys);
    if (deviceService.scanDevices.allKeys.count == 0){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        notScanned = YES;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Fail to pair device" message:@"please try again" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        [self.nextButton setTitle:@"Try again" forState:UIControlStateNormal];
        return;
    }
    
    notScanned = NO;
    for (int i = 0; i < deviceService.scanDevices.allKeys.count; i++) {
        NSLog(@"%lu", (unsigned long)deviceService.scanDevices.allKeys.count);
        NSString *did = deviceService.scanDevices.allKeys[i];
        BLDNADevice *manageDevice = [deviceService.manageDevices objectForKey:did];
        NSLog(@"%@", manageDevice);
        if (!manageDevice) {
            [self.showDevices addObject:deviceService.scanDevices[did]];
            
            NSLog(@"%@", self.showDevices);
            NSLog(@"%@", deviceService.scanDevices);
            
            [self storeDeviceIndex];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }
}


- (void)storeDeviceIndex
{

    for (int index = 0; index < self.showDevices.count; index++)
    {
        BLDNADevice *device = self.showDevices[index];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //Pair Device,Get RemoteControl Id and Key
            BLPairResult *result = [[BLLet sharedLet].controller pairWithDevice:device];
            if ([result succeed]) {
                device.controlId = result.getId;
                device.controlKey = result.getKey;
                //                BLUserDefaults* userDefault = [BLUserDefaults shareUserDefaults];
                //                device.ownerId = [userDefault getUserId];
                BLDeviceService *deviceService = [BLDeviceService sharedDeviceService];
                [deviceService addNewDeivce:device];
                NSLog(@"Device %@ Added", device);
                
                [self performSegueWithIdentifier:@"ShowDevices" sender:self];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //[BLStatusBar showTipMessageWithStatus:[NSString stringWithFormat:@"Pair Success,%ld,%@",(long)result.getId,result.getKey]];
                    //[self.deviceListTableView reloadData];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"Fail to pair Device");
                });
            }
        });
        
    }
    
//    BLDeviceService *deviceService = [BLDeviceService sharedDeviceService];
//    NSArray *dids = deviceService.manageDevices.allKeys;
//
//    NSLog(@"%@", dids);
//
//    if (dids.count == 0)
//    {
//
//
//    }else{
//
//      [self performSegueWithIdentifier:@"ShowDevices" sender:self];
//
//    }


}


//- (void)setUpHeaderView
//{
//    UIView *headerView = [[UIView alloc] init];
//    self.view.backgroundColor = UIColor.lightGrayColor;
//    headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
//    headerView.backgroundColor = UIColor.whiteColor;
//    UIImageView *backArrrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, headerView.frame.size.height / 2, 35, 35)];
//    backArrrowImageView.image = [UIImage imageNamed:@"back"];
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, headerView.frame.size.height / 2, 35, 35)];
//    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [headerView addSubview:backArrrowImageView];
//    [headerView addSubview:button];
//    [self.view addSubview:headerView];
//}

- (NSString *)getCurrentSSIDInfo
{
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    id info = nil;
    
    for (NSString *ifnam in ifs)
    {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
    
    return [info objectForKey:@"SSID"];
}

#pragma mark - text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}




@end
