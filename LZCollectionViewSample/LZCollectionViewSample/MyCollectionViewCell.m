//
//  MyCollectionViewCell.m
//  CustomControl
//
//  Created by liww on 15-10-31.
//  Copyright (c) 2015年 liww. All rights reserved.
//

#import "MyCollectionViewCell.h"

@implementation MyCollectionViewCell


- (id)init
{
    self = [super init];
    if (self){
        
        // 初始化时加载xib文件
        BOOL loadSuccess = NO;
        NSMutableArray *topLevelObjs = [NSMutableArray array];
        
        if ([[NSBundle bundleForClass:[self class]] respondsToSelector:@selector(loadNibNamed:owner:topLevelObjects:)]) {
            // We're running on Mountain Lion or higher
            loadSuccess = [[NSBundle bundleForClass:[self class]] loadNibNamed:@"MyCollectionViewCell"
                                                                         owner:self
                                                               topLevelObjects:&topLevelObjs];
        }
        else {
            // We're running on Lion
            //            loadSuccess = [NSBundle loadNibNamed:@"MyCollectionViewCell"
            //                                           owner:self];
            
            NSDictionary *nameTable = [NSDictionary dictionaryWithObjectsAndKeys:
                                       self, NSNibOwner,
                                       topLevelObjs, NSNibTopLevelObjects,
                                       nil];
            loadSuccess = [[NSBundle bundleForClass:[self class]] loadNibFile:@"MyCollectionViewCell" externalNameTable:nameTable withZone:nil];
        }
        
        if (!loadSuccess || [topLevelObjs count] <= 0) {
            return nil;
        }
        
        for (int i = 0; i < [topLevelObjs count]; i++) {
            if ([[topLevelObjs objectAtIndex:i] isKindOfClass:NSClassFromString(@"MyCollectionViewCell")]){
                self = [topLevelObjs objectAtIndex:i];
                break;
            }
        }
    }
    
    return self;
}

- (void)awakeFromNib
{

}

- (void)setImage:(NSImage *)image
{
    [_imageView setImage:image];
}

- (void)setText:(NSString *)text
{
    if (text == nil) {
        [_textField setStringValue:@"text"];
    }
    else{
        [_textField setStringValue:text];
    }
}
@end
