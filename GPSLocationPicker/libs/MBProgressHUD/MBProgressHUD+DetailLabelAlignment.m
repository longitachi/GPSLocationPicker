//
//  MBProgressHUD+DetailLabelAlignment.m
//  vsfa
//
//  Created by long on 15/10/12.
//  Copyright © 2015年 AZYK. All rights reserved.
//

#import "MBProgressHUD+DetailLabelAlignment.h"

@implementation MBProgressHUD (DetailLabelAlignment)

- (void)setDetailLabelAlignment:(NSTextAlignment)alignment
{
    self->detailsLabel.textAlignment = alignment;
}

@end
