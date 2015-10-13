//
//  GPSValidLocationPicker.m
//  GPSLocationPicker
//
//  Created by long on 15/10/10.
//  Copyright © 2015年 long. All rights reserved.
//

#import "GPSValidLocationPicker.h"
#import "GPSLocationPicker.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+DetailLabelAlignment.h"

#define kDefaultValue -100

@interface GPSValidLocationPicker () <CLLocationManagerDelegate, MBProgressHUDDelegate>
{
    CLLocationAccuracy _nowPrecision;//定位拿到的精度
    CLLocationDistance _collectDistance;//当前采集到的点与用户传进来的点的距离
    NSTimer *_timer;
    
    MBProgressHUD *_waitView;
    int _totalTime;
    ValidLocationResult _locationResultBlock;
}

@end

@implementation GPSValidLocationPicker

static GPSValidLocationPicker *_ValidLocationPicker = nil;

+ (instancetype)shareGPSValidLocationPicker
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _ValidLocationPicker = [[self alloc] init];
    });
    return _ValidLocationPicker;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _ValidLocationPicker = [super allocWithZone:zone];
    });
    return _ValidLocationPicker;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self resetDefaultVariable];
    }
    return self;
}

- (void)resetDefaultVariable
{
    _nowPrecision = _timeoutPeriod = _precision = _validDistance = _collectDistance = kDefaultValue;
}

#pragma mark - 启动定位
- (void)startLocationAndCompletion:(ValidLocationResult)completion
{
    if (_locationResultBlock) {
        _locationResultBlock = nil;
    }
    _locationResultBlock = completion;
    
    _totalTime = self.timeoutPeriod;
    //显示等待视图
    [self beginWaiting:@"定位中，请稍后。。。" mode:_totalTime>0?MBProgressHUDModeDeterminateHorizontalBar:MBProgressHUDModeIndeterminate];
    
    if (_timeoutPeriod > 0) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    
    [self startGetLocation];
}

- (void)startGetLocation
{
    //这里设置为-1，使GPSLocationPicker拿到坐标后直接回调
    [GPSLocationPicker shareGPSLocationPicker].precision = -1;
    [[GPSLocationPicker shareGPSLocationPicker] startLocationAndCompletion:^(CLLocation *location, NSError *error) {
        [self judgeNowLocationIsValid:location];
    }];
}

#pragma mark - 判断当前采集到的坐标是否符合标准
- (void)judgeNowLocationIsValid:(CLLocation *)pickCoord
{
    _nowPrecision = pickCoord.horizontalAccuracy;
    
    //首先判断坐标是否有效
    if ( pickCoord.coordinate.latitude == 0 || pickCoord.coordinate.longitude == 0) {
        return;
    }
    
    if (_precision == kDefaultValue && _validDistance == kDefaultValue) {
        //没有精度和有效距离的限制,当前坐标有效
        [self locationSuccess:pickCoord];
        return;
    }
    
    BOOL coordIsValid = YES;
    
    if (_precision != kDefaultValue && _nowPrecision >= _precision) {
        coordIsValid = NO;
    }
    if (_validDistance != kDefaultValue
        && _nowCoordinate.latitude != 0
        && _nowCoordinate.longitude != 0
        && [self coordIsValid:pickCoord] == NO) {
        coordIsValid = NO;
    }
    //如果坐标符合期望精度及有效距离
    if (coordIsValid) {
        NSLog(@"符合了标准:%d", coordIsValid);
        [self locationSuccess:pickCoord];
    }
}

#pragma mark - 显示更新定位进度
- (void)updateProgress
{
    if (_timeoutPeriod == -1) {
        //定位超时
        [self locationTimeOut:[NSError errorWithDomain:@"location failed" code:-1 userInfo:nil]];
        return;
    }
    
    if (!_waitView) {
        [self beginWaiting:@"定位中，请稍后。。。" mode:MBProgressHUDModeDeterminateHorizontalBar];
    }
    _timeoutPeriod--;
   _waitView.detailsLabelText = [self getGPSDetailInfo];
    if (_totalTime > 0) {
        _waitView.progress = (float)(_totalTime-_timeoutPeriod)/_totalTime;
    }
}

#pragma mark - 拿到符合标准的坐标
- (void)locationSuccess:(CLLocation *)coord
{
    NSLog(@"%s", __FUNCTION__);
    [_timer invalidate];
    [_waitView hide:YES];
    [[GPSLocationPicker shareGPSLocationPicker] stop];
    if (_locationResultBlock) {
        _locationResultBlock(coord, nil);
    }
}

#pragma mark - 定位超时
- (void)locationTimeOut:(NSError *)error
{
    NSLog(@"%s", __FUNCTION__);
    [_timer invalidate];
    [[GPSLocationPicker shareGPSLocationPicker] stop];
    [_waitView hide:YES];
    if (_locationResultBlock) {
        _locationResultBlock(kZeroLocation, kLocationFailedError);
    }
}

- (NSString *)getGPSDetailInfo
{
    //是否显示gps详情 (根据用户需要进行设置)
    BOOL isShowGPSDetail = [[NSUserDefaults standardUserDefaults] boolForKey:kIsShowGPSDetailInfo];
    
    NSMutableString *detailStr = [NSMutableString string];
    if (_timeoutPeriod != kDefaultValue) {
        if (_timeoutPeriod >= 0) {
            [detailStr appendString:[NSString stringWithFormat:@"等待时间:%d", _timeoutPeriod]];
        } else {
            [detailStr appendString:@"定位超时"];
        }
    }
    if (_precision != kDefaultValue && isShowGPSDetail) {
        [detailStr appendString:[NSString stringWithFormat:@"\n标准精度:%.0f米", self.precision]];
        if (_nowPrecision != kDefaultValue) {
            [detailStr appendString:[NSString stringWithFormat:@"\n当前精度:%.0f米", _nowPrecision]];
        }
    }
    if (_validDistance != kDefaultValue && isShowGPSDetail) {
        [detailStr appendString:[NSString stringWithFormat:@"\n标准距离:%.0f米", self.validDistance]];
        if (_collectDistance != kDefaultValue) {
            [detailStr appendString:[NSString stringWithFormat:@"\n当前距离:%.0f米", _collectDistance]];
        } else {
            [detailStr appendFormat:@"\n当前距离∞米"];
        }
    }
    return detailStr.length == 0 ? @"" : detailStr;
}

#pragma mark - 计算采集到的坐标与传入坐标距离是否符合标准
- (BOOL)coordIsValid:(CLLocation *)nowLocation
{
    if (nowLocation.coordinate.latitude == 0 || nowLocation.coordinate.longitude == 0) {
        return NO;
    }
    CLLocation *lastLocation = [[CLLocation alloc] initWithLatitude:self.nowCoordinate.latitude longitude:self.nowCoordinate.longitude];
    
    CLLocationDistance distance = [nowLocation distanceFromLocation:lastLocation];
    
    _collectDistance = distance;
    NSLog(@"距离:%f", distance);
    if (distance <= _validDistance) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - 显示等待视图
-(void)beginWaiting:(NSString *)message mode:(MBProgressHUDMode)mode
{
    if (!_waitView) {
        _waitView = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
        [[UIApplication sharedApplication].keyWindow addSubview:_waitView];
        _waitView.delegate = self;
        _waitView.square = NO;
        _waitView.mode = mode;
        [_waitView setDetailLabelAlignment:NSTextAlignmentLeft];
    }
    
    _waitView.labelText = message;
    _waitView.detailsLabelText = [self getGPSDetailInfo];
    [_waitView show:YES];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    _waitView = nil;
}

@end
