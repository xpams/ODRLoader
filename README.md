# ODRLoader
On Demand Resources Loader for C++ projects (cocos2d-x, qt, etc)

This framework allow add ODR Resources for iOS and tvOS to your C++ (cocos2d-x, qt, etc) projects.

How to use?

1. Add all files from repository to your project;
2. Include "ODRLoader.h";
3. Inherit ODRLoaderDelegate from class, when you want download On Demand Resources;
4. Add delegate metods.
5. Call ODRLoader::loadWithTags(std::vector<std::string> tags, ODRLoaderDelegate * delegate);

ODRLoaderDelegate class has medods:

```c++
1. virtual void odrLoadingCompleted(std::vector<std::string> tags, int result) = 0;
2. virtual void odrLoadingStatus(std::vector<std::string> tags, float status) = 0;
```

odrLoadingCompleted will be called when On Demand Resources has been downloaded;
std::vector<std::string> tags - ODR Tags.
int result - result.

Result can be:

```c++
#define ODR_ALREADY_DOWNLOADED    0
#define ODR_DOWNLOADED_ERROR      1
#define ODR_DOWNLOADED_SUCCESS    2
```


odrLoadingStatus call every 0.04sec in downloading process and show progress of downloading;
std::vector<std::string> tags - ODR Tags.
float status - downloading status [0..1].

Example: 

```c++
#include <vector>
#include <string>
#include "ODRLoader.h"

class A : public B, ODRLoaderDelegate {
public:
  void odrLoadingCompleted(std::vector<std::string> tags, int result) {
    if (result == ODR_DOWNLOADED_SUCCESS) {
      //TODO       
    } else if (result == ODR_ALREADY_DOWNLOADED) {
      //TODO  
    } else if (result == ODR_DOWNLOADED_ERROR) {
      //TODO
    }
  }
  
  void odrLoadingStatus(std::vector<std::string> tags, float status) {
    //TODO    
  }
  
  A() {
    std::vector<std::string> tags;
    tags.push_back("TagA");
    tags.push_back("TagB");        
    ODRLoader::loadWithTags(tags, this);
  }
}
```

