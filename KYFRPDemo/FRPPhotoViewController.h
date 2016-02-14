//
//  FRPPhotoViewController.h
//  KYFRPDemo
//
//  Created by KangYang on 16/2/14.
//  Copyright © 2016年 KangYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FRPPhotoModel;

@interface FRPPhotoViewController : UIViewController

- (instancetype)initWithPhotoModel:(FRPPhotoModel *)photoModel index:(NSInteger)photoIndex;

@property (readonly, nonatomic) NSInteger photoIndex;
@property (readonly, nonatomic) FRPPhotoModel *photoModel;

@end
