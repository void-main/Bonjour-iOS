//
//  ViewController.m
//  Bonjour-iOS
//
//  Created by Sun Peng on 14-10-11.
//  Copyright (c) 2014年 Peng Sun. All rights reserved.
//

#import "ViewController.h"
#import "DemoTableViewCell.h"

#define kServiceName @"share_editor"
#define kServiceProtocol @"tcp"

@interface ViewController () <BSBonjourClientDelegate, UITableViewDataSource, UITableViewDelegate>

- (IBAction)searchBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchBtn;
@property (strong, nonatomic) BSBonjourClient *bonjourManager;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.bonjourManager = [[BSBonjourClient alloc] initWithServiceType:kServiceName transportProtocol:kServiceProtocol delegate:self];
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.indicatorView];
    self.tableView.rowHeight = 80.0f;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.title = @"Bonjour iOS";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchBtnClicked:(id)sender {
    if ([[(UIBarButtonItem *)sender title] isEqualToString:@"Search"]) {
        [self.bonjourManager startSearching];
        [(UIBarButtonItem *)sender setTitle:@"Stop"];
        [self.indicatorView startAnimating];
    } else {
        [self.bonjourManager stopSearching];
        [(UIBarButtonItem *)sender setTitle:@"Search"];
        [self.indicatorView stopAnimating];
    }
}

#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"serviceCell";
    DemoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[DemoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"serviceCell"];
    }
    
    NSNetService *service = [self.bonjourManager.foundServices objectAtIndex:indexPath.row];
    
    cell.hostnameLabel.text = service.name;
    NSArray *array = [service.type componentsSeparatedByString:@"."];
    cell.serviceLabel.text = array[0];
    cell.protocolLabel.text = array[1];
    
    NSLog(@"%@, %@, %@", service.hostName, service.name, service.type);
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.bonjourManager.foundServices count];
}

#pragma mark -
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.bonjourManager connectToServiceAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark BSBonjourClientDelegate

- (void)searchStarted {
    NSLog(@"Search Started!");
}

- (void)searchFailed:(NSError *)error {
    NSLog(@"Search encountered an error: %@", error.localizedDescription);
}

- (void)searchStopped {
    NSLog(@"Search Stopped!");
}

- (void)updateServiceList {
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark - BSBonjourConnectionDelegate

- (void)connectionEstablished:(BSBonjourConnection *)connection {
    NSLog(@"Connection Established...");
}

- (void)connectionAttemptFailed:(BSBonjourConnection *)connection {
    NSLog(@"Connection Failed...");
}

- (void)connectionTerminated:(BSBonjourConnection *)connection {
    NSLog(@"Connection Terminated!");
}

- (void)receivedData:(NSData *)data {
    // To-do
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message Received" message:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alert show];
    [self.bonjourManager disconnectFromService];
}
@end
