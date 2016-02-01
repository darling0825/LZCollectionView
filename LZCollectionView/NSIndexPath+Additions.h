//
//  NSIndexPath+Additions.h
//  CustomControl
//
//  Created by liww on 14-9-30.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSIndexPath (Additions)

@property(nonatomic, assign) NSInteger item;
@property(nonatomic, assign) NSInteger section;
/*!
 * @discription Returns an index-path object initialized with the indexes of a specific item and section in a collection view.
 
 * @param An index number identifying an item in a LZCollectionView object in a section identified by the section parameter.
 
 * @param An index number identifying a section in a LZCollectionView object.
 
 * @return An NSIndexPath object or nil if the object could not be created.
 */
+ (NSIndexPath *)indexPathForItem:(NSInteger)item
                        inSection:(NSInteger)section;

- (BOOL)isEqual:(NSIndexPath *)indexPath;
@end
