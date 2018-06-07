//
//  ManyImageViewController.m
//  Advertising
//
//  Created by hht on 2018/5/30.
//  Copyright © 2018年 hht. All rights reserved.
//

#import "ManyImageViewController.h"
#import "ZYQAssetPickerController.h"
#import "CollectionViewCell.h"


@interface ManyImageViewController ()<UIActionSheetDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic ,strong) ZYQAssetPickerController *pickerController;
@property (nonatomic ,strong) UICollectionView *collectionView;


@property (nonatomic ,strong) NSMutableArray *imageArray;
@property (nonatomic ,strong) NSMutableArray *imageDataArray;

@property (nonatomic ,assign) NSInteger i;
@property (nonatomic, assign) BOOL judgeBool;//判断是否点击删除
@end

@implementation ManyImageViewController

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
        //        flowLayOut.minimumInteritemSpacing = 11;
        //        flowLayOut.minimumLineSpacing = 11;
        flowLayOut.itemSize = CGSizeMake(80, 80);
        flowLayOut.sectionInset = UIEdgeInsetsMake(11, 11, 0, 11);
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:flowLayOut];
        
        _collectionView.backgroundColor = [UIColor purpleColor];
        
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        //        self.collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}

- (NSMutableArray *)imageDataArray{
    if (!_imageDataArray) {
        self.imageDataArray = [NSMutableArray array];
    }
    return _imageDataArray;
}

- (NSMutableArray *)imageArray{
    if (!_imageArray) {
        self.imageArray = [NSMutableArray array];
        
    }
    return _imageArray;
}

- (ZYQAssetPickerController *)pickerController{
    if (!_pickerController) {
        self.pickerController = [[ZYQAssetPickerController alloc] init];
        _pickerController.maximumNumberOfSelection = 3;
        _pickerController.assetsFilter = ZYQAssetsFilterAllAssets;
        _pickerController.showEmptyGroups=NO;
        _pickerController.delegate=self;
        _pickerController.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            if ([(ZYQAsset*)evaluatedObject mediaType]==ZYQAssetMediaTypeVideo) {
                NSTimeInterval duration = [(ZYQAsset*)evaluatedObject duration];
                return duration >= 5;
            } else {
                return YES;
            }
        }];
    }
    return _pickerController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的相册";
    _judgeBool = NO;
    [self addNavier];
    self.view.backgroundColor = [UIColor purpleColor];
    self.i = 0;
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[AddCollectionViewCell class] forCellWithReuseIdentifier:@"identifier"];
    [self.view addSubview:self.collectionView];
    
    // Do any additional setup after loading the view.
}
-(void)addNavier{
    UIButton *applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    applyBtn.frame = CGRectMake(0, 0, 40, 44);
    [applyBtn setTitle:@"删除" forState:UIControlStateNormal];
    [applyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    applyBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [applyBtn addTarget:self action:@selector(applyCard:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:applyBtn];
}
-(void)applyCard:(UIButton *)sender{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    if (button.selected) {
        _judgeBool = YES;
    }else{
        _judgeBool = NO;
    }
    [_collectionView reloadData];
    NSLog(@"_judgeBool===%@",_judgeBool?@"YES":@"NO");
}
-(void)submitPictureToServer{
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"模拟器没有相机");

    }];
    UIAlertAction *photo = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self presentViewController:self.pickerController animated:YES completion:nil];
    }];
    
    [sheet addAction:camera];
    [sheet addAction:photo];
    [sheet addAction:cancel];

    [self presentViewController:sheet animated:YES completion:nil];
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"从相册获取", nil];
//    [sheet showInView:self.view];
    
}

//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex == 0) {
//        NSLog(@"模拟器没有相机");
//    }else if (buttonIndex == 1){
//        [self presentViewController:self.pickerController animated:YES completion:nil];
//    }
//}


