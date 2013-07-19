//
//
// Copyright 2013 Kii Corporation
// http://kii.com
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
//

#import "KTTableViewController.h"

#if __has_include(<KiiSDK/Kii.h>)

#import <KiiSDK/Kii.h>

#define REFRESH_HEADER_HEIGHT   52.0f
#define ERROR_DISPLAY_TIME      5000

@interface KTTableViewController () {
    KiiQuery *_query;
    KiiQuery *_nextQuery;
    KiiBucket *_bucket;
    NSMutableArray *_results;
    
    int _pageSize;
    BOOL _paginationEnabled;
    BOOL _refreshControlEnabled;
    BOOL _autoHandleErrors;
    
    BOOL _isLoading;
    BOOL _isDragging;
    
    UIView *_refreshHeader;
    UIActivityIndicatorView *_spinner;

    UIView *_refreshNoticeView;
    UIView *_errorHeader;
    UILabel *_errorLabel;
}

@end

@implementation KTTableViewController

@synthesize query = _query;
@synthesize bucket = _bucket;

@synthesize pageSize = _pageSize;
@synthesize paginationEnabled = _paginationEnabled;
@synthesize refreshControlEnabled = _refreshControlEnabled;
@synthesize refreshNoticeView = _refreshNoticeView;

- (void) showError:(NSString*)message
{
    _errorLabel.text = message;
    [UIView animateWithDuration:1.0f
                     animations:^{
                         _errorHeader.alpha = 1.0f;
                     }];
}

- (void) refreshQuery
{
    
    if(_bucket != nil && _query != nil) {
                
        // set the limit
        _query.limit = _pageSize;
        
        [_bucket executeQuery:_query
                    withBlock:^(KiiQuery *bucketQuery, KiiBucket *bucket, NSArray *results, KiiQuery *nextQuery, NSError *error) {
                                                
                        if(error == nil) {
                            
                            _results = [results mutableCopy];

                            [self doneLoading];
                            [self.tableView reloadData];
                            
                            _nextQuery = nextQuery;
                            
                        } else {
                            
                            if(_autoHandleErrors) {
                                
                                // show our error view
                                [self showError:@"Unable to load items"];
                                
                                // hide the error after a timeout
                                [self performSelector:@selector(doneLoading) withObject:nil afterDelay:ERROR_DISPLAY_TIME];
                                
                            } else {
                                [self doneLoading];
                            }
                        }
                        
                    }];
    } else {
        // make note of the error
        // TODO: send error callback to delegate
        
        if(_autoHandleErrors) {

            // show our error view
            [self showError:@"Unable to load items"];
            
            // hide the error after a timeout
            [self performSelector:@selector(doneLoading) withObject:nil afterDelay:ERROR_DISPLAY_TIME];
            
        } else {
            [self doneLoading];
        }
    }

}

- (void) atBottomOfPage
{
    if(_paginationEnabled && _nextQuery != nil && !_isLoading) {
        
        // add a loading cell at the bottom
        _isLoading = TRUE;
        [self.tableView reloadData];
        
        // set the limit
        _nextQuery.limit = _pageSize;
        
        [_bucket executeQuery:_nextQuery
                    withBlock:^(KiiQuery *query, KiiBucket *bucket, NSArray *results, KiiQuery *nextQuery, NSError *error) {
                        
                        if(error == nil) {
                            _results = [[_results arrayByAddingObjectsFromArray:results] mutableCopy];
                            _nextQuery = nextQuery;
                        }
                                                
                        [self doneLoading];
                        [self.tableView reloadData];
                        
                    }];

    }
}

- (id) initWithStyle:(UITableViewStyle)style
        andKiiBucket:(KiiBucket*)bucket
            andQuery:(KiiQuery*)query
{
    self = [super initWithStyle:style];
    
    if(self) {
        _bucket = bucket;
        _query = query;
    }
    
    return self;
}

