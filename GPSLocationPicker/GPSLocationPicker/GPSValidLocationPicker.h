//
//  GPSValidLocationPicker.h
//  GPSLocationPicker
//
//  Created by long on 15/10/10.
//  Copyright © 2015年 long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

#define kIsShowGPSDetailInfo @"isShowDetailInfo"

typedef void (^ValidLocationResult)(CLLocation *location, NSError *error);

@interface GPSValidLocationPicker : NSObject

//定位超时时间（单位:s）， 默认为-100
@property (nonatomic, assign) int timeoutPeriod;
//定位期望精度（单位:m），默认为-100
@property (nonatomic, assign) CLLocationAccuracy precision;
//当前坐标
@property (nonatomic, assign) CLLocationCoordinate2D nowCoordinate;
//定位有效距离（单位:m），默认为-100
@property (nonatomic, assign) CLLocationDistance validDistance;


+ (instancetype)shareGPSValidLocationPicker;
/**
 * @brief 启动定位，如果需要对超时时长、采集到的坐标精度和有效距离做要求， 则需要在调用该方法之前对 timeoutPeriod, precision, nowCoordinate, valiDistance 做一个对应的赋值
 */
- (void)startLocationAndCompletion:(ValidLocationResult)completion;

/**
 * @brief 重置变量为默认值
 */
- (void)resetDefaultVariable;

@end
