//
//  ODRLoader.mm
//  CLAYAnimals
//
//  Created by Nikolay Khramchenko on 8/30/16.
//
//

#import "ODRLoader.h"

#import <iostream>

#import "NSTimer+Blocks.h"


void ODRLoader::loadWithTags(std::vector<std::string> tags, ODRLoaderDelegate * delegate) {
    NSMutableSet * sTags = [[NSMutableSet alloc] init];
    
    for (auto tag : tags) {
        [sTags addObject:[NSString stringWithCString:(tag).c_str() encoding:[NSString defaultCStringEncoding]]];
    }
    
    auto request = [[NSBundleResourceRequest alloc] initWithTags:sTags];
    
    [request conditionallyBeginAccessingResourcesWithCompletionHandler:^
     (BOOL resourcesAvailable) {
         if (resourcesAvailable) {
             ODRLoader::odrLoadingCompleted(request, ODR_ALREADY_DOWNLOADED, delegate);
         } else {
             dispatch_async(dispatch_get_main_queue(), ^{
                 NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:0.04 block:^{
                     if (delegate != nullptr) {
                         delegate->odrLoadingStatus(tags, [request progress].fractionCompleted);
                     }
                     
                 } repeats:YES];
                 
                 
                 [request beginAccessingResourcesWithCompletionHandler:^
                  (NSError * _Nullable error) {
                      if (error == nil) {
                          ODRLoader::odrLoadingCompleted(request, ODR_DOWNLOADED_SUCCESS, delegate);
                          [timer invalidate];
                      } else {
                          NSLog(@"%@", error);
                          ODRLoader::odrLoadingCompleted(request, ODR_DOWNLOADED_ERROR, delegate);
                          [timer invalidate];
                      }
                  }];
             });
         }
     }];
    
}



void ODRLoader::odrLoadingCompleted(void * request, int result, ODRLoaderDelegate * delegate) {
    if (delegate != nullptr) {
        NSBundleResourceRequest * r = (NSBundleResourceRequest *)request;
        std::vector<std::string> tags;
        for (NSString * tag : [r tags]) {
            tags.push_back(std::string([tag UTF8String]));
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            delegate->odrLoadingCompleted(tags, result);
        });
        
    }
    
}
