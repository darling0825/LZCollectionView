//
//  CustomViewDefines.h
//  CustomControl
//
//  Created by 沧海无际 on 15-3-17.
//  Copyright (c) 2015年 liww. All rights reserved.
//

#ifndef CustomControlTest_LZEdgeInsets_h
#define CustomControlTest_LZEdgeInsets_h

typedef struct _LZEdgeInsets{
    CGFloat top;
    CGFloat left;
    CGFloat bottom;
    CGFloat right;
} LZEdgeInsets;

NS_INLINE LZEdgeInsets LZEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right) {
    LZEdgeInsets e;
    e.top = top;
    e.left = left;
    e.bottom = bottom;
    e.right = right;
    return e;
}

NS_INLINE BOOL EqualLZEdgeInsets(LZEdgeInsets e1,LZEdgeInsets e2)
{
    if (e1.top == e2.top && e1.left == e2.left && e1.bottom == e2.bottom && e1.right == e2.right) {
        return YES;
    }
    return NO;
}

#define LZZeroEdgeInsets LZEdgeInsetsMake(0, 0, 0, 0)

#endif
