//
//  LZCollectionView+Mouse.h
//  CustomControl
//
//  Created by liww on 14-11-17.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZCollectionView.h"

@interface LZCollectionView (LZCollectionView_Mouse)
- (void)mouseExited:(NSEvent *)theEvent;
- (void)mouseMoved:(NSEvent *)theEvent;
- (void)mouseDown:(NSEvent *)theEvent;
- (void)rightMouseDown:(NSEvent *)theEvent;
- (void)mouseDragged:(NSEvent *)theEvent;
- (void)mouseUp:(NSEvent *)theEvent;

- (BOOL)shiftOrCommandKeyPressed;
@end
