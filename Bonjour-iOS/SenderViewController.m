//
//  SenderViewController.m
//  Bonjour-iOS
//
//  Created by Yifei Zhou on 10/26/14.
//  Copyright (c) 2014 Peng Sun. All rights reserved.
//

#import "SenderViewController.h"

#define kServiceName @"share_editor"
#define kServiceProtocol @"tcp"

@interface SenderViewController () <BSBonjourServerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *publishBtn;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) BSBonjourServer *bonjourManager;

@end

@implementation SenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.bonjourManager = [[BSBonjourServer alloc] initWithServiceType:kServiceName transportProtocol:kServiceProtocol delegate:self];
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.indicatorView];
    self.title = @"Sender";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)publishBtnClicked:(id)sender {
    if ([[(UIBarButtonItem *)sender title] isEqualToString:@"Publish"]) {
        [self.bonjourManager publish];
        [self.textView resignFirstResponder];
        [(UIBarButtonItem *)sender setTitle:@"Stop"];
        [self.indicatorView startAnimating];
    } else {
        [self.bonjourManager unpublish];
        [(UIBarButtonItem *)sender setTitle:@"Publish"];
        [self.indicatorView stopAnimating];
    }
}

#pragma mark -
#pragma mark - BSBonjourServerDelegate

- (void)published:(NSString *)name {
    NSLog(@"Published with name: %@", name);
}

- (void)registerFailed:(NSError *)error {
    NSLog(@"Server registered failed: %@", error.localizedDescription);
}

- (void)publishFailed:(NSError *)error {
    NSLog(@"Published encountered an error: %@", error.localizedDescription);
}

- (void)serviceStopped:(NSString *)name {
    NSLog(@"Publish Stopped!");
}

#pragma mark -
#pragma mark - BSBonjourConnectionDelegate

- (void)connectionEstablished:(BSBonjourConnection *)connection {
    [connection sendData:[self.textView.text dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)connectionAttemptFailed:(BSBonjourConnection *)connection {
    NSLog(@"Connection Failed...");
}

- (void)connectionTerminated:(BSBonjourConnection *)connection {
    NSLog(@"Connection Terminated!");
}

- (void)receivedData:(NSData *)data {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message Received" message:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alert show];
}

@end
