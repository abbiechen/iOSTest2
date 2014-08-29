//
//  DTRootViewController.m
//  DemoTwo
//
//  Created by Abbie on 2014/8/20.
//  Copyright (c) 2014年 LiVEBRiCKS. All rights reserved.
//

#import "DTRootViewController.h"
#import "DTTableViewCell.h"
#define URL @"http://www.indexbricks.com/data/get_update.php?function_code=Profile&store=livebricks&version=0&language=TW"

@interface DTRootViewController ()

@property (strong, nonatomic) NSDictionary *responseDic;
@property (strong, nonatomic) NSArray *responseArray;

@end

@implementation DTRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //以dic從URL接資料，所取得的是第二層每個dic的資料
    self.responseDic = [self getResultsDic:URL];
    self.responseArray = [self.responseDic objectForKey:@"livebricks"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.responseArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"simpleTableViewCell";
    DTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = (DTTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"DTTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    NSDictionary *showDic = [self.responseArray objectAtIndex:indexPath.row];
    cell.tableViewUpLable.text = [showDic objectForKey:@"category_description"];
    cell.tableViewDownLable.text= [NSString stringWithFormat:@"%@ : %@",[showDic objectForKey:@"name_title"],[showDic objectForKey:@"name"]];
    cell.tableViewUpLable.adjustsFontSizeToFitWidth = YES;
    cell.tableViewDownLable.adjustsFontSizeToFitWidth = YES;
    
    NSData *imagedata=[NSData dataWithContentsOfURL:[NSURL URLWithString:[showDic objectForKey:@"category_image_url"]]];
    UIImage *img = [UIImage imageWithData:imagedata];
    cell.tableViewImageView.image = img;
    cell.tableViewImageView.ContentMode = UIViewContentModeScaleAspectFit;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

#pragma mark - setURL

    //選擇並建立最後要回傳的資料形態 (ex:dic)
- (NSDictionary *)getResultsDic:(NSString *)jsonString{
    //對URL提出request，過程中因原URL為一字串，故需要進行轉型（requset<-URL<-string)
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:jsonString]];
    //若回傳過程中有錯誤，則回傳nil
    NSError *err = nil;
    //接著需要取得資料，與URLConnect
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    //因取得的資料無法被掌控，所以需要轉換成能夠使用的資料形態，此轉換為dic
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&err];
    //最後回傳dic
    return jsonDic;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
