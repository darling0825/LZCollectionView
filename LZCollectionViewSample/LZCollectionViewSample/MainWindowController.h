//
//  MainWindowController.h
//  LZCollectionViewSample
//
//  Created by 沧海无际 on 16/1/31.
//  Copyright © 2016年 darling0825. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <LZCollectionView/LZCollectionView.h>

@class CircleLayout;
@class LZCollectionViewGridLayout;
@class LZCollectionViewFlowLayout;

@interface MainWindowController : NSWindowController<LZCollectionViewDataSource,LZCollectionViewDelegate>{
    IBOutlet LZCollectionView   *_collectionView;
    
    CircleLayout                *_circleLayout;
    LZCollectionViewGridLayout  *_gridLayout;
    LZCollectionViewFlowLayout  *_flowLayout;
    
    NSMutableArray              *_sections;
    NSMutableArray              *_items1;
    NSMutableArray              *_items2;
    NSMutableArray              *_items3;
}

@end
