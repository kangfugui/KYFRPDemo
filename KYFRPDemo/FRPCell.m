//
//  FRPCell.m
//  KYFRPDemo
//
//  Created by KangYang on 16/2/14.
//  Copyright © 2016年 KangYang. All rights reserved.
//

#import "FRPCell.h"
#import "FRPPhotoModel.h"

@interface FRPCell ()

@property (weak, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) FRPPhotoModel *photoModel;

@end

@implementation FRPCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor darkGrayColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    
    RAC(self.imageView, image) = [[RACObserve(self, photoModel.thumbnailData) ignore:nil] map:^id(NSData *data) {
        return [UIImage imageWithData:data];
    }];
    
    return self;
}

@end
