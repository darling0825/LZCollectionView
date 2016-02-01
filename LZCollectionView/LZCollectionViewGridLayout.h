//
//  LZCollectioViewFlowLayout.h
//  CustomControl
//
//  Created by liww on 14-9-30.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "LZCollectionViewLayout.h"
#import "LZCollectionViewDefinitions.h"

@interface LZCollectionViewGridLayout : LZCollectionViewLayout
@property(nonatomic) CGFloat minimumLineSpacing;
@property(nonatomic) CGFloat minimumInteritemSpacing;
@property(nonatomic) NSSize itemSize;
@property(nonatomic) LZEdgeInsets sectionInset;
@property(nonatomic) NSSize headerReferenceSize;
@property(nonatomic) NSSize footerReferenceSize;
//@property (nonatomic) LZCollectionViewScrollDirection scrollDirection;
@end
