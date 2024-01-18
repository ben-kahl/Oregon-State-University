#include <iostream>
#include <sstream>
#include <fstream>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <stdlib.h>

int main(){
    std::fstream prngService;
    std::string buffer;
    srand(time(0));
    int ranNum;
    while (true){
        sleep(1);
        prngService.open("prng-service.txt", std::ios::in);
       
        if (prngService.is_open()){
            prngService >> buffer;
            if (strncmp(buffer.c_str(), "run", 3) == 0){
                prngService.close();
                prngService.open("prng-service.txt", std::ios::out);
                ranNum = rand();
                prngService << std::to_string(ranNum);
            }
            
        }
        prngService.close();
    }
    
}