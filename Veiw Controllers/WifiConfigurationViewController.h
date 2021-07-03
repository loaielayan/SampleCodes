//
//  WifiConfigurationViewController.h
//  Air Conditioner
//
//  Created by loai elayan on 8/7/19.
//  Copyright © 2019 Converged Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Air_Conditioner-Swift.h"
#import <TextFieldEffects-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@interface WifiConfigurationViewController : UIViewController <UITextFieldDelegate, CompleteProgress>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *ssidNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIView *textFieldsView;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet KaedeTextField *wifiNameField;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage2;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;
@property (weak, nonatomic) IBOutlet UIButton *showButton;



@end



NS_ASSUME_NONNULL_END
