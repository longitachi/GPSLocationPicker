# GPSLocationPicker
多功能定位，可自定义定位时长，有效精度和有效距离等。可根据用户设置是否显示GPS定位详情

由于以下测试是在室内，并且处于静止状态，所以采集精度和有效距离可能不会改变，实时应用时会比测试效果好很多

定位中，如果拿到符合标准的坐标，便可直接回调

###使用方法非常简单

```objc
/** 获取单例对象 */
GPSValidLocationPicker *gpsPicker = [GPSValidLocationPicker shareGPSValidLocationPicker];
/** 因为该类设计为单例模式，所以如果多处用则可能出现有些地方设置了变量值保留的问题，所以尽量在调用定位前进行一次重置 */
[gpsPicker resetDefaultVariable];
//测试用值
//定位超时时长
gpsPicker.timeoutPeriod = 5;
//定位有效精度
gpsPicker.precision = 10;
//定位有效距离
gpsPicker.validDistance = 100;

//这个坐标是测试用的,根据实际需求传入
CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(31.138, 121.338);
gpsPicker.nowCoordinate = coord;

/** 启动定位 */
[gpsPicker startLocationAndCompletion:^(CLLocation *location, NSError *error) {
        if (error) {
            _textView.text = [NSString stringWithFormat:@"未采集到符合精度的坐标，错误信息:%@", error];
            NSLog(@"未采集到符合精度的坐标，错误信息:%@", error);
        } else {
            _textView.text = [NSString stringWithFormat:@"采集到符合精度的坐标经度%f, 维度%f", location.coordinate.longitude, location.coordinate.latitude];
            NSLog(@"采集到符合精度的坐标经度%f, 维度%f", location.coordinate.longitude, location.coordinate.latitude);
        }
    }];
@end
```

###不显示定位详情的效果图
![image](https://github.com/longitachi/GPSLocationPicker/blob/master/效果图/不显示定位详情.gif)

###显示定位详情的效果图
![image](https://github.com/longitachi/GPSLocationPicker/blob/master/效果图/显示定位详情.gif)
