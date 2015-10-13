//
//  ViewController.m
//  GPSLocationPicker
//
//  Created by long on 15/10/10.
//  Copyright © 2015年 long. All rights reserved.
//

#import "ViewController.h"
#import "GPSValidLocationPicker.h"
#import "GPSLocationPicker.h"

@interface ViewController ()
{
    IBOutlet UISwitch *_mySwitch;
    IBOutlet UITextView *_textView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mySwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kIsShowGPSDetailInfo];
    _textView.text = nil;
    _textView.layer.masksToBounds = YES;
    _textView.layer.cornerRadius = 3.0f;
    _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textView.layer.borderWidth = 1.0f;
}

- (IBAction)switchChanged:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:_mySwitch.isOn forKey:kIsShowGPSDetailInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)btnLocation_click:(id)sender
{
    GPSValidLocationPicker *gpsPicker = [GPSValidLocationPicker shareGPSValidLocationPicker];
    //因为该类设计为单例模式，所以如果多处用则可能出现有些地方设置了变量值保留的问题，所以尽量在调用定位前进行一次重置
    [gpsPicker resetDefaultVariable];
    //测试用值
    gpsPicker.timeoutPeriod = 5;
    gpsPicker.precision = 10;
    gpsPicker.validDistance = 100;
    //这个坐标是测试用的,根据实际需求传入
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(31.138, 121.338);
    gpsPicker.nowCoordinate = coord;
    [gpsPicker startLocationAndCompletion:^(CLLocation *location, NSError *error) {
        if (error) {
            _textView.text = [NSString stringWithFormat:@"未采集到符合精度的坐标，错误信息:%@", error];
            NSLog(@"未采集到符合精度的坐标，错误信息:%@", error);
        } else {
            _textView.text = [NSString stringWithFormat:@"采集到符合精度的坐标经度%f, 维度%f", location.coordinate.longitude, location.coordinate.latitude];
            NSLog(@"采集到符合精度的坐标经度%f, 维度%f", location.coordinate.longitude, location.coordinate.latitude);
        }
    }];
    
    //反地理编码解析地理位置
    [[GPSLocationPicker shareGPSLocationPicker] geocodeAddressWithCoordinate:coord completion:^(NSString *address) {
        NSLog(@"解析到的地址:%@", address);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
