//
//  FRPPhotoViewController.m
//  KYFRPDemo
//
//  Created by KangYang on 16/2/14.
//  Copyright © 2016年 KangYang. All rights reserved.
//

#import "FRPPhotoViewController.h"
#import "FRPPhotoModel.h"
#import "FRPPhotoImporter.h"
#import <SVProgressHUD.h>

@interface FRPPhotoViewController ()

@property (assign, nonatomic) NSInteger photoIndex;
@property (strong, nonatomic) FRPPhotoModel *photoModel;

@property (weak, nonatomic) UIImageView *imageView;

@end

@implementation FRPPhotoViewController

- (instancetype)initWithPhotoModel:(FRPPhotoModel *)photoModel index:(NSInteger)photoIndex
{
    self = [super init];
    if (!self) return nil;
    
    self.photoModel = photoModel;
    self.photoIndex = photoIndex;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    self.imageView = imageView;
    RAC(imageView, image) = [RACObserve(self.photoModel, fullsizedData) map:^id(id value) {
        return [UIImage imageWithData:value];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [SVProgressHUD show];
    
    [[FRPPhotoImporter fetchPhotoDetails:self.photoModel] subscribeError:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Error"];
    } completed:^{
        [SVProgressHUD dismiss];
    }];
}

@end
