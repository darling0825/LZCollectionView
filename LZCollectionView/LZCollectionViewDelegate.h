//
//  LZCollectionViewDelegate.h
//  CustomControl
//
//  Created by liww on 14-9-30.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LZCollectionView;
@class LZCollectionViewCell;
@class LZCollectionReusableView;

@protocol LZCollectionViewDelegate <NSObject>

@optional
/*!
 * @discription Tells the delegate that the specified cell is about to be displayed in the collection view.
 
 * @param collectionView The collection view object that is adding the cell.
 
 * @param cell The cell object being added.
 
 * @param indexPath The index path of the data item that the cell represents.
 */
- (void)collectionView:(LZCollectionView *)collectionView
       willDisplayCell:(LZCollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath;


/*!
 * @discription Tells the delegate that the specified supplementary view is about to be displayed in the collection view.
 
 * @param collectionView The collection view object that is adding the supplementary view.
 
 * @param view The view being added.
 
 * @param elementKind: The type of the supplementary view. This string is defined by the layout that presents the view.
 
 * @param indexPath The index path of the data item that the supplementary view represents.
 
 */
- (void)collectionView:(LZCollectionView *)collectionView
willDisplaySupplementaryView:(LZCollectionReusableView *)view
        forElementKind:(NSString *)elementKind
           atIndexPath:(NSIndexPath *)indexPath;

- (BOOL)collectionView:(LZCollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(LZCollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(LZCollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)collectionView:(LZCollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)collectionView:(LZCollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(LZCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(LZCollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)collectionViewWillDeselectAllItems:(LZCollectionView *)collectionView;
- (void)collectionViewDidDeselectAllItems:(LZCollectionView *)collectionView;

- (void)collectionView:(LZCollectionView *)collectionView didClickItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(LZCollectionView *)collectionView didDoubleClickItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)collectionView:(LZCollectionView *)collectionView didActivateContextMenuWithIndexPaths:(NSArray *)indexPaths;
@end
