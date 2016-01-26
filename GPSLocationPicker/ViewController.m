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
}

@property (weak, nonatomic) IBOutlet UITextView *textView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _textView.text = nil;
    _textView.layer.masksToBounds = YES;
    _textView.layer.cornerRadius = 3.0f;
    _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textView.layer.borderWidth = 1.0f;
}

- (IBAction)btnLocation_click:(id)sender
{
    GPSValidLocationPicker *gpsPicker = [GPSValidLocationPicker shareGPSValidLocationPicker];
    //因为该类设计为单例模式，所以如果多处用则可能出现有些地方设置了变量值保留的问题，所以尽量在调用定位前进行一次重置
    [gpsPicker resetDefaultVariable];
    //测试用值
    gpsPicker.timeoutPeriod = 5;
    gpsPicker.precision = 100;
    gpsPicker.validDistance = 1000;
    //下面三个变量的默认值均为yes
    gpsPicker.showWaitView = YES;
    gpsPicker.showLocTime = YES;
    gpsPicker.showDetailInfo = YES;
    
    gpsPicker.mode = GPSValidLocationPickerModeDeterminateHorizontalBar;
    //这个坐标是测试用的,根据实际需求传入
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(31.138, 121.338);
    gpsPicker.nowCoordinate = coord;
    
    __weak typeof(self) weakSelf = self;
    [gpsPicker startLocationAndCompletion:^(CLLocation *location, NSError *error) {
        if (error) {
            weakSelf.textView.text = [NSString stringWithFormat:@"未采集到符合精度的坐标，错误信息:%@", error];
            NSLog(@"未采集到符合精度的坐标，错误信息:%@", error);
        } else {
            NSLog(@"采集到符合精度的坐标经度%f, 维度%f", location.coordinate.longitude, location.coordinate.latitude);
            //反地理编码解析地理位置
            [[GPSLocationPicker shareGPSLocationPicker] geocodeAddressWithCoordinate:location.coordinate completion:^(NSString *address) {
                NSLog(@"解析到的地址:%@", address);
                weakSelf.textView.text = [NSString stringWithFormat:@"采集到符合精度的坐标经度：%f \n维度：%f \n对应地址：%@", location.coordinate.longitude, location.coordinate.latitude, address];
            }];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
