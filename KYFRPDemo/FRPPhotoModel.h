//
//  FRPPhotoModel.h
//  KYFRPDemo
//
//  Created by KangYang on 16/2/14.
//  Copyright © 2016年 KangYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRPPhotoModel : NSObject

@property (strong, nonatomic) NSString *photoName;
@property (strong, nonatomic) NSNumber *identifier;
@property (strong, nonatomic) NSString *photographerName;
@property (strong, nonatomic) NSNumber *rating;
@property (strong, nonatomic) NSString *thumbnailURL;
@property (strong, nonatomic) NSData *thumbnailData;
@property (strong, nonatomic) NSString *fullsizedURL;
@property (strong, nonatomic) NSData *fullsizedData;

@end
