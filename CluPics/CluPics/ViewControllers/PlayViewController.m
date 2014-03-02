//
//  PlayViewController.m
//  CluPics
//
//  Created by Ryley Herrington on 2/28/14.
//  Copyright (c) 2014 Ryley Herrington. All rights reserved.
//

#import "PlayViewController.h"
#import "RHSubmission.h"

//Menu and Transitions
#import "UIViewController+ECSlidingViewController.h"
#import "RHDynamicTransition.h"

@interface PlayViewController ()

@property (nonatomic, strong) RHDynamicTransition *transition;
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, assign) BOOL didCaptureImage;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;

-(void)showImagePicker;

@end

@implementation PlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //configure the transition for swipe menu
    self.transition = [[RHDynamicTransition alloc] init];
    self.transition.slidingViewController = self.slidingViewController;
    
    self.slidingViewController.delegate = self.transition;
    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGestureCustom;
    self.slidingViewController.customAnchoredGestures = @[self.dynamicTransitionPanGesture];
    [self.view addGestureRecognizer:self.dynamicTransitionPanGesture];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tranistion Stuff
- (UIPanGestureRecognizer *)dynamicTransitionPanGesture {
    if (_dynamicTransitionPanGesture) return _dynamicTransitionPanGesture;
    
    _dynamicTransitionPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.transition action:@selector(handlePanGesture:)];
    
    return _dynamicTransitionPanGesture;
}

- (IBAction)imageTouched:(id)sender {
    [self showImagePicker];
}

-(void)showImagePicker{
    if (NO == [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Camera Required"
                                                        message:@"This application requres a camera."
                                                       delegate:self cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    [self.imagePicker setSourceType: UIImagePickerControllerSourceTypeCamera];
    [self.imagePicker setDelegate:self];
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - IBAction
-(IBAction)submit:(id)sender {
    RHSubmission *submission = [[RHSubmission alloc] init];
    submission.image = self.img.image;
    submission.username = self.usernameField.text;
    
    NSLog(@"Created submission: %@", submission);
    
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Submitted!"
                                                        message:@"Looks like ya finally did it."
                                                       delegate:nil
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:nil,
                               nil];
    [alertView show];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self.img setImage:info[UIImagePickerControllerOriginalImage]];
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    self.didCaptureImage = YES;
}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    _usernameField.text = textField.text;
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}
@end
