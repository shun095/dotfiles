#include <unistd.h>
#include <cstdlib>
#include <iostream>
#include <sstream>

char* getmodulefilename() {
    static char buf[1024] = {};
    /*
        char path[256];
        sprintf( path, "/proc/%d/exe", getpid() );
        readlink( path, buf, sizeof(buf)-1 );
    */
    readlink("/proc/self/exe", buf, sizeof(buf) - 1);
    return buf;
}

int main(int argc, char* argv[]) {
    bool              result      = false;
    int               return_code = -1;
    std::stringstream ss;
    ss << "gnome-terminal -e "
       << "./test";

    return_code = system(ss.str().c_str());
    std::cout << "return_code_before" << return_code << std::endl;
    return_code = WEXITSTATUS(return_code);  // ①
    std::cout << "return_code_after" << return_code << std::endl;

    if (return_code == 0) {
        // shell実行成功
        result = true;
    } else {
        // shell実行失敗
        result = false;
    }

    return result;
}
