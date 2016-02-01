//
//  LZCollectionView+Mouse.m
//  CustomControl
//
//  Created by liww on 14-11-17.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "LZCollectionView+Mouse.h"
#import "LZCollectionViewCell.h"
#import "NSIndexPath+Additions.h"
#import "NSView+LZCollectionView.h"
#import "LZCollectionViewLayout.h"
#import "LZCollectionViewLayoutAttributes.h"

NSString *const LZCollectionViewWillDeselectAllItemsNotification = @"LZCollectionViewWillDeselectAllItems";
NSString *const LZCollectionViewDidDeselectAllItemsNotification = @"LZCollectionViewDidDeSelectAllItems";

#pragma mark LZSelectionFrameView
@interface LZSelectionFrameView : NSView
@end

#pragma mark - LZSelectionFrameView
@implementation LZSelectionFrameView

- (void)drawRect:(NSRect)rect
{
    NSRect dirtyRect = NSMakeRect(0.5,
                                  0.5,
                                  floorf(NSWidth(self.bounds)) - 1,
                                  floorf(NSHeight(self.bounds)) - 1);
    NSBezierPath *selectionFrame = [NSBezierPath bezierPathWithRoundedRect:dirtyRect
                                                                   xRadius:0
                                                                   yRadius:0];
    
    [[[NSColor blackColor] colorWithAlphaComponent:0.15] setFill];
    [selectionFrame fill];
    
    [[NSColor whiteColor] setStroke];
    [selectionFrame setLineWidth:1];
    [selectionFrame stroke];
}

- (BOOL)isFlipped {
    return YES;
}

@end


@implementation LZCollectionView (LZCollectionView_Mouse)
- (void)updateTrackingAreas
{
    if (_trackingArea) {
        [self removeTrackingArea:_trackingArea];
    }
    
    _trackingArea = nil;
    int opts = NSTrackingMouseEnteredAndExited|NSTrackingMouseMoved|NSTrackingActiveInKeyWindow;
    _trackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds]
                                                 options:opts
                                                   owner:self
                                                userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

- (BOOL)canBecomeKeyView
{
    return YES;
}

- (BOOL)acceptsFirstResponder
{
    return YES;
}

- (void)mouseExited:(NSEvent *)theEvent
{
    _lastHighlightedIndexPath = nil;
}

- (void)mouseMoved:(NSEvent *)theEvent
{
    if (!self.allowsHighlight)
        return;
    
    NSIndexPath *highlightedIndexPath = [self indexPathForItemAtPoint:theEvent.locationInWindow];
    
    if (highlightedIndexPath != _lastHighlightedIndexPath) {
        
        // unHighlight the last highlighted item
        if (_lastHighlightedIndexPath != nil) {
            [self unHighlightItemAtIndexPath:_lastHighlightedIndexPath];
        }
        
        // inform the delegate
        if (highlightedIndexPath != nil){
            [self highlightItemAtIndexPath:highlightedIndexPath];
        }
    }
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    if (!self.allowsMultipleSelection || !self.allowsMultipleSelectionWithDrag){
        return;
    }
    _mouseHasDragged = YES;
    [NSCursor closedHandCursor];

    if (!_abortSelection) {
        NSPoint location = [self convertPoint:[theEvent locationInWindow] fromView:nil];
        [self drawSelectionFrameForMousePointerAtLocation:location];
        [self selectItemsCoveredBySelectionFrame:_selectionFrameView.frame usingModifierFlags:theEvent.modifierFlags];
    }
}

- (void)mouseUp:(NSEvent *)theEvent
{
    [NSCursor arrowCursor];
    _abortSelection = NO;
    
    // this happens just if we have multiselection ON and dragged the
    // mouse over items. In this case we have to handle this selection.
    
    if (self.allowsMultipleSelectionWithDrag && _mouseHasDragged) {
        _mouseHasDragged = NO;
        
        // remove selection frame
        [[_selectionFrameView animator] setAlphaValue:0];
        [_selectionFrameView removeFromSuperview];
        _selectionFrameView = nil;
        
        // catch all newly selected items that was selected by selection frame
        [_selectedItemsBySelectionFrame enumerateKeysAndObjectsUsingBlock: ^(NSIndexPath *indexPath, LZCollectionViewCell *cell, BOOL *stop) {
            if (cell.isSelected) {
                [self selectItem:indexPath];
            }
            else {
                [self deSelectItem:indexPath];
            }
        }];
        [_selectedItemsBySelectionFrame removeAllObjects];
    }
}

