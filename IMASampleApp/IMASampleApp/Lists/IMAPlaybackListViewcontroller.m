/**
 * @class      IMAPlaybackListViewcontroller IMAPlaybackListViewcontroller.m
 "IMAPlaybackListViewcontroller.m"
 * @brief      A list of playback examples that demonstrate IMA Ad playback
 * @date       12/12/14
 * @copyright  Copyright (c) 2014 Ooyala, Inc. All rights reserved.
 */

#import "IMAPlaybackListViewcontroller.h"
#import "IMAPlayerViewController.h"
#import "PlayerSelectionOption.h"

@interface IMAPlaybackListViewcontroller ()
@property NSMutableArray *options;
@end

@implementation IMAPlaybackListViewcontroller

- (id)init {
  self = [super init];
  self.title = @"IMA Playback";
  return self;
}

- (void)addAllPlayerSelectionOptions {
  [self insertNewObject: [[PlayerSelectionOption alloc] initWithTitle:@"test" embedCode:@"F4MDFidTrZjUQMElbCDUbjxwWcoWveue" viewController: [IMAPlayerViewController class]]];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.navigationController.navigationBar.translucent = NO;
  [self.tableView registerNib:[UINib nibWithNibName:@"TableCell" bundle:nil]forCellReuseIdentifier:@"TableCell"];

  [self addAllPlayerSelectionOptions];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(forceBack:)
                                               name:@"forceBack"
                                             object:nil];

  [self performSelector:@selector(loadIt) withObject:nil afterDelay:0.1];
}

-(void) viewWillAppear:(BOOL)animated {
  NSLog( @"LIIIIIIST!!!!!!" );
}

-(void) forceBack:(NSNotification*) notification {
  [self.navigationController popViewControllerAnimated:YES];
}

-(void) loadIt {
  [self tableView:self.tableView didSelectRowAtIndexPath:0];
}

- (void)insertNewObject:(PlayerSelectionOption *)selectionObject {
  if (!self.options) {
      self.options = [[NSMutableArray alloc] init];
  }
  [self.options insertObject:selectionObject atIndex:0];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];

  PlayerSelectionOption *selection = self.options[indexPath.row];
  cell.textLabel.text = [selection title];
  return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // When a row is selected, load its desired PlayerViewController
  PlayerSelectionOption *selection = self.options[indexPath.row];
  SampleAppPlayerViewController *controller = [(SampleAppPlayerViewController *)[[selection viewController] alloc] initWithPlayerSelectionOption:selection];
  [self.navigationController pushViewController:controller animated:YES];
}

@end
