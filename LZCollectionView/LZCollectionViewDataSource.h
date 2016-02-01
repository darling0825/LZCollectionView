//
//  LZCollectionViewDataSource.h
//  CustomControl
//
//  Created by liww on 14-9-30.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LZCollectionView;
@class LZCollectionViewCell;
@class LZCollectionReusableView;

@protocol LZCollectionViewDataSource <NSObject>

@required
/*!
 * @discription Asks the data source for the number of items in the specified section. (required)
 
 * @param collectionView An object representing the collection view requesting this information.
 
 * @param section An index number identifying a section in collectionView. This index value is 0-based.
 
 * @return The number of rows in section.
 */
- (NSInteger)collectionView:(LZCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;

/*!
 * @discription Asks the data source for the cell that corresponds to the specified item in the collection view. (required)
 
 * @param collectionView An object representing the collection view requesting this information.
 
 * @param indexPath The index path that specifies the location of the item.
 
 * @return A configured cell object. You must not return nil from this method.
 */
- (LZCollectionViewCell *)collectionView:(LZCollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional

/*!
 * @discription Asks the data source for the number of sections in the collection view.
 
 * @param collectionView An object representing the collection view requesting this information.
 
 * @return The number of sections in collectionView.
 */
- (NSInteger)numberOfSectionsInCollectionView:(LZCollectionView *)collectionView;

/*!
 * @discription Asks the collection view to provide a supplementary view to display in the collection view.
 
 * @param collectionView An object representing the collection view requesting this information.
 
 * @param kind The kind of supplementary view to provide. The value of this string is defined by the layout object that supports the supplementary view.
 
  * @param The index path that specifies the location of the new supplementary view.
 
 * @return indexPath A configured supplementary view object. You must not return nil from this method.
 */
- (LZCollectionReusableView *)collectionView:(LZCollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath;

@end