- (void)mouseDown:(NSEvent *)theEvent
{
    if (!self.allowsSelection){
        return;
    }
    
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:theEvent.locationInWindow];
    
    if (indexPath != nil) {
        [self selectItemAtIndexPath:indexPath usingModifierFlags:theEvent.modifierFlags];
    }
    else {
        [self deselectAllItems];
    }
    
    if ([theEvent type] == NSLeftMouseDown && [theEvent clickCount] == 1){
        [self collectionView:self didClickItemAtIndexPath:indexPath];
    }
    else if ([theEvent type] == NSLeftMouseDown && [theEvent clickCount] == 2){
        [self collectionView:self didDoubleClickItemAtIndexPath:indexPath];
    }
}

- (void)rightMouseDown:(NSEvent *)theEvent
{
    NSPoint location = [theEvent locationInWindow];
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:location];

    if (indexPath != nil) {
        BOOL isClickInSelection = [[_selectedItems allKeys] containsObject:indexPath];

        if (!isClickInSelection) {
            [self deselectAllItems];
            [self selectItem:indexPath];
        }

        if (self.itemContextMenu) {
            NSEvent *fakeMouseEvent = [NSEvent mouseEventWithType:NSRightMouseDown
                                                         location:location
                                                    modifierFlags:0
                                                        timestamp:0
                                                     windowNumber:[self.window windowNumber]
                                                          context:nil
                                                      eventNumber:0
                                                       clickCount:0
                                                         pressure:0];
            
            for (NSMenuItem *menuItem in self.itemContextMenu.itemArray) {
                [menuItem setRepresentedObject:indexPath];
            }
            [NSMenu popUpContextMenu:self.itemContextMenu withEvent:fakeMouseEvent forView:self];
            
            // inform the delegate
            [self collectionView:self didActivateContextMenuWithIndexPaths:[_selectedItems allKeys]];
        }
    }
    else {
        [self deselectAllItems];
    }
}

- (void)keyDown:(NSEvent *)theEvent {
    switch ([theEvent keyCode]) {
        case 53: {  // escape
            _abortSelection = YES;
            break;
        }
    }
    [super keyDown:theEvent];
}

- (BOOL)shiftOrCommandKeyPressed
{
    return [NSEvent modifierFlags] & NSShiftKeyMask || [NSEvent modifierFlags] & NSCommandKeyMask;
}

#pragma mark - Helper
- (void)highlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@">>> %@, %@",NSStringFromSelector(_cmd),indexPath);
    
    // enquire the delegate
    if (![self collectionView:self shouldHighlightItemAtIndexPath:indexPath]) {
        return;
    }
    
    _lastHighlightedIndexPath = indexPath;
    LZCollectionViewCell *cell = [self cellForItemAtIndexPath:indexPath];
    [cell setHighlighted:YES];
    
    // inform the delegate
    [self collectionView:self didHighlightItemAtIndexPath:indexPath];
}

- (void)unHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@">>> %@, %@",NSStringFromSelector(_cmd),indexPath);
    
    LZCollectionViewCell *cell = [self cellForItemAtIndexPath:indexPath];
    [cell setHighlighted:NO];
    
    // inform the delegate
    [self collectionView:self didUnhighlightItemAtIndexPath:indexPath];
}


- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath usingModifierFlags:(NSUInteger)modifierFlags
{
    if (indexPath == nil)
        return;
    
    LZCollectionViewCell *cell = nil;
    cell = [self cellForItemAtIndexPath:indexPath];
    if (cell) {
        if (self.allowsMultipleSelection) {
            if (!cell.selected && !(modifierFlags & NSShiftKeyMask) && !(modifierFlags & NSCommandKeyMask)) {
                //Select a single item and deselect all other items when the shift or command keys are NOT pressed.
                [self deselectAllItems];
                [self selectItem:indexPath];
            }
            else if (cell.selected && modifierFlags & NSCommandKeyMask) {
                //If the item clicked is already selected and the command key is down, remove it from the selection.
                [self deSelectItem:indexPath];
            }
            else if (!cell.selected && modifierFlags & NSCommandKeyMask) {
                //If the item clicked is NOT selected and the command key is down, add it to the selection
                [self selectItem:indexPath];
            }
            
            else if (modifierFlags & NSShiftKeyMask) {
                //Select a range of items between the current selection and the item that was clicked when the shift key is down.
                [self deselectAllItems];

                //If there were no previous items selected then
                if (_lastSelectedIndexPath == nil) {
                    [self selectItem:indexPath];
                }
                else {
                    //Find range to select
                    NSIndexPath *startIndexPath = nil;
                    NSIndexPath *endIndexPath = nil;
                    NSInteger numberOfItems = 0;
                    
                    if (_lastSelectedIndexPath.section < indexPath.section) {
                        startIndexPath = _lastSelectedIndexPath;
                        endIndexPath = indexPath;
                    }else{
                        startIndexPath = indexPath;
                        endIndexPath = _lastSelectedIndexPath;
                    }
                    
                    if (startIndexPath.section == endIndexPath.section) {
                        NSInteger startItem = 0;
                        NSInteger endItem = 0;
                        
                        if(_lastSelectedIndexPath.item < indexPath.item) {
                            startItem = _lastSelectedIndexPath.item;
                            endItem = indexPath.item;
                        }else{
                            startItem = indexPath.item;
                            endItem = _lastSelectedIndexPath.item;
                        }
                        
                        for (NSInteger item = startItem; item <= endItem; item++) {
                            NSIndexPath *aIndexPath = [NSIndexPath indexPathForItem:item inSection:startIndexPath.section];
                            [self selectItem:aIndexPath];
                        }
                    }
                    else{
                        numberOfItems = [self numberOfItemsInSection:startIndexPath.section];
                        for (NSInteger item = startIndexPath.item; item < numberOfItems; item++) {
                            NSIndexPath *aIndexPath = [NSIndexPath indexPathForItem:item inSection:startIndexPath.section];
                            [self selectItem:aIndexPath];
                        }
                        
                        for (NSInteger item = 0; item <= endIndexPath.item; item++) {
                            NSIndexPath *aIndexPath = [NSIndexPath indexPathForItem:item inSection:endIndexPath.section];
                            [self selectItem:aIndexPath];
                        }
                        
                        for (NSInteger section = startIndexPath.section + 1; section < endIndexPath.section; section++) {
                            numberOfItems = [self numberOfItemsInSection:section];
                            for (NSInteger item = 0; item < numberOfItems; item++) {
                                NSIndexPath *aIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
                                [self selectItem:aIndexPath];
                            }
                        }
                    }
                }
            }
            else if (cell.selected) {
                [self deselectAllItems];
                [self selectItem:indexPath];
            }
        }
        else {
            if (modifierFlags & NSCommandKeyMask) {
                if (cell.selected) {
                    [self deSelectItem:indexPath];
                }
                else {
                    [self selectItem:indexPath];
                }
            }
            else {
                if (_lastSelectedIndexPath != nil && _lastSelectedIndexPath != indexPath) {
                    [self deSelectItem:_lastSelectedIndexPath];
                }
                [self selectItem:indexPath];
            }
        }
        
        //按住ShiftKey时，一直保留
        if (!(modifierFlags & NSShiftKeyMask)){
            _lastSelectedIndexPath = indexPath;
        }
    }
}

