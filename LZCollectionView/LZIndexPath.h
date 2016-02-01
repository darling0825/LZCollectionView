//
//  LZIndexPath.h
//  CustomControl
//
//  Created by liww on 15-11-4.
//  Copyright (c) 2015年 liww. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZIndexPath : NSIndexPath
@property(nonatomic, assign) NSInteger item;
@property(nonatomic, assign) NSInteger section;

+ (LZIndexPath *)indexPathForItem:(NSInteger)item
                        inSection:(NSInteger)section;

- (BOOL)isEqual:(LZIndexPath *)indexPath;

@end
