//
//  FRPPhotoImporter.m
//  KYFRPDemo
//
//  Created by KangYang on 16/2/14.
//  Copyright © 2016年 KangYang. All rights reserved.
//

#import "FRPPhotoImporter.h"
#import "FRPPhotoModel.h"

@implementation FRPPhotoImporter

+ (RACSignal *)importPhotos
{
    NSURLRequest *request = [self popularURLRequest];
    
    return [[[[[[NSURLConnection rac_sendAsynchronousRequest:request] reduceEach:^id(NSURLResponse *response, NSData *data){
        return data;
    }] deliverOn:[RACScheduler mainThreadScheduler]] map:^id(NSData *data) {
        id results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        return [[[results[@"photo"] rac_sequence] map:^id(NSDictionary *photoDictionary) {
            FRPPhotoModel *model = [FRPPhotoModel new];
            [self configurePhotoModel:model withDictionary:photoDictionary];
            [self downloadThumbnailForPhotoModel:model];
            return model;
        }] array];
    }] publish] autoconnect];
}

+ (RACSignal *)fetchPhotoDetails:(FRPPhotoModel *)photoModel
{
    NSURLRequest *request = [self photoURLRequest:photoModel];
    
    return [[[[[[NSURLConnection rac_sendAsynchronousRequest:request] map:^id(RACTuple *value) {
        return [value second];
    }] deliverOn:[RACScheduler mainThreadScheduler]] map:^id(NSData *data) {
        id results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil][@"photo"];
        [self configurePhotoModel:photoModel withDictionary:results];
        [self downloadFullsizedImageForPhotoModel:photoModel];
        return photoModel;
    }] publish] autoconnect];
}

+ (NSURLRequest *)photoURLRequest:(FRPPhotoModel *)photoModel
{
    return [kAppDelegate.apiHelper urlRequestForPhotoID:photoModel.identifier.integerValue];
}

+ (NSURLRequest *)popularURLRequest
{
    return [kAppDelegate.apiHelper urlRequestForPhotoFeature:PXAPIHelperPhotoFeaturePopular
                                              resultsPerPage:100
                                                        page:0
                                                  photoSizes:PXPhotoModelSizeThumbnail
                                                   sortOrder:PXAPIHelperSortOrderRating
                                                      except:PXPhotoModelCategoryNude];
}

+ (void)configurePhotoModel:(FRPPhotoModel *)photomodel withDictionary:(NSDictionary *)dictionary
{
    photomodel.photoName = dictionary[@"name"];
    photomodel.identifier = dictionary[@"id"];
    photomodel.photographerName = dictionary[@"user"][@"username"];
    photomodel.rating = dictionary[@"rating"];
    photomodel.thumbnailURL = [self urlForImageSize:3 inDictionary:dictionary[@"images"]];
    if (dictionary[@"comments_count"]) {
        photomodel.fullsizedURL = [self urlForImageSize:4 inDictionary:dictionary[@"images"]];
    }
}

+ (NSString *)urlForImageSize:(NSInteger)size inDictionary:(NSArray *)array
{
    return [[[[[array rac_sequence] filter:^BOOL(NSDictionary *value) {
        return [value[@"size"] integerValue] == size;
    }] map:^id(id value) {
        return value[@"url"];
    }] array] firstObject];
}

+ (void)downloadFullsizedImageForPhotoModel:(FRPPhotoModel *)photoModel
{
    RAC(photoModel, fullsizedData) = [self download:photoModel.fullsizedURL];
}

+ (void)downloadThumbnailForPhotoModel:(FRPPhotoModel *)photoModel
{
    RAC(photoModel, thumbnailData) = [self download:photoModel.thumbnailURL];
}

+ (RACSignal *)download:(NSString *)urlString
{
    NSAssert(urlString, @"URL must not be nil");
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    return [[[NSURLConnection rac_sendAsynchronousRequest:request] map:^id(RACTuple *value) {
        return [value second];
    }] deliverOn:[RACScheduler mainThreadScheduler]];
}

@end
