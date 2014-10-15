//
//  DemoTableViewCell.h
//  Bonjour-iOS
//
//  Created by Yifei Zhou on 10/15/14.
//  Copyright (c) 2014 Peng Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *hostnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *protocolLabel;

@end
