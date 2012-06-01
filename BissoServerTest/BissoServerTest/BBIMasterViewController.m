//
//  BBIMasterViewController.m
//  BissoServiceTest
//
//  Created by Sim iPad on 01.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBIMasterViewController.h"
#import "BBIDetailViewController.h"
#import "BBIAccountEditorViewController.h"

@interface BBIMasterViewController () {
    NSMutableArray *services;
    NSURL *servicesURL;
    NSIndexPath *currentIndexPath;
}
@end


@implementation BBIMasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize accountEditorPopup = _accountEditorPopup;

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
 //   self.navigationItem.rightBarButtonItem = addButton;
 //  self.accountEditorPopup = [[BBIAccountEditorViewController alloc] init];
 //   self.accountEditorPopup popoverControllerShouldDismissPop
    
    self.detailViewController = (BBIDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

    if (!servicesURL)
    {
        NSFileManager *fm = [NSFileManager defaultManager];
        servicesURL = [[fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject  ];
        servicesURL = [servicesURL URLByAppendingPathComponent:@"services"];
    }
    
    services = [NSMutableArray arrayWithContentsOfURL:servicesURL];
        
    if (!services) {
        services = [[NSMutableArray alloc] init];
    }    
        
 }

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) handleAccountEditorPopup
{
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)clearSelection:(id)sender
{
    NSLog(@"clearSelection");
    
    UITableView * tv = (UITableView *)[self view];
    NSIndexPath *ip = [tv indexPathForSelectedRow];
    [tv deselectRowAtIndexPath:ip animated:YES];
}

- (IBAction)doSomething:(id)sender {
    NSLog(@"doSomething");

}

- (IBAction)addService:(NSMutableDictionary *) obj sender:(id)sender
{
    if (!services) {
        services = [[NSMutableArray alloc] init];
    }
    
    [services insertObject:obj atIndex:0];
        
    [services writeToURL:servicesURL atomically:YES];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
//    bissoAuth = [[BBIBissoAuthenticator alloc] init];
//    [bissoAuth loadData];

}

- (NSDictionary *) serviceForName: (NSString *)serviceName
{
    NSEnumerator *enumerator = [services objectEnumerator];
    NSDictionary * service;
    
    while (service = [enumerator nextObject]) {
        if ([[service valueForKey:@"service"] isEqualToString:serviceName]) return service;
    }
    return nil;
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return services.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    NSDictionary *object = [services objectAtIndex:indexPath.row];
    cell.textLabel.text = [object  valueForKey:@"service"];
    return cell;
}

- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    currentIndexPath = indexPath;
    // Edit the account
     [self performSegueWithIdentifier:@"showAccountEditor" sender:self];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [services removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
    
    [services writeToURL:servicesURL atomically:YES];

}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *object = [services objectAtIndex:indexPath.row];
    if (!self.detailViewController.masterPopoverController)  
        self.detailViewController.masterPopoverController = self;
    self.detailViewController.detailItem = object;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSMutableDictionary *object = [services objectAtIndex:indexPath.row];
        [[segue destinationViewController] setMasterPopoverController:self];
        [[segue destinationViewController] setDetailItem:object];
    }
    else if ([[segue identifier] isEqualToString:@"showAccountEditor"]) 
    {
        self.accountEditorPopup = [segue destinationViewController];
        self.accountEditorPopup.masterPopoverController = self;
        NSLog(@"Segue found ");
        
        if (currentIndexPath)
            [self.accountEditorPopup setObject:[services objectAtIndex:currentIndexPath.row]];
        else 
            [self.accountEditorPopup setObject:nil];

    }

}




@end
