//
//  ViewController.m
//  GameMemoryImage
//
//  Created by VTIT on 10/12/13.
//  Copyright (c) 2013 VTIT. All rights reserved.
//

#import "ViewController.h"

#define IMAGE_ICON @"Icon.png"
#define NUMBER_ROW 3
#define NUMBER_COLUMN 4
#define NUMBER_IMAGE 6
#define WITH_IMAGE 60
#define TAG_NUMBER 2008

@interface ViewController ()
{
    int numberOfRow ; //so rong
    int numberOfColumn ; //so anh
    int numberOfImage ; //so anh
    
    NSArray *arrayImageAll; //Danh sach anh
    NSMutableArray *arrayImageToChoice; //Danh sach anh de chon
    
    NSMutableArray *arrayImageHidden;
    
    
    UIImageView *_backPhoto; //backup anh duoc doi.
    
    UIView *_transparentView; //view de thuc hien doi anh
   
    
    
    int tagLastOpen; //tap vua add lan truoc
    NSString *imageLastOpen; //anh vua mo lan truoc
    int heightTemp; //chieu cao bat dau hien thi danh sach anh
    
    int ImageCountSelected;

}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tagLastOpen = -1;
    imageLastOpen = @"";
    heightTemp = 200;
    ImageCountSelected = 0;
    numberOfColumn = NUMBER_COLUMN;
    numberOfRow = NUMBER_ROW;
    numberOfImage = NUMBER_IMAGE;
	// Do any additional setup after loading the view, typically from a nib.
    ImageResources *imageResource = [[ImageResources alloc]init];
    arrayImageAll = [imageResource getAllImages];
    
    //ArrayIndexImage
    
    arrayImageToChoice = [NSMutableArray arrayWithArray:arrayImageAll];
    [arrayImageToChoice addObjectsFromArray:arrayImageAll];
    
    //int r = arc4random() % 6;
    
    arrayImageHidden = [[NSMutableArray alloc]init];
    
   // int heightTemp = 200;
    int k = 0;
    NSString *imageUrl = @"";
    for (int i=0; i<NUMBER_ROW; i++) {
        for (int j=0; j<NUMBER_COLUMN; j++) {
            //lay anh random trong danh sach con lai
            int boundIndexImage = 2*NUMBER_IMAGE - k;
             
          //  NSLog(@"k = %d bound = %d  random = %d");
            
            
            if (boundIndexImage>0) {
                int random = arc4random()%boundIndexImage;
               imageUrl = [arrayImageToChoice objectAtIndex:random];
                [arrayImageToChoice removeObjectAtIndex:random];
            }else{
                imageUrl = [arrayImageToChoice objectAtIndex:0];
            }
            [arrayImageHidden addObject:imageUrl];
            NSLog(@"k = %d", k);
            NSLog(@" i = %d , j=%d x = %d y = %d", i, j, 20+(j*WITH_IMAGE), heightTemp + (i*WITH_IMAGE)+10);
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:IMAGE_ICON]];
            imageView.frame = CGRectMake(20+(j*WITH_IMAGE), heightTemp + (i*WITH_IMAGE)+10, WITH_IMAGE, WITH_IMAGE);
           // NSLog(@"%d - %d - %d - %d", );
            imageView.userInteractionEnabled = YES;
            imageView.tag = k+TAG_NUMBER;
            UITapGestureRecognizer *tapB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flip:)];
            
            [imageView addGestureRecognizer:tapB];
            
            [self.view addSubview:imageView];
            
            k++;
            //
        }
    }
    
    arrayImageToChoice = [NSMutableArray arrayWithArray:arrayImageAll];
    [arrayImageToChoice addObjectsFromArray:arrayImageAll];
}


-(void) flip: (UITapGestureRecognizer *) gesture
{
    NSString *imageToOpen = @"";
    UIImageView *tapImageView = (UIImageView*) gesture.view;
    int tag = tapImageView.tag;
    int i = (tag-TAG_NUMBER)/numberOfColumn;
    int j = (tag-TAG_NUMBER) - i*numberOfColumn;
    //NSLog(@"row = %d , column = %d", i, j);
    NSLog(@"tag = %d i = %d , j=%d x = %d y = %d",tag, i, j, 20+(j*WITH_IMAGE), heightTemp + (i*WITH_IMAGE)+10);
   
    //neu lan truoc click va lan nay click thi hien thi
    //de lai cai anh thanh anh ban dau
    if (tagLastOpen == tag) {
        imageToOpen = IMAGE_ICON;
    }else{
        imageToOpen = [arrayImageToChoice objectAtIndex:tag-TAG_NUMBER];
    }
    _backPhoto = [[UIImageView alloc] initWithImage: [UIImage imageNamed:imageToOpen]];
     _backPhoto.frame = CGRectMake(0, 0, WITH_IMAGE, WITH_IMAGE);
    _backPhoto.tag = tag;
    _backPhoto.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flip:)];
    [_backPhoto addGestureRecognizer:tapB];
    
    
    
    
    //co  1 cai view trung gian
    
    _transparentView = [[UIView alloc] initWithFrame: CGRectMake(20+(j*WITH_IMAGE), heightTemp + (i*WITH_IMAGE)+10, WITH_IMAGE, WITH_IMAGE)];
    [self.view addSubview:_transparentView];
    
    
        [UIView transitionWithView:_transparentView duration:1 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            [tapImageView removeFromSuperview];
            BOOL checkInsert = YES;
            //truong hop nay se xoa ca 2 cai di
            if (tag != tagLastOpen && [imageToOpen isEqualToString:imageLastOpen] ) {
                NSLog(@"truong hop 1");
                
                [_backPhoto removeFromSuperview];
                
                UIImageView *lastviewOpen = (UIImageView*) [self.view viewWithTag:tagLastOpen];
                [lastviewOpen removeFromSuperview];
                NSLog(@"remove taglast opent = %d", tagLastOpen);
                UIView *removeView;
                while((removeView = [self.view viewWithTag:tagLastOpen]) != nil) {
                    [removeView removeFromSuperview];
                }
                ImageCountSelected ++;
                if (ImageCountSelected ==numberOfImage ) {
                    NSLog(@"choi xong roi choi lai di");
                }
                tagLastOpen = -1;
                imageLastOpen = @"";
                checkInsert = NO;
                
            }else{
                
                //dong 2 cai lai
                if (tagLastOpen == -1) {
                    NSLog(@"truong hop 2");
                    tagLastOpen = tag;
                    imageLastOpen = imageToOpen;
                }else{
                    
                NSLog(@"truong hop 3");
                
                UIImageView *lastviewOpen =(UIImageView*) [self.view viewWithTag:tagLastOpen];
                lastviewOpen.image = [UIImage imageNamed:IMAGE_ICON];
                    
                   // [lastviewOpen setImage:[UIImage imageNamed:IMAGE_ICON]];
                   // [lastviewOpen layoutIfNeeded];
                
                    
                _backPhoto.image = [UIImage imageNamed:IMAGE_ICON];
                    tagLastOpen = -1;
                    imageLastOpen = @"";
                }
            }
            
            if (checkInsert) {
                 [_transparentView addSubview:_backPhoto];
            }
         
            
            
        } completion:^(BOOL finished){
            //_isFrontFace = NO;
            
            //kiem tra xem bakupphoto xem co view giong nhu photo(la cai vua lan co anh giong nhau hay khong?)
            //neu giong nhau thi xoa ca 2 anh di.
            
        }];
        
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
