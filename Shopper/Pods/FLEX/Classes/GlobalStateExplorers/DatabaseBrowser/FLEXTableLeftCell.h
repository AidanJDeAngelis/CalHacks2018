//
//  FLEXTableLeftCell.h
//  UICatalog
//
//  Created by Peng Tao on 15/11/24.
//  Copyright © 2015年 f. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLEXTableLeftCell : UITableViewCell

@property (nonatomic, strong) UILabel *titlelabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
