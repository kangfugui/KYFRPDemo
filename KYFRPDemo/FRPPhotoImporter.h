//
//  FRPPhotoImporter.h
//  KYFRPDemo
//
//  Created by KangYang on 16/2/14.
//  Copyright © 2016年 KangYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FRPPhotoModel;

@interface FRPPhotoImporter : NSObject

+ (RACSignal *)importPhotos;
+ (RACSignal *)fetchPhotoDetails:(FRPPhotoModel *)photoModel;

@end
