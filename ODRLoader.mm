//
//  ODRLoader.mm
//  CLAYAnimals
//
//  Created by Nikolay Khramchenko on 8/30/16.
//
//

#import "ODRLoader.h"
#import "cocos2d.h"


void * ODRLoader::loadWithTag(std::vector<std::string> tags) {
    NSMutableSet * sTags = [[NSMutableSet alloc] init];
    
    for (auto tag : tags) {
        [sTags addObject:[NSString stringWithCString:(tag).c_str() encoding:[NSString defaultCStringEncoding]]];
    }
    
    auto request = [[NSBundleResourceRequest alloc] initWithTags:sTags];

    [request conditionallyBeginAccessingResourcesWithCompletionHandler:^
     (BOOL resourcesAvailable) {
         if (resourcesAvailable) {
             std::vector<std::string> tags;
             for (NSString * tag : [request tags]) {
                 tags.push_back(std::string([tag UTF8String]));
             }
             
             ODRNotificationBody * odrNotificationBody = new ODRNotificationBody(true, tags);
             
             cocos2d::EventCustom event(ODR_NOTIFICATION);
             event.setUserData(odrNotificationBody);
             cocos2d::Director::getInstance()->getEventDispatcher()->dispatchEvent(&event);
             
         } else {
             [request beginAccessingResourcesWithCompletionHandler:^
              (NSError * _Nullable error) {
                  if (error == nil) {
                      std::vector<std::string> tags;
                      for (NSString * tag : [request tags]) {
                          tags.push_back(std::string([tag UTF8String]));
                      }
                      
                      ODRNotificationBody * odrNotificationBody = new ODRNotificationBody(false, tags);
                      
                      cocos2d::EventCustom event(ODR_NOTIFICATION);
                      event.setUserData(odrNotificationBody);
                      cocos2d::Director::getInstance()->getEventDispatcher()->dispatchEvent(&event);
                  } else {
                      std::vector<std::string> tags;
                      for (NSString * tag : [request tags]) {
                          tags.push_back(std::string([tag UTF8String]));
                      }
                      
                      ODRNotificationBody * odrNotificationBody = new ODRNotificationBody(true, tags);
                      
                      cocos2d::EventCustom event(ODR_NOTIFICATION);
                      event.setUserData(odrNotificationBody);
                      cocos2d::Director::getInstance()->getEventDispatcher()->dispatchEvent(&event);
                  }
              }];
         }
     }];
    
    return request;
    
}

int ODRLoader::getPercent(void * request) {
    NSBundleResourceRequest * r = (NSBundleResourceRequest *)request;
    return [r progress].fractionCompleted * 100;
}