- (void)selectAllItems
{
    for (NSInteger section = 0; section < self.numberOfSections; section++) {
        NSInteger numberOfItemsInSection = [self numberOfItemsInSection:section];
        for (NSInteger index = 0; index < numberOfItemsInSection; index++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:section];
            LZCollectionViewCell *cell = [self cellForItemAtIndexPath:indexPath];
            cell.selected = YES;
            _selectedItems[indexPath] = cell;
        }
    }
}

- (void)deselectAllItems
{
    NSLog(@">>> %@",NSStringFromSelector(_cmd));
    
    if (_selectedItems.count > 0) {
        // inform the delegate
        [self collectionViewWillDeselectAllItems:self];
        
        [_selectedItems enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            LZCollectionViewCell *cell = (LZCollectionViewCell *)obj;
            cell.selected = NO;
        }];
        [_selectedItems removeAllObjects];
        
        // inform the delegate
        [self collectionViewDidDeselectAllItems:self];
    }
}

- (void)selectItem:(NSIndexPath *)indexPath
{
    NSLog(@">>> %@, %@",NSStringFromSelector(_cmd),indexPath);
    
    // enquire the delegate
    if (![self collectionView:self shouldSelectItemAtIndexPath:indexPath]) {
        return;
    }
    
    LZCollectionViewCell *cell = [self cellForItemAtIndexPath:indexPath];
    if (!_selectedItems[indexPath]) {
        
        cell.selected = YES;
        _selectedItems[indexPath] = cell;
        
        // inform the delegate
        [self collectionView:self didSelectItemAtIndexPath:indexPath];
    }
}

- (void)deSelectItem:(NSIndexPath *)indexPath
{
    NSLog(@">>> %@, %@",NSStringFromSelector(_cmd),indexPath);
    
    // enquire the delegate
    if (![self collectionView:self shouldDeselectItemAtIndexPath:indexPath]) {
        return;
    }
    
    LZCollectionViewCell *cell = [self cellForItemAtIndexPath:indexPath];
    if (_selectedItems[indexPath]) {
        
        cell.selected = NO;
        [_selectedItems removeObjectForKey:indexPath];
        
        // inform the delegate
        [self collectionView:self didDeselectItemAtIndexPath:indexPath];
    }
}

- (void)drawSelectionFrameForMousePointerAtLocation:(NSPoint)location
{
    if (!_selectionFrameView) {
        _selectionFrameInitialPoint = location;
        _selectionFrameView = [LZSelectionFrameView new];
        _selectionFrameView.frame = NSMakeRect(location.x, location.y, 0, 0);
        if (![self containsSubView:_selectionFrameView])
            [self addSubview:_selectionFrameView];
    }
    
    else {
        NSRect clippedRect = [[[self enclosingScrollView] contentView] bounds];
        NSUInteger maxXInView = [self frame].origin.x + [self frame].size.width;
        
        CGFloat posX = ceil((location.x > _selectionFrameInitialPoint.x ? _selectionFrameInitialPoint.x : location.x));
        posX = (posX < NSMinX(clippedRect) ? NSMinX(clippedRect) : posX);
        
        CGFloat posY = ceil((location.y > _selectionFrameInitialPoint.y ? _selectionFrameInitialPoint.y : location.y));
        posY = (posY < NSMinY(clippedRect) ? NSMinY(clippedRect) : posY);
        
        CGFloat width = (location.x > _selectionFrameInitialPoint.x ? location.x - _selectionFrameInitialPoint.x : _selectionFrameInitialPoint.x - posX);
        width = posX + width >= maxXInView? maxXInView - posX - 1 : width;
        
        CGFloat height = (location.y > _selectionFrameInitialPoint.y ? location.y - _selectionFrameInitialPoint.y : _selectionFrameInitialPoint.y - posY);
        height = (posY + height > NSMaxY(clippedRect) ? NSMaxY(clippedRect) - posY : height);
        
        NSRect selectionFrame = NSMakeRect(posX, posY, width, height);
        _selectionFrameView.frame = selectionFrame;
    }
}

