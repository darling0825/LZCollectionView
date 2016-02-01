//
//  MainWindowController.m
//  LZCollectionViewSample
//
//  Created by 沧海无际 on 16/1/31.
//  Copyright © 2016年 darling0825. All rights reserved.
//

#import "MainWindowController.h"
#import "MyCollectionViewCell.h"
#import "MyCollectionSupplementaryView.h"

static NSString *kContentTitleKey, *kContentImageKey;

@interface MainWindowController ()

@end

@implementation MainWindowController

+ (void)initialize
{
    kContentTitleKey = @"itemTitle";
    kContentImageKey = @"itemImage";
}


- (id)init
{
    self = [super initWithWindowNibName:@"GridViewTestWindowCtrl" owner:self];
    if (self) {
        _sections = [[NSMutableArray alloc] init];
        _items1 = [[NSMutableArray alloc] init];
        _items2 = [[NSMutableArray alloc] init];
        _items3 = [[NSMutableArray alloc] init];
        
        _circleLayout = [[CircleLayout alloc] init];
        _gridLayout   = [[LZCollectionViewGridLayout alloc] init];
        _flowLayout   = [[LZCollectionViewFlowLayout alloc] init];
    }
    return self;
}

- (void)awakeFromNib
{
    [self createData];
    
    [_collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"CellIdentifier"];
    [_collectionView registerClass:[MyCollectionSupplementaryView class]
        forSupplementaryViewOfKind:LZCollectionElementKindSectionHeader
               withReuseIdentifier:@"SupplementaryViewIdentifier"];
    [_collectionView registerClass:[MyCollectionSupplementaryView class]
        forSupplementaryViewOfKind:LZCollectionElementKindSectionFooter
               withReuseIdentifier:@"SupplementaryViewIdentifier"];
    
    [_collectionView setBackgroundColor:[NSColor lightGrayColor]];
    [_collectionView setAllowsMultipleSelection:YES];
    [_collectionView setAllowsMultipleSelectionWithDrag:YES];
    
    
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    
    //layout
    [_gridLayout setSectionInset:LZEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
    [_flowLayout setSectionInset:LZEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
    [_collectionView setCollectionViewLayout:_flowLayout];
    
    [_collectionView reloadData];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (void)createData
{
    NSImage *image1 = [NSImage imageNamed:@"001"];
    NSImage *image2 = [NSImage imageNamed:@"002"];
    NSImage *image3 = [NSImage imageNamed:@"003"];
    NSImage *image4 = [NSImage imageNamed:@"004"];
    NSImage *image5 = [NSImage imageNamed:@"005"];
    
    for (int i = 0; i < 10; i++) {
        [_items1 addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                            image1, kContentImageKey,
                            NSImageNameComputer, kContentTitleKey,
                            nil]];
        [_items2 addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                            image2, kContentImageKey,
                            NSImageNameNetwork, kContentTitleKey,
                            nil]];
        [_items2 addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                            image3, kContentImageKey,
                            NSImageNameDotMac, kContentTitleKey,
                            nil]];
        [_items3 addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                            image4, kContentImageKey,
                            NSImageNameFolderSmart, kContentTitleKey,
                            nil]];
        [_items3 addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                            image5, kContentImageKey,
                            NSImageNameBonjour, kContentTitleKey,
                            nil]];
    }
    
    [_sections addObject:_items1];
    [_sections addObject:_items2];
    [_sections addObject:_items3];
    
    image1 = nil;
    image2 = nil;
    image3 = nil;
    image4 = nil;
    image5 = nil;
}


#pragma mark
#pragma mark ----------------------- CNGridView DataSource -----------------------
- (NSInteger)numberOfSectionsInCollectionView:(LZCollectionView *)collectionView
{
    return [_sections count];
}

- (NSInteger)collectionView:(LZCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[_sections objectAtIndex:section] count];
}


- (LZCollectionViewCell *)collectionView:(LZCollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellIdentifier"
                                                                           forIndexPath:indexPath];
    
    NSInteger section = indexPath.section;
    NSImage *image = [[[_sections objectAtIndex:section] objectAtIndex:indexPath.item] objectForKey:kContentImageKey];
    NSString *title = [[[_sections objectAtIndex:section] objectAtIndex:indexPath.item] objectForKey:kContentTitleKey];
    
    cell.image = image;
    cell.text = title;
    
    cell.backgroundColor = [NSColor lightGrayColor];
    
    cell.highlightedColor = [NSColor blueColor];
    
    [cell setSelectable:YES];
    [cell setSelectedColor:[NSColor greenColor]];
    
    [cell setItemBorderRadius:10.0];
    [cell setSelectionRingColor:[NSColor redColor]];
    [cell setSelectionRingLineWidth:2];
    
    return cell;
}

- (LZCollectionReusableView *)collectionView:(LZCollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionSupplementaryView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                             withReuseIdentifier:@"SupplementaryViewIdentifier"
                                                                                    forIndexPath:indexPath];
    view.text = [NSString stringWithFormat:@"%ld-%ld",indexPath.section,indexPath.item];
    
    return view;
}

- (void)collectionView:(LZCollectionView *)collectionView
       willDisplayCell:(LZCollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)collectionView:(LZCollectionView *)collectionView
willDisplaySupplementaryView:(LZCollectionReusableView *)view
        forElementKind:(NSString *)elementKind
           atIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionSupplementaryView *supplementaryView = (MyCollectionSupplementaryView *)view;
    supplementaryView.backgroundColor = [NSColor redColor];
}

- (NSSize)collectionView:(LZCollectionView *)collectionView
                  layout:(LZCollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    if (section == 0 && item % 2 == 0) {
        return NSMakeSize(100, 100);
    }
    else if (section == 1 && item % 2 == 0) {
        return NSMakeSize(120, 120);
    }
    else if (section == 2 && item % 2 == 0) {
        return NSMakeSize(150, 150);
    }
    
    return NSMakeSize(200, 200);
}

- (NSSize)collectionView:(LZCollectionView *)collectionView
                  layout:(LZCollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section
{
    return NSMakeSize([_collectionView visibleRect].size.width, 30);
}

- (NSSize)collectionView:(LZCollectionView *)collectionView
                  layout:(LZCollectionViewLayout *)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section
{
    return NSMakeSize([_collectionView visibleRect].size.width, 30);
}


@end
