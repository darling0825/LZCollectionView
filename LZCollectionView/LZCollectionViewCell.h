//
//  LZCollectionViewCell.h
//  CustomControl
//
//  Created by liww on 14-9-30.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LZCollectionReusableView.h"

@interface LZCollectionViewCell : LZCollectionReusableView
@property(nonatomic, readonly) NSView *contentView;
@property(nonatomic, retain) NSView *backgroundView;
@property(nonatomic, retain) NSView *selectedBackgroundView;

@property (nonatomic, getter=isSelectable) BOOL selectable;
@property(nonatomic, getter=isSelected) BOOL selected;
@property(nonatomic, getter=isHighlighted) BOOL highlighted;

@property (nonatomic, retain) NSColor *backgroundColor;
@property (nonatomic, retain) NSColor *highlightedColor;
@property (nonatomic, retain) NSColor *selectedColor;
@property (nonatomic, retain) NSColor *selectionRingColor;

@property (nonatomic, assign) NSUInteger itemBorderRadius;
@property (nonatomic, assign) CGFloat selectionRingLineWidth;

@end
