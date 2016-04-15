//
//  NIDropDown.m
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import "NIDropDown.h"
#import "QuartzCore/QuartzCore.h"

@interface NIDropDown ()
@property(nonatomic, strong) UITableView *table;
@property(nonatomic, strong) UIButton *btnSender;
@property(nonatomic, retain) NSArray *list;
@end

@implementation NIDropDown
@synthesize table;
@synthesize btnSender;
@synthesize list;
@synthesize delegate;

- (id)showDropDown:(UIButton *)b :(CGFloat *)height :(NSArray *)arr :(UIView *)parent {
    btnSender = b;
    self = [super init];
    if (self) {
//        self.tintColor = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:0.1];
        // Initialization code
        UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
        CGRect btn = [window convertRect:b.frame fromView:b.superview];
        
        self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
        self.list = [NSArray arrayWithArray:arr];
//        self.layer.masksToBounds = NO;
//        self.layer.cornerRadius = 8;
        self.layer.shadowOffset = CGSizeMake(-2, 2);
//        self.layer.shadowRadius = 5;
//        self.layer.shadowOpacity = 0.5;
        
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, 0)];
        table.delegate = self;
        table.dataSource = self;
//        table.layer.cornerRadius = 5;
        table.backgroundColor = [UIColor clearColor];
        if (CurrentVersion > 7.0) {
            table.separatorInset = (UIEdgeInsets){0,5,0,5};
        }
        table.separatorColor = [UIColor grayColor];
        
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.3];
//        self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, *height);
//        table.frame = CGRectMake(0, 0, btn.size.width, *height);
//        [UIView commitAnimations];
        self.parent = parent;
        self.targetFrame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, *height);
        [window addSubview:self];
        [self addSubview:table];
        [self blurWithColor:[BLRColorComponents lightEffect] updateInterval:.2f];
        [UIView animateWithDuration:0.25f animations:^{
            table.frame = CGRectMake(0, 0, btn.size.width, *height);
            self.frame = self.targetFrame;
            self.alpha = 1;
            
        } completion:^(BOOL finished) {
            if(self.blurType == KStaticBlur) {
                [self blurWithColor:self.colorComponents];
            }
        }];
    }
    return self;
}

-(void)hideDropDown:(UIButton *)b {
    if(self.timer != nil) {
        
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
    
    [UIView animateWithDuration:0.25f animations:^{
        
        self.frame = NHRectSetHeight(self.frame, 0);
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self myDelegate];
    }];
//    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
//    CGRect btn = [window convertRect:b.frame fromView:b.superview];
//    self.list = nil;
//    [table reloadData];
//    [UIView animateWithDuration:.3 animations:^{
//        self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
//        table.frame = CGRectMake(0, 0, btn.size.width, 0);
//    }completion:^(BOOL finished){
//        [self removeFromSuperview];
//        [self myDelegate];
//    }];
}

-(void)hideDropDown {
    if(self.timer != nil) {
        
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
    
    [UIView animateWithDuration:0.25f animations:^{
        
        self.frame = NHRectSetHeight(self.frame, 0);
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self myDelegate];
    }];
//    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
//    CGRect btn = [window convertRect:btnSender.frame fromView:btnSender.superview];
//    self.list = nil;
//    [table reloadData];
//    [UIView animateWithDuration:.3 animations:^{
//        self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
//        table.frame = CGRectMake(0, 0, btn.size.width, 0);
//    }completion:^(BOOL finished){
//        [self removeFromSuperview];
//        [self myDelegate];
//    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list count];
}   


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor grayColor];
    }
    cell.textLabel.text =[list objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];
    [btnSender setTitle:c.textLabel.text forState:UIControlStateNormal];
    [self hideDropDown:btnSender];
}

- (void) myDelegate {
    [self.delegate niDropDownDelegateMethod:self];   
}

-(void)dealloc {
    [table release];
    [super dealloc];
}

@end
