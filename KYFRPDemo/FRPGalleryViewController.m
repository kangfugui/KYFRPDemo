//
//  FRPGalleryViewController.m
//  KYFRPDemo
//
//  Created by KangYang on 16/2/14.
//  Copyright © 2016年 KangYang. All rights reserved.
//

#import "FRPGalleryViewController.h"
#import "FRPFullSizePhotoViewController.h"
#import "FRPGalleryFlowLayout.h"
#import "FRPPhotoImporter.h"
#import "FRPCell.h"
#import <ReactiveCocoa/RACDelegateProxy.h>

@interface FRPGalleryViewController ()

@property (strong, nonatomic) NSArray *photoArray;
@property (strong, nonatomic) id collectionViewDelegate;

@end

@implementation FRPGalleryViewController

static NSString *CellIdentifier = @"Cell";

- (instancetype)init
{
    FRPGalleryFlowLayout *flowLayout = [[FRPGalleryFlowLayout alloc] init];
    self = [self initWithCollectionViewLayout:flowLayout];
    if (!self) return nil;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Popular";
    [self.collectionView registerClass:[FRPCell class] forCellWithReuseIdentifier:CellIdentifier];
    
    @weakify(self);
    [RACObserve(self, photoArray) subscribeNext:^(id x) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
    
    RACDelegateProxy *viewControllerDelegate = [[RACDelegateProxy alloc] initWithProtocol:@protocol(FRPFullSizePhotoViewControllerDelegate)];
    [[viewControllerDelegate rac_signalForSelector:@selector(userDidScroll:toPhotoAtIndex:) fromProtocol:@protocol(FRPFullSizePhotoViewControllerDelegate)] subscribeNext:^(RACTuple *value) {
        
        @strongify(self);
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:[value.second integerValue] inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                            animated:NO];
    }];
    
    self.collectionViewDelegate = [[RACDelegateProxy alloc] initWithProtocol:@protocol(UICollectionViewDelegate)];
    [[self.collectionViewDelegate rac_signalForSelector:@selector(collectionView:didSelectItemAtIndexPath:)] subscribeNext:^(RACTuple *arguments) {
        
        @strongify(self);
        FRPFullSizePhotoViewController *viewController = [[FRPFullSizePhotoViewController alloc] initWithPhotoModels:self.photoArray currentPhotoIndex:[(NSIndexPath *)arguments.second item]];
        viewController.delegate = (id<FRPFullSizePhotoViewControllerDelegate>)viewControllerDelegate;
        [self.navigationController pushViewController:viewController animated:YES];
    }];
    
    self.collectionView.delegate = self.collectionViewDelegate;
    
    RAC(self, photoArray) = [[[[FRPPhotoImporter importPhotos] doCompleted:^{
        
        @strongify(self);
        [self.collectionView reloadData];
        
    }] logError] catchTo:[RACSignal empty]];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRPCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setPhotoModel:self.photoArray[indexPath.row]];
    
    return cell;
}

@end