- (void) viewDidLoad {
    
    _autoHandleErrors = TRUE;
    _results = [[NSMutableArray alloc] init];
    
    self.paginationEnabled = TRUE;
    self.refreshControlEnabled = TRUE;
    
    self.tableView.delegate = self;
    
    // add the refresh header
    _refreshHeader = [[UIView alloc] initWithFrame:CGRectMake(0, -1*REFRESH_HEADER_HEIGHT, self.tableView.frame.size.width, REFRESH_HEADER_HEIGHT)];
    _refreshHeader.backgroundColor = [UIColor clearColor];
    [self.tableView addSubview:_refreshHeader];
    
    _refreshNoticeView = [[UIView alloc] initWithFrame:_refreshHeader.bounds];
    UILabel *refreshLabel = [[UILabel alloc] initWithFrame:_refreshNoticeView.bounds];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.text = @"Pull to refresh...";
    refreshLabel.textAlignment = NSTextAlignmentCenter;
    
    [_refreshNoticeView addSubview:refreshLabel];
    [_refreshHeader addSubview:_refreshNoticeView];
    
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _spinner.center = (CGPoint){
        .x = CGRectGetMidX(_refreshHeader.bounds),
        .y = CGRectGetMidY(_refreshHeader.bounds)
    };
//    _spinner.color = [UIColor redColor];
    _spinner.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                 UIViewAutoresizingFlexibleRightMargin |
                                 UIViewAutoresizingFlexibleTopMargin |
                                 UIViewAutoresizingFlexibleBottomMargin);
    [_refreshHeader addSubview:_spinner];

    _errorHeader = [[UIView alloc] initWithFrame:_refreshHeader.bounds];
    _errorHeader.alpha = 0.f;
    _errorHeader.backgroundColor = [UIColor redColor];
    
    _errorLabel = [[UILabel alloc] initWithFrame:_errorHeader.bounds];
    _errorLabel.textColor = [UIColor whiteColor];
    _errorLabel.backgroundColor = [UIColor clearColor];
    _errorLabel.text = @"Error Loading!";
    _errorLabel.textAlignment = NSTextAlignmentCenter;
    [_errorHeader addSubview:_errorLabel];
    
    [_refreshHeader addSubview:_errorHeader];
    
    [self refreshQuery];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _results.count + (_isLoading?1:0);
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if(_isLoading && indexPath.row >= _results.count) {
        
        // create a loading cell
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LoadingCell"];

        UIActivityIndicatorView *av = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        av.center = cell.contentView.center;
        [cell.contentView addSubview:av];
        [av startAnimating];
        
    }
    
    // Should be overriden by subclass
    else if([self respondsToSelector:@selector(tableView:cellForKiiObject:atIndexPath:)]) {
        cell = [self tableView:tableView
                   cellForKiiObject:[_results objectAtIndex:indexPath.row]
                        atIndexPath:indexPath];
    }
    
    return cell;
}

#pragma mark - Pull to refresh

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_isLoading) return;
    _isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height) {
        [self atBottomOfPage];
    }

    else if (_isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.tableView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (_isDragging && scrollView.contentOffset.y < 0) {
        
        /*
        // Update the progress arrow
        CGFloat progress = fabs(scrollView.contentOffset.y / REFRESH_HEADER_HEIGHT);
        CGFloat deadZone = 0.3;
        if (progress > deadZone) {
            CGFloat arrowProgress = ((progress - deadZone) / (1 - deadZone));
            arrow.progress = arrowProgress;
        }
        else {
            arrow.progress = 0.0;
        }
        
        // Update the arrow direction and label
        [UIView animateWithDuration:0.25 animations:^{
            if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
                // User is scrolling above the header
            } else {
                // User is scrolling somewhere within the header
            }
        }];
         */
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_isLoading) return;
    _isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
}

- (void)startLoading {
    _isLoading = YES;
    
    // Show the header
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    }];
    
    //    [self setContentOffset:CGPointMake(0, -1*REFRESH_HEADER_HEIGHT) animated:TRUE];
    
    // hide the arrow and show the spinner
//    arrow.alpha = 0.0f;
    [_spinner startAnimating];
    
    _refreshNoticeView.hidden = TRUE;
    
    // Refresh action!
    [self refresh];
}

- (void)stopLoading {
    _isLoading = NO;
    
    // Hide the header
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.tableView.contentInset = UIEdgeInsetsZero;
                     }
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(stopLoadingComplete)];
                         _refreshNoticeView.hidden = FALSE;
                     }];
}

- (void)stopLoadingComplete {
    // Reset the header
//    arrow.alpha = 1.0f;
    [_spinner stopAnimating];
    _errorHeader.alpha = 0.f;
}

- (void)refresh {
    
    // tell our delegate to reload the data
    [self refreshQuery];
    
}

- (void) doneLoading {
    [self stopLoading];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
              cellForKiiObject:(KiiObject*)object
                   atIndexPath:(NSIndexPath*)indexPath
{
    // stubbed, should be overriden by subclass
    return nil;
}


@end

#endif