#pragma mark ---------collectionView代理方法--------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    return self.imageArray.count + 1 ;
    
    
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AddCollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"identifier" forIndexPath:indexPath];
    
    if (self.imageArray.count == 0) {
        return cell1;
        
    }else{
        CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        
        if (indexPath.item + 1 > self.imageArray.count ) {
            return cell1;
            
        }else{
            cell.imageV.image = self.imageArray[indexPath.item];
            [cell.imageV addSubview:cell.deleteButotn];
            cell.deleteButotn.tag = indexPath.item + 100;
            [cell.deleteButotn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
            if (_judgeBool == YES) {
                cell.deleteButotn.hidden = NO;
            }else{
                cell.deleteButotn.hidden = YES;
            }
        }
        
        
        return cell;
    }
    
    
    
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item + 1 > self.imageArray.count ) {
        NSLog(@"上传");
        [self submitPictureToServer];
    }else{
        ImageViewController *imageViewC =[[ImageViewController alloc] init];
        //取出存储的高清图片
        imageViewC.imageData = self.imageDataArray[indexPath.item];
        [self presentViewController:imageViewC animated:YES completion:nil];
    }
    
}

#pragma mark --------删除图片-----------

- (void)deleteImage:(UIButton *)sender{
    NSInteger index = sender.tag - 100;
    
    //移除显示图片数组imageArray中的数据
    [self.imageArray removeObjectAtIndex:index];
    //移除沙盒数组中imageDataArray的数据
    [self.imageDataArray removeObjectAtIndex:index];
    
//    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    //获取Document文件的路径
//    NSString *collectPath = filePath.lastObject;
//    NSFileManager * fileManager = [NSFileManager defaultManager];
//    //移除所有文件
//    [fileManager removeItemAtPath:collectPath error:nil];
//    //重新写入
//    for (int i = 0; i < self.imageDataArray.count; i++) {
//        NSData *imgData = self.imageDataArray[i];
//        [self WriteToBox:imgData];
//    }
    
    [self.collectionView reloadData];
    
}

#pragma mark ------相册回调方法----------

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i=0; i<assets.count; i++) {
            ZYQAsset *asset=assets[i];
            [asset setGetFullScreenImage:^(UIImage *result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //由于iphone拍照的图片太大，直接存入数组中势必会造成内存警告，严重会导致程序崩溃，所以存入沙盒中
                    //压缩图片，这个压缩的图片就是做为你传入服务器的图片
                    NSData *imageData=UIImageJPEGRepresentation(result, 0.8);
                    [self.imageDataArray addObject:imageData];
//                    [self WriteToBox:imageData];
                    //添加到显示图片的数组中
                    UIImage *image = [self OriginImage:result scaleToSize:CGSizeMake(80, 80)];
                    [self.imageArray addObject:image];
                    [self.collectionView reloadData];
                    NSLog(@"imageDataArray==%@",self->_imageDataArray);
                    NSLog(@"imageArray==%@",self->_imageArray);
                });
            }];
        }
});
    
    
//    [self dismissViewControllerAnimated:YES completion:^{
//        [self.collectionView reloadData];
//    }];
}


//选择图片上限提示
-(void)assetPickerControllerDidMaximum:(ZYQAssetPickerController *)picker{
    
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:nil message:@"到达9张图片上限" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [sheet addAction:cancel];
    [self presentViewController:sheet animated:YES completion:nil];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"到达9张图片上限" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//    [alert show];
}
/*
#pragma mark --------存入沙盒------------
- (void)WriteToBox:(NSData *)imageData{
    
    _i ++;
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取Document文件的路径
    NSString *collectPath = filePath.lastObject;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:collectPath]) {
        
        [fileManager createDirectoryAtPath:collectPath withIntermediateDirectories:YES attributes:nil error:nil];
        
    }
    //    //拼接新路径
    NSString *newPath = [collectPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Picture_%ld.png",_i]];
    NSLog(@"++%@",newPath);
    [imageData writeToFile:newPath atomically:YES];
}*/

#pragma mark -----改变显示图片的尺寸----------
-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
