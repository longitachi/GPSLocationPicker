# GPSLocationPicker
多功能定位，可自定义定位时长，有效精度和有效距离等。可根据用户设置是否显示GPS定位详情

由于以下测试是在室内，并且处于静止状态，所以采集精度和有效距离可能不会改变，实时应用时会比测试效果好很多

定位中，如果拿到符合标准的坐标，便可直接回调

###使用方法非常简单

<p style="margin-top: 0px; margin-bottom: 0px; font-size: 16px; line-height: normal; font-family: Menlo; color: rgb(79, 129, 135);">
	GPSValidLocationPicker<span style="font-variant-ligatures: no-common-ligatures; color: #000000"> *gpsPicker = [</span>GPSValidLocationPicker<span style="font-variant-ligatures: no-common-ligatures; color: #000000"> </span><span style="font-variant-ligatures: no-common-ligatures; color: #31595d">shareGPSValidLocationPicker</span><span style="font-variant-ligatures: no-common-ligatures; color: #000000">];</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; font-size: 16px; line-height: normal; font-family: 'PingFang SC'; color: rgb(0, 132, 0);">
	<span style="line-height: normal; font-family: Menlo; color: rgb(0, 0, 0);">&nbsp; &nbsp; </span><span style="line-height: normal; font-family: Menlo;">//</span>因为该类设计为单例模式，所以如果多处用则可能出现有些地方设置了变量值保留的问题，所以尽量在调用定位前进行一次重置
</p>
<p style="margin-top: 0px; margin-bottom: 0px; font-size: 16px; line-height: normal; font-family: Menlo; color: rgb(49, 89, 93);">
	<span style="font-variant-ligatures: no-common-ligatures; color: #000000">&nbsp; &nbsp; [gpsPicker </span>resetDefaultVariable<span style="font-variant-ligatures: no-common-ligatures; color: #000000">];</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; font-size: 16px; line-height: normal; font-family: Menlo; color: rgb(0, 132, 0);">
	<span style="font-variant-ligatures: no-common-ligatures; color: #000000">&nbsp; &nbsp; </span>//<span style="line-height: normal; font-family: 'PingFang SC';">测试用值</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; font-size: 16px; line-height: normal; font-family: Menlo;">
	&nbsp; &nbsp; gpsPicker.<span style="font-variant-ligatures: no-common-ligatures; color: #4f8187">timeoutPeriod</span> = <span style="font-variant-ligatures: no-common-ligatures; color: #272ad8">5</span>;
</p>
<p style="margin-top: 0px; margin-bottom: 0px; font-size: 16px; line-height: normal; font-family: Menlo;">
	&nbsp; &nbsp; gpsPicker.<span style="font-variant-ligatures: no-common-ligatures; color: #4f8187">precision</span> = <span style="font-variant-ligatures: no-common-ligatures; color: #272ad8">10</span>;
</p>
<p style="margin-top: 0px; margin-bottom: 0px; font-size: 16px; line-height: normal; font-family: Menlo;">
	&nbsp; &nbsp; gpsPicker.<span style="font-variant-ligatures: no-common-ligatures; color: #4f8187">validDistance</span> = <span style="font-variant-ligatures: no-common-ligatures; color: #272ad8">100</span>;
</p>
<p style="margin-top: 0px; margin-bottom: 0px; font-size: 16px; line-height: normal; font-family: 'PingFang SC'; color: rgb(0, 132, 0);">
	<span style="line-height: normal; font-family: Menlo; color: rgb(0, 0, 0);">&nbsp; &nbsp; </span><span style="line-height: normal; font-family: Menlo;">//</span>这个坐标是测试用的<span style="line-height: normal; font-family: Menlo;">,</span>根据实际需求传入
</p>
<p style="margin-top: 0px; margin-bottom: 0px; font-size: 16px; line-height: normal; font-family: Menlo; color: rgb(61, 29, 129);">
	<span style="font-variant-ligatures: no-common-ligatures; color: #000000">&nbsp; &nbsp; </span><span style="font-variant-ligatures: no-common-ligatures; color: #703daa">CLLocationCoordinate2D</span><span style="font-variant-ligatures: no-common-ligatures; color: #000000"> coord = </span>CLLocationCoordinate2DMake<span style="font-variant-ligatures: no-common-ligatures; color: #000000">(</span><span style="font-variant-ligatures: no-common-ligatures; color: #272ad8">31.138</span><span style="font-variant-ligatures: no-common-ligatures; color: #000000">, </span><span style="font-variant-ligatures: no-common-ligatures; color: #272ad8">121.338</span><span style="font-variant-ligatures: no-common-ligatures; color: #000000">);</span>
</p>
<p style="margin-top: 0px; margin-bottom: 0px; font-size: 16px; line-height: normal; font-family: Menlo;">
	&nbsp; &nbsp; gpsPicker.<span style="font-variant-ligatures: no-common-ligatures; color: #4f8187">nowCoordinate</span> = coord;
</p>
<p style="margin-top: 0px; margin-bottom: 0px; font-size: 16px; line-height: normal; font-family: Menlo;">
	&nbsp; &nbsp; [gpsPicker <span style="font-variant-ligatures: no-common-ligatures; color: #31595d">startLocationAndCompletion</span>:^(<span style="font-variant-ligatures: no-common-ligatures; color: #703daa">CLLocation</span> *location, <span style="font-variant-ligatures: no-common-ligatures; color: #703daa">NSError</span> *error) {
</p>
<p style="margin-top: 0px; margin-bottom: 0px; font-size: 16px; line-height: normal; font-family: Menlo; color: rgb(0, 132, 0);">
	<span style="font-variant-ligatures: no-common-ligatures; color: #000000">&nbsp; &nbsp; &nbsp; &nbsp; </span>// your code here
</p>
<p style="margin-top: 0px; margin-bottom: 0px; font-size: 16px; line-height: normal; font-family: Menlo;">
	&nbsp; &nbsp; }];
</p>

###不显示定位详情的效果图
![image](https://github.com/longitachi/GPSLocationPicker/blob/master/效果图/不显示定位详情.gif)

###显示定位详情的效果图
![image](https://github.com/longitachi/GPSLocationPicker/blob/master/效果图/显示定位详情.gif)
