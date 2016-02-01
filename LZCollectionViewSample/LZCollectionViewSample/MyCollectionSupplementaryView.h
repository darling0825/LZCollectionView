//
//  MyCollectionSupplementaryView.h
//  CustomControl
//
//  Created by 沧海无际 on 14/11/8.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <LZCollectionView/LZCollectionView.h>

@interface MyCollectionSupplementaryView : LZCollectionReusableView{
    IBOutlet NSImageView *_imageView;
    IBOutlet NSTextField *_textField;
}
@property (nonatomic,copy)NSColor *backgroundColor;
@property(nonatomic,copy) IBOutlet NSImage *image;
@property(nonatomic,copy) IBOutlet NSString *text;

@end
