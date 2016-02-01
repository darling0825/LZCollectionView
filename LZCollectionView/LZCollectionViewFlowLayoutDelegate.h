//
//  LZCollectionViewFlowLayoutDelegate.h
//  CustomControl
//
//  Created by liww on 14-9-30.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZCollectionViewDefinitions.h"

@class LZCollectionView;
@class LZCollectionViewLayout;

@protocol LZCollectionViewFlowLayoutDelegate <LZCollectionViewDelegate>
@optional

/*!
 * @discription Asks the delegate for the size of the specified item’s cell.
 
 * @param collectionView The collection view object displaying the flow layout.
 
 * @param collectionViewLayout The layout object requesting the information.
 
 * @param indexPath The index path of the item.
 
 * @return The width and height of the specified item. Both values must be greater than 0.
 */
- (NSSize)collectionView:(LZCollectionView *)collectionView
                  layout:(LZCollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

/*!
 * @discription Asks the delegate for the margins to apply to content in the specified section.
 
 * @param collectionView The collection view object displaying the flow layout.
 
 * @param collectionViewLayout The layout object requesting the information.
 
 * @param section The index number of the section whose insets are needed.
 
 * @return The margins to apply to items in the section.
 */
- (LZEdgeInsets)collectionView:(LZCollectionView *)collectionView
                        layout:(LZCollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section;

/*!
 * @discription Asks the delegate for the spacing between successive rows or columns of a section.
 
 * @param collectionView The collection view object displaying the flow layout.
 
 * @param collectionViewLayout The layout object requesting the information.
 
 * @param section The index number of the section whose line spacing is needed.
 
 * @return The minimum space (measured in points) to apply between successive lines in a section.
 */
- (CGFloat)collectionView:(LZCollectionView *)collectionView
                   layout:(LZCollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section;

/*!
 * @discription Asks the delegate for the spacing between successive items in the rows or columns of a section.
 
 * @param collectionView The collection view object displaying the flow layout.
 
 * @param collectionViewLayout The layout object requesting the information.
 
 * @param section The index number of the section whose inter-item spacing is needed.
 
 * @return The minimum space (measured in points) to apply between successive items in the lines of a section.
 */
- (CGFloat)collectionView:(LZCollectionView *)collectionView
                   layout:(LZCollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;

/*!
 * @discription Asks the delegate for the size of the header view in the specified section.
 
 * @param collectionView The collection view object displaying the flow layout.
 
 * @param collectionViewLayout The layout object requesting the information.
 
 * @param section The index of the section whose header size is being requested.
 
 * @return The size of the header. If you return a value of size (0, 0), no header is added.
 */
- (NSSize)collectionView:(LZCollectionView *)collectionView
                  layout:(LZCollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section;

/*!
 * @discription Asks the delegate for the size of the footer view in the specified section.
 
 * @param collectionView The collection view object displaying the flow layout.
 
 * @param collectionViewLayout The layout object requesting the information.
 
 * @param section The index of the section whose footer size is being requested.
 
 * @return The size of the footer. If you return a value of size (0, 0), no footer is added.
 */
- (NSSize)collectionView:(LZCollectionView *)collectionView
                  layout:(LZCollectionViewLayout *)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section;

@end
