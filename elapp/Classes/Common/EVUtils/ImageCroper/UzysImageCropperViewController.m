//
//  UzysImageCropperViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "UzysImageCropperViewController.h"

@implementation UzysImageCropperViewController
@synthesize cropperView,delegate;

- (id)initWithImage:(UIImage*)newImage andframeSize:(CGSize)frameSize andcropSize:(CGSize)cropSize
{
    return [self initWithImage:newImage andframeSize:frameSize andcropSize:cropSize originImage:NO];
}

- (id)initWithImage:(UIImage*)newImage andframeSize:(CGSize)frameSize andcropSize:(CGSize)cropSize originImage:(BOOL)originImage
{
    self = [super init];
	
	if (self) {
        
        if(!originImage || newImage.size.width <= cropSize.width || newImage.size.height <= cropSize.height)
        {
            EVLog(@"Image Size is smaller than cropSize");
            newImage = [newImage resizedImageToFitInSize:CGSizeMake(cropSize.width, cropSize.height) scaleIfSmaller:YES];
            EVLog(@"newImage Size %@",NSStringFromCGSize(newImage.size));
        }
        self.view.backgroundColor = [UIColor blackColor];
        cropperView = [[UzysImageCropper alloc] 
                       initWithImage:newImage 
                       andframeSize:frameSize
                       andcropSize:cropSize];
        [self.view addSubview:cropperView];
        UIView *copyFrameView = (UIView *)[cropperView valueForKey:@"_cropperView"];
        [copyFrameView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        UIView *controlView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-60, self.view.bounds.size.width, 60)];
        [controlView setBackgroundColor:[UIColor blackColor]];
        
        [self.view addSubview:controlView];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 40, 60)];
        [cancelBtn setTitle:kCancel forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [controlView addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(cancelCropping) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-40-10, 5, 40, 60)];
        [okBtn setTitle:kOK forState:UIControlStateNormal];
        okBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [controlView addSubview:okBtn];
        [okBtn addTarget:self action:@selector(finishCropping) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return self;
    
}
-(void) actionRestore:(id) senders
{
    [cropperView actionRestore];
}
-(void) actionRotation:(id) senders
{
    [cropperView actionRotate];
}
- (void)cancelCropping
{
    if (delegate && [delegate respondsToSelector:@selector(imageCropperDidCancel:)]) {
        [delegate imageCropperDidCancel:self];
    };
}

- (void)finishCropping
{
    //EVLog(@"%@",@"ImageCropper finish cropping end");
    UIImage *cropped =[cropperView getCroppedImage];
    if (delegate && [delegate respondsToSelector:@selector(imageCropper:didFinishCroppingWithImage:)]) {
        [delegate imageCropper:self didFinishCroppingWithImage:cropped];
    };
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
// Implement loadView to create a view hierarchy programmatically, without using a nib.
//- (void)loadView
//{
// 
//
//}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.cropperView = nil;
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [cropperView release];
    [super ah_dealloc];
}

@end
