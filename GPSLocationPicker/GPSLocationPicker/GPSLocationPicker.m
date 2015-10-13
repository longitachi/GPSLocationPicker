//
//  GPSLocationPicker.m
//  vsfa
//
//  Created by long on 15/8/13.
//  Copyright (c) 2015年 AZYK. All rights reserved.
//

#import "GPSLocationPicker.h"

@interface GPSLocationPicker () <CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    LocationResult _locationResultBlock;
    BOOL _isStop;
}

@end

@implementation GPSLocationPicker

static GPSLocationPicker *picker = nil;

+ (instancetype)shareGPSLocationPicker
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        picker = [[GPSLocationPicker alloc] init];
    });
    return picker;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{   //onceToken是GCD用来记录是否执行过 ，如果已经执行过就不再执行(保证执行一次）
        picker = [super allocWithZone:zone];
    });
    return picker;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _precision = -1;
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([[[UIDevice currentDevice] systemVersion] doubleValue] > 8.0) {
                [_locationManager requestWhenInUseAuthorization];
            } else {
                [_locationManager startUpdatingLocation];
            }
            break;
        case kCLAuthorizationStatusDenied:
            //请打开系统设置中\"隐私->定位服务\",允许使用您的位置。
            break;
        case kCLAuthorizationStatusRestricted:
            //定位服务无法使用！
            break;
            
        default:
            [_locationManager startUpdatingLocation];//开启位置更新
            break;
    }
}

#pragma mark - 启动定位
- (void)startLocationAndCompletion:(LocationResult)completion
{
    //初始化CLLocationManager
    if (_locationManager) {
        _isStop = NO;
        _locationManager = nil;
    }
    if (_locationResultBlock) {
        _locationResultBlock = nil;
    }
    NSLog(@"启动定位");
    
    _locationResultBlock = completion;
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] > 8.0)
    {
        [_locationManager requestAlwaysAuthorization];// 前后台同时定位
    }
    [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (_isStop) {
        return;
    }
    
    //得到Location
    CLLocation *coord = [locations objectAtIndex:0];
    
    NSLog(@"采集到的坐标经度:%f, 维度:%f  精度%f", coord.coordinate.longitude, coord.coordinate.latitude, coord.horizontalAccuracy);
    //判断采集到的精度
    if (_locationResultBlock && !_isStop && (self.precision == -1 || coord.horizontalAccuracy <= self.precision)) {
        _locationResultBlock(coord, nil);
    }
}

#pragma mark - 定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位失败:%@", error);
    if (!_isStop && _precision == -1 && _locationResultBlock) {
        _locationResultBlock(kZeroLocation, error);
    }
}

- (void)stop
{
    _isStop = YES;
    [_locationManager stopUpdatingLocation];
}

@end
