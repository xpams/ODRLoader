//
//  ODRLoader.h
//  CLAYAnimals
//
//  Created by Nikolay Khramchenko on 8/30/16.
//
//

#ifndef ODRLoader_h
#define ODRLoader_h

#define ODR_ALREADY_DOWNLOADED    0
#define ODR_DOWNLOADED_ERROR      1
#define ODR_DOWNLOADED_SUCCESS    2

#include <string>
#include <vector>

class ODRLoaderDelegate {
public:
    virtual void odrLoadingCompleted(std::vector<std::string> tags, int result) = 0;
    virtual void odrLoadingStatus(std::vector<std::string> tags, float status) = 0;
};

class ODRLoader {
private:
    static void odrLoadingCompleted(void * request, int result, ODRLoaderDelegate * delegate);
public:
    static void loadWithTags(std::vector<std::string> tags, ODRLoaderDelegate * delegate);
};

#endif /* ODRLoader_h */
