//
//  RHSubmission.h
//  CluPics
//
//  Created by Ryley Herrington on 3/1/14.
//  Copyright (c) 2014 Ryley Herrington. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RHSubmission : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *prompt;
@property (nonatomic, copy) NSString *username;

@end
