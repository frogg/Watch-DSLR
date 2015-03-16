//
//  ViewController.m
//  Watch DSLR
//
//  Created by Frederik Riedel on 14.03.15.
//  Copyright (c) 2015 Frederik Riedel. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
bool commandinit = false;
bool eventinit = false;
bool eventsocketconnected = false;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    camera = [[Camera alloc] init];
    camera.delegate=self;
    
}

-(void) connected {
    UIButton *captureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [captureButton setTitle:@"Bild Aufnehmen" forState:UIControlStateNormal];
    [captureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    captureButton.frame=CGRectMake(0, 0, self.view.frame.size.width, 100);
    [captureButton addTarget:self action:@selector(capture) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:captureButton];

    
    UIButton *liveViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [liveViewButton setTitle:@"Live View Starten" forState:UIControlStateNormal];
    [liveViewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    liveViewButton.frame=CGRectMake(0, 100, self.view.frame.size.width, 100);
    [liveViewButton addTarget:self action:@selector(liveView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:liveViewButton];

}

-(void) capture {
    [camera capture];
}

-(void) liveView {
    [camera startLiveView];
}


@end
