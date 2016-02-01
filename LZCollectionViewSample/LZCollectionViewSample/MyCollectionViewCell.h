//
//  MyCollectionViewCell.h
//  CustomControl
//
//  Created by liww on 15-10-31.
//  Copyright (c) 2015年 liww. All rights reserved.
//

#import <LZCollectionView/LZCollectionView.h>

@interface MyCollectionViewCell : LZCollectionViewCell{
    IBOutlet NSImageView *_imageView;
    IBOutlet NSTextField *_textField;
}
@property(nonatomic,retain) IBOutlet NSImage *image;
@property(nonatomic,copy) IBOutlet NSString *text;
@end