- (void)selectItemsCoveredBySelectionFrame:(NSRect)selectionFrame usingModifierFlags:(NSUInteger)modifierFlags
{
    [_selectedItemsBySelectionFrame enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, id obj, BOOL *stop) {
        LZCollectionViewCell *cell = [self cellForItemAtIndexPath:indexPath];
        if (!NSIntersectsRect(cell.frame, selectionFrame)) {
            cell.selected = NO;
            [_selectedItemsBySelectionFrame removeObjectForKey:indexPath];
        }
    }];
    
    // Verify selection frame was inside gridded area
    BOOL validSelectionFrame = (NSWidth(selectionFrame) > 0) && (NSHeight(selectionFrame) > 0);
    
    NSArray *attributes = [self.collectionViewLayout layoutAttributesForElementsInRect:selectionFrame];
    [attributes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        LZCollectionViewLayoutAttributes *attribute = (LZCollectionViewLayoutAttributes *)obj;
        LZCollectionViewCell *selectedCell = _selectedItems[attribute.indexPath];
        LZCollectionViewCell *cellToSelect = [self cellForItemAtIndexPath:attribute.indexPath];
        
        if (cellToSelect && validSelectionFrame) {
            _selectedItemsBySelectionFrame[attribute.indexPath] = cellToSelect;
            if (modifierFlags & NSCommandKeyMask) {
                //选中的，不再选中；未选中的，要选中
                cellToSelect.selected = (selectedCell != nil ? NO : YES);
            }
            else {
                cellToSelect.selected = YES;
            }
        }
    }];
}

#pragma mark - delegate
- (BOOL)collectionView:(LZCollectionView *)collectionView
shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:_cmd]) {
        return [self.delegate collectionView:collectionView shouldHighlightItemAtIndexPath:indexPath];
    }
    
    return YES;
}

- (void)collectionView:(LZCollectionView *)collectionView
didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:_cmd]) {
        [self.delegate collectionView:collectionView didHighlightItemAtIndexPath:indexPath];
    }
}

- (void)collectionView:(LZCollectionView *)collectionView
didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:_cmd]) {
        [self.delegate collectionView:collectionView didUnhighlightItemAtIndexPath:indexPath];
    }
}

- (BOOL)collectionView:(LZCollectionView *)collectionView
shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:_cmd]) {
        return [self.delegate collectionView:collectionView shouldSelectItemAtIndexPath:indexPath];
    }
    return YES;
}

- (BOOL)collectionView:(LZCollectionView *)collectionView
shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:_cmd]) {
        return [self.delegate collectionView:collectionView shouldDeselectItemAtIndexPath:indexPath];
    }
    return YES;
}

- (void)collectionView:(LZCollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:_cmd]) {
        [self.delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
}

- (void)collectionView:(LZCollectionView *)collectionView
didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:_cmd]) {
        [self.delegate collectionView:collectionView didDeselectItemAtIndexPath:indexPath];
    }
}

- (void)collectionViewWillDeselectAllItems:(LZCollectionView *)collectionView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LZCollectionViewWillDeselectAllItemsNotification
                                                        object:collectionView
                                                      userInfo:nil];
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate collectionViewWillDeselectAllItems:collectionView];
    }
}

- (void)collectionViewDidDeselectAllItems:(LZCollectionView *)collectionView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LZCollectionViewDidDeselectAllItemsNotification
                                                        object:collectionView
                                                      userInfo:nil];
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate collectionViewDidDeselectAllItems:collectionView];
    }
}

- (void)collectionView:(LZCollectionView *)collectionView didClickItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate collectionView:collectionView didClickItemAtIndexPath:indexPath];
    }
}

- (void)collectionView:(LZCollectionView *)collectionView didDoubleClickItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate collectionView:collectionView didDoubleClickItemAtIndexPath:indexPath];
    }
}

- (void)collectionView:(LZCollectionView *)collectionView didActivateContextMenuWithIndexPaths:(NSArray *)indexPaths
{
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate collectionView:collectionView didActivateContextMenuWithIndexPaths:indexPaths];
    }
}
@end
