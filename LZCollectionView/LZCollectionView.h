//
//  LZCollectionView.h
//  CustomControl
//
//  Created by liww on 14-9-30.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//! Project version number for LZCollectionView.
FOUNDATION_EXPORT double LZCollectionViewVersionNumber;

//! Project version string for LZCollectionView.
FOUNDATION_EXPORT const unsigned char LZCollectionViewVersionString[];

#import "LZCollectionViewDefinitions.h"
#import "LZCollectionViewDataSource.h"
#import "LZCollectionViewDelegate.h"
#import "LZCollectionViewFlowLayoutDelegate.h"
#import "LZIndexPath.h"
#import "NSIndexPath+Additions.h"
#import "NSView+LZCollectionView.h"
#import "LZCollectionViewLayoutAttributes.h"
#import "LZCollectionViewCell.h"
#import "LZCollectionViewLayout.h"
#import "LZCollectionReusableView.h"

#import "CircleLayout.h"
#import "LZCollectionViewFlowLayout.h"
#import "LZCollectionViewGridLayout.h"

@class LZCollectionViewLayout;
@class LZCollectionViewCell;
@class LZCollectionViewLayoutAttributes;
@class LZSelectionFrameView;

FOUNDATION_EXPORT NSString *const LZCollectionViewWillDeselectAllItemsNotification;
FOUNDATION_EXPORT NSString *const LZCollectionViewDidDeSelectAllItemsNotification;

@interface LZCollectionView : NSView{
@private
    NSIndexPath             *_lastHighlightedIndexPath;
    NSIndexPath             *_lastSelectedIndexPath;
    
    NSMutableDictionary     *_selectedItems;
    NSMutableDictionary     *_selectedItemsBySelectionFrame;
    
    LZSelectionFrameView    *_selectionFrameView;
    CGPoint                 _selectionFrameInitialPoint;
    BOOL                    _mouseHasDragged;
    BOOL                    _abortSelection;
    
    NSTrackingArea          *_trackingArea;
}

@property(nonatomic, assign) id< LZCollectionViewDelegate > delegate;
@property(nonatomic, assign) id< LZCollectionViewDataSource > dataSource;
@property(nonatomic, retain) NSView *backgroundView;
@property (nonatomic, retain) NSColor *backgroundColor;
@property(nonatomic, retain) LZCollectionViewLayout *collectionViewLayout;

@property(nonatomic) BOOL allowsSelection;
@property(nonatomic) BOOL allowsMultipleSelection;
@property(nonatomic) BOOL allowsMultipleSelectionWithDrag;
@property(nonatomic) BOOL allowsHighlight;

@property (nonatomic, assign) IBOutlet NSMenu *itemContextMenu;

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(LZCollectionViewLayout *)layout;

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(NSNib *)nib forCellWithReuseIdentifier:(NSString *)identifier;

- (void)registerClass:(Class)viewClass
        forSupplementaryViewOfKind:(NSString *)elementKind
        withReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(NSNib *)nib
        forSupplementaryViewOfKind:(NSString *)kind
        withReuseIdentifier:(NSString *)identifier;

- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier
                                forIndexPath:(NSIndexPath *)indexPath;

- (id)dequeueReusableSupplementaryViewOfKind:(NSString *)elementKind
                         withReuseIdentifier:(NSString *)identifier
                                forIndexPath:(NSIndexPath *)indexPath;
/*
- (void)setCollectionViewLayout:(LZCollectionViewLayout *)layout
                       animated:(BOOL)animated;

- (void)setCollectionViewLayout:(LZCollectionViewLayout *)layout
                       animated:(BOOL)animated
                     completion:(void (^)(BOOL finished))completion;
*/

- (void)reloadData;
- (void)reloadSections:(NSIndexSet *)sections;
- (void)reloadItemsAtIndexPaths:(NSArray *)indexPaths;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;

- (NSArray *)visibleCells;
- (NSArray *)indexPathsForSelectedItems;

//- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath
//                     animated:(BOOL)animated
//               scrollPosition:(LZCollectionViewScrollPosition)scrollPosition;
//- (void)deselectItemAtIndexPath:(NSIndexPath *)indexPath
//                       animated:(BOOL)animated;

- (NSIndexPath *)indexPathForItemAtPoint:(NSPoint)location;
- (NSArray *)indexPathsForVisibleItems;
- (NSIndexPath *)indexPathForCell:(LZCollectionViewCell *)cell;

- (LZCollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath;
- (LZCollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath;
- (LZCollectionViewLayoutAttributes *)layoutAttributesForSupplementaryElementOfKind:(NSString *)kind
                                      atIndexPath:(NSIndexPath *)indexPath;

//- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath
//               atScrollPosition:(LZCollectionViewScrollPosition)scrollPosition
//                       animated:(BOOL)animated;
//- (void)performBatchUpdates:(void (^)(void))updates
//                 completion:(void (^)(BOOL finished))completion;
//
//- (void)insertItemsAtIndexPaths:(NSArray *)indexPaths;
//- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath
//                toIndexPath:(NSIndexPath *)newIndexPath;
//- (void)deleteItemsAtIndexPaths:(NSArray *)indexPaths;
//
//- (void)insertSections:(NSIndexSet *)sections;
//- (void)moveSection:(NSInteger)section
//          toSection:(NSInteger)newSection;
//- (void)deleteSections:(NSIndexSet *)sections;
@end
