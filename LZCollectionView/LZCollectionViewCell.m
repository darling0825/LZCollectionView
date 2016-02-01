//
//  LZCollectionViewCell.m
//  CustomControl
//
//  Created by liww on 14-9-30.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "LZCollectionViewCell.h"

@implementation LZCollectionViewCell

- (void)drawRect:(NSRect)dirtyRect
{
    NSRect rect = self.bounds;
    //向内移动四分之一的宽度
    CGFloat inset = self.selectionRingLineWidth / 4;
    NSRect contentRect = NSMakeRect(rect.origin.x + inset,
                                    rect.origin.y + inset,
                                    rect.size.width - inset * 2,
                                    rect.size.height - inset * 2);
    NSBezierPath *contentRectPath = [NSBezierPath bezierPathWithRoundedRect:contentRect
                                                                    xRadius:self.itemBorderRadius
                                                                    yRadius:self.itemBorderRadius];
    if (self.backgroundColor) {
        [self.backgroundColor setFill];
        [contentRectPath fill];
    }
    
    if (self.isSelectable && self.isSelected){
        if (self.selectedColor) {
            [self.selectedColor setFill];
            [contentRectPath fill];
        }
        
        if (self.selectionRingColor) {
            [self.selectionRingColor setStroke];
            //只设置一半的宽度
            [contentRectPath setLineWidth:self.selectionRingLineWidth / 2];
            [contentRectPath stroke];
        }
    }
    else if (self.isHighlighted && self.highlightedColor){
        [self.highlightedColor setFill];
        [contentRectPath fill];
    }
    else{
    }
    
    [super drawRect:dirtyRect];
}

- (void)prepareForReuse
{
    _selected = NO;
    _highlighted = NO;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    if (!selected) {
        _highlighted = NO;
    }
    [self setNeedsDisplay:YES];
}

- (void)setHighlighted:(BOOL)highlighted
{
    _highlighted = highlighted;
    [self setNeedsDisplay:YES];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<LZCollectionViewCell>{%@}",NSStringFromRect(self.frame)];
}
@end
