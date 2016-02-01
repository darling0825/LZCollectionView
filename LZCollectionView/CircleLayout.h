//
//  CircleLayout.h
//  CustomControl
//
//  Created by liww on 14-9-30.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LZCollectionViewLayout.h"

@interface CircleLayout : LZCollectionViewLayout

@property (nonatomic, assign) NSPoint center;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) NSInteger cellCount;

@end
