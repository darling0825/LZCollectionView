//
//  LZCollectioViewFlowLayout.h
//  CustomControl
//
//  Created by liww on 14-9-30.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "LZCollectionViewLayout.h"
#import "LZCollectionViewDefinitions.h"

FOUNDATION_EXPORT NSString *const  LZCollectionElementKindSectionHeader;
FOUNDATION_EXPORT NSString *const  LZCollectionElementKindSectionFooter;

@interface LZCollectionViewFlowLayout : LZCollectionViewLayout
@property(nonatomic) CGFloat minimumLineSpacing;
@property(nonatomic) CGFloat minimumInteritemSpacing;
@property(nonatomic) NSSize itemSize;
@property(nonatomic) NSSize estimatedItemSize;
@property(nonatomic) LZEdgeInsets sectionInset;
@property(nonatomic) NSSize headerReferenceSize;
@property(nonatomic) NSSize footerReferenceSize;
@property (nonatomic) LZCollectionViewScrollDirection scrollDirection;
@end
