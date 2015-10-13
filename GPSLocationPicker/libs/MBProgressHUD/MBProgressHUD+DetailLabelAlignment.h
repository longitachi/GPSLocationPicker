//
//  MBProgressHUD+DetailLabelAlignment.h
//  vsfa
//
//  Created by long on 15/10/12.
//  Copyright © 2015年 AZYK. All rights reserved.
//

#import "MBProgressHUD.h"

//这里为了方便设置MBProgressHUD的detailLabel的对齐方式，把MBProgressHUD类中的detailsLabel属性从.m中移动到了.h中

@interface MBProgressHUD (DetailLabelAlignment)

/**
 * @brief 设置详情label对齐方式
 */
- (void)setDetailLabelAlignment:(NSTextAlignment)alignment;

@end
