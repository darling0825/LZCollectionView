//
//  LZCollectionViewDefinitions.h
//  CustomControl
//
//  Created by liww on 14-9-30.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#ifndef CustomControlTest_LZCollectionViewDefinitions_h
#define CustomControlTest_LZCollectionViewDefinitions_h

#import "LZEdgeInsets.h"

enum {
    LZCollectionViewScrollPositionNone  = 0,
    LZCollectionViewScrollPositionTop  = 1 << 0,
    LZCollectionViewScrollPositionCenteredVertically  = 1 << 1,
    LZCollectionViewScrollPositionBottom  = 1 << 2,
    
    LZCollectionViewScrollPositionLeft  = 1 << 3,
    LZCollectionViewScrollPositionCenteredHorizontally  = 1 << 4,
    LZCollectionViewScrollPositionRight  = 1 << 5
};
typedef NSUInteger  LZCollectionViewScrollPosition;

enum {
    LZCollectionViewScrollDirectionVertical ,
    LZCollectionViewScrollDirectionHorizontal
};
typedef NSUInteger  LZCollectionViewScrollDirection;

typedef enum {
    LZCollectionElementCategoryCell ,
    LZCollectionElementCategorySupplementaryView ,
    LZCollectionElementCategoryDecorationView
} LZCollectionElementCategory;


#endif
