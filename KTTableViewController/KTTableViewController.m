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
#import "KTAlert.h"

#define REFRESH_HEADER_HEIGHT   52.0f
#define ERROR_DISPLAY_TIME      5000

@interface KTTableViewController () {

    KiiQuery *_nextQuery;
    NSMutableArray *_results;
        
    BOOL _isLoading;
    BOOL _isDragging;
    
    UIView *_refreshHeader;
}

@end

@implementation KTTableViewController

- (void) setRefreshControlEnabled:(BOOL)refreshControlEnabled
{
    _refreshHeader.hidden = !refreshControlEnabled;
    _refreshControlEnabled = refreshControlEnabled;
}

- (void) refreshQuery
{
    
    if([self respondsToSelector:@selector(tableDidStartLoading)]) {
        [self performSelector:@selector(tableDidStartLoading)];
    }
    
    if(_bucket != nil && _query != nil) {
        
        KiiQuery *localQuery = _query;
        
        // set the limit
        localQuery.limit = _pageSize;
        
        if([_bucket isKindOfClass:[KiiBucket class]]) {

            [_bucket executeQuery:localQuery
                        withBlock:^(KiiQuery *bucketQuery, KiiBucket *bucket, NSArray *results, KiiQuery *nextQuery, NSError *error) {
                            
                            if(error == nil) {
                                
                                _results = [results mutableCopy];
                                
                                [self doneLoading];
                                [self.tableView reloadData];
                                
                                _nextQuery = nextQuery;
                                
                            } else {
                                
                                [self doneLoading];
                                
                                if(_autoHandleErrors) {
                                    [KTAlert showAlert:KTAlertTypeBar
                                           withMessage:@"Unable to load items"
                                           andDuration:KTAlertDurationLong];
                                }
                                
                            }
                            
                            if([self respondsToSelector:@selector(tableDidFinishLoading:)]) {
                                [self performSelector:@selector(tableDidFinishLoading:) withObject:error];
                            }
                            
                        }];

        } else if([_bucket isKindOfClass:[KiiFileBucket class]]) {

            [(KiiFileBucket*)_bucket executeQuery:localQuery
                                        withBlock:^(KiiQuery *query, KiiFileBucket *bucket, NSArray *results, NSError *error) {
                            
                            if(error == nil) {
                                
                                _results = [results mutableCopy];
                                
                                [self doneLoading];
                                [self.tableView reloadData];
                                                                
                            } else {
                                
                                [self doneLoading];
                                
                                if(_autoHandleErrors) {
                                    [KTAlert showAlert:KTAlertTypeBar
                                           withMessage:@"Unable to load items"
                                           andDuration:KTAlertDurationLong];
                                }
                                
                            }
                            
                            if([self respondsToSelector:@selector(tableDidFinishLoading:)]) {
                                [self performSelector:@selector(tableDidFinishLoading:) withObject:error];
                            }
                            
                        }];

        } else {
            // throw exception
            [NSException raise:@"Unable to query bucket -- must be a KiiBucket or KiiFileBucket" format:nil];
        }
        
    } else {
        
        if(_autoHandleErrors) {
            [KTAlert showAlert:KTAlertTypeBar
                   withMessage:@"Unable to load items"
                   andDuration:KTAlertDurationLong];
        }
        
        [self doneLoading];
        
        if([self respondsToSelector:@selector(tableDidFinishLoading:)]) {
            NSError *error = [NSError errorWithDomain:@"com.kii.kiitoolkit" code:101 userInfo:@{NSLocalizedDescriptionKey: @"Either the bucket or the query was undefined"}];
            [self performSelector:@selector(tableDidFinishLoading:) withObject:error];
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

- (void) viewDidLoad {
    
    _autoHandleErrors = TRUE;
    _results = [[NSMutableArray alloc] init];
    
    _paginationEnabled = TRUE;
    _refreshControlEnabled = TRUE;
    
    self.tableView.delegate = self;
    
    // add the refresh header
    _refreshHeader = [[UIView alloc] initWithFrame:CGRectMake(0, -1*REFRESH_HEADER_HEIGHT, self.tableView.frame.size.width, REFRESH_HEADER_HEIGHT)];
    _refreshHeader.backgroundColor = [UIColor clearColor];
    [self.tableView addSubview:_refreshHeader];
    
    _refreshNoticeView = [[UIView alloc] initWithFrame:_refreshHeader.bounds];
    
    _refreshNoticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 0, _refreshHeader.bounds.size.width-44, REFRESH_HEADER_HEIGHT)];
    _refreshNoticeLabel.backgroundColor = [UIColor clearColor];
    _refreshNoticeLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    _refreshNoticeLabel.shadowOffset = CGSizeMake(1.0, 1.0f);
    _refreshNoticeLabel.text = @"Pull to refresh...";
    _refreshNoticeLabel.textAlignment = NSTextAlignmentLeft;
    
    [_refreshNoticeView addSubview:_refreshNoticeLabel];
    [_refreshHeader addSubview:_refreshNoticeView];
    
    CGFloat offset = (REFRESH_HEADER_HEIGHT-36)/2;
    _loadingArrow = [[CKRefreshArrowView alloc] initWithFrame:CGRectMake(roundf(offset), roundf(offset), 36, 36)];
    _loadingArrow.tintColor = [UIColor blackColor];
    _loadingArrow.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [_refreshNoticeView addSubview:_loadingArrow];
    
    _refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _refreshSpinner.center = (CGPoint){
        .x = CGRectGetMidX(_refreshHeader.bounds),
        .y = CGRectGetMidY(_refreshHeader.bounds)
    };
    _refreshSpinner.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                 UIViewAutoresizingFlexibleRightMargin |
                                 UIViewAutoresizingFlexibleTopMargin |
                                 UIViewAutoresizingFlexibleBottomMargin);
    [_refreshHeader addSubview:_refreshSpinner];
    
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
        if (scrollView.contentOffset.y > 0) {
            self.tableView.contentInset = UIEdgeInsetsZero;
        } else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT) {
            self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
    }
    
    if (_isDragging && scrollView.contentOffset.y < 0) {
        
        // Update the progress arrow
        CGFloat progress = fabs(scrollView.contentOffset.y / REFRESH_HEADER_HEIGHT);
        CGFloat deadZone = 0.3;
        if (progress > deadZone) {
            CGFloat arrowProgress = ((progress - deadZone) / (1 - deadZone));
            _loadingArrow.progress = arrowProgress;
        }
        else {
            _loadingArrow.progress = 0.0;
        }
        
        // Update the arrow direction and label
        [UIView animateWithDuration:0.25 animations:^{
            if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
                // User is scrolling above the header
            } else {
                // User is scrolling somewhere within the header
            }
        }];
    }
    
    if (_isDragging && scrollView.contentOffset.y < -1*REFRESH_HEADER_HEIGHT) {
        _refreshNoticeLabel.text = @"Release to refresh...";
    } else if(scrollView.contentOffset.y >= -1*REFRESH_HEADER_HEIGHT) {
        _refreshNoticeLabel.text = @"Pull to refresh...";
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_isLoading) return;
    _isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT && _refreshControlEnabled) {
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
    [_refreshSpinner startAnimating];
    
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
    _loadingArrow.alpha = 1.0f;
    [_refreshSpinner stopAnimating];
}

- (void)refresh {
    
    // tell our delegate to reload the data
    [self refreshQuery];
    
}

- (void) doneLoading {
    [self stopLoading];
}

- (KiiObject*) kiiObjectAtIndex:(NSUInteger)index
{
    return [_results objectAtIndex:index];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
              cellForKiiObject:(id)object
                   atIndexPath:(NSIndexPath*)indexPath
{
    // stubbed, should be overriden by subclass
    return nil;
}


@end

#endif