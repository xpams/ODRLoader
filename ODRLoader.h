//
//  ODRLoader.h
//  CLAYAnimals
//
//  Created by Nikolay Khramchenko on 8/30/16.
//
//

#ifndef ODRLoader_h
#define ODRLoader_h

#define ODR_NOTIFICATION "ODR_NOTIFICATION"

#include <string>
#include <vector>

struct ODRNotificationBody {
    ODRNotificationBody(bool ok, std::vector<std::string> tags) {
        this->ok = ok;
        this->tags = tags;
    }
    
    bool ok;
    std::vector<std::string> tags;
    
};

class ODRLoader  {
public:
    static void * loadWithTag(std::vector<std::string> tags);
    static int getPercent(void * request);

};

#endif /* ODRLoader_h */
