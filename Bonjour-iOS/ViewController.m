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

@interface ViewController () <BSBonjourBrowseDelegate, UITableViewDataSource>

- (IBAction)searchBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchBtn;
@property (strong, nonatomic) BSBonjourManager *bonjourManager;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;
@property (strong, nonatomic) NSMutableArray *serviceArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.bonjourManager = [BSBonjourManager sharedManager];
    self.serviceArray = [[NSMutableArray alloc] init];
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.indicatorView];
    self.tableView.rowHeight = 80.0f;
    self.tableView.dataSource = self;
    self.title = @"Bonjour iOS";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchBtnClicked:(id)sender {
    if ([[(UIBarButtonItem *)sender title] isEqualToString:@"Search"]) {
        [self.bonjourManager search:kServiceName transportProtocol:kServiceProtocol delegate:self];
        [(UIBarButtonItem *)sender setTitle:@"Stop"];
        [self.indicatorView startAnimating];
    } else {
        [self.bonjourManager stopSearch:kServiceName transportProtocol:kServiceProtocol];
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
    
    NSNetService *service = [self.serviceArray objectAtIndex:indexPath.row];
    
    cell.hostnameLabel.text = service.hostName;
    cell.serviceLabel.text = service.name;
    cell.protocolLabel.text = service.type;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.serviceArray count];
}


#pragma mark -
#pragma mark BSBonjourBrowseDelegate
- (void)didFindService:(NSNetService *)service moreComing:(BOOL)moreComing {
    NSLog(@"Find Service: %@", service);
    [self.serviceArray addObject:service];
    if (!moreComing) {
        [self.tableView reloadData];
    }
}

- (void)didRemoveService:(NSNetService *)service moreComing:(BOOL)moreComing {
    NSLog(@"Remove Service: %@", service);
    [self.serviceArray removeObject:service];
    if (!moreComing) {
        [self.tableView reloadData];
    }
}

- (void)searchStarted {
    NSLog(@"Search Started!");
}

- (void)searchStopped {
    NSLog(@"Search Stopped!");
}

- (void)searchFailed:(NSError *)error {
    NSLog(@"Search Failed: %@", error.localizedDescription);
}
@end
