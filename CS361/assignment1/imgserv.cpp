#include <iostream>
#include <fstream>
#include <vector>
#include <unistd.h>

bool checkBuf(std::string buffer){
    for (int i = 0; i < buffer.length(); i++){
        if (!isdigit(buffer[i])){
            return false;
        }
    }
    return true;
    
}

void initDB(std::vector<std::string>* imgDB){
    imgDB->at(0) = "imgdb/img1.jpg";
    imgDB->at(1) = "imgdb/img2.jpg";
    imgDB->at(2) = "imgdb/img3.jpg";
    imgDB->at(3) = "imgdb/img4.jpg";
    imgDB->at(4) = "imgdb/img5.jpg";
    imgDB->at(5) = "imgdb/img6.jpg";
    imgDB->at(6) = "imgdb/img7.jpg";
    imgDB->at(7) = "imgdb/img8.jpg";
    imgDB->at(8) = "imgdb/img9.jpg";
    imgDB->at(9) = "imgdb/img10.jpg";
}

int main(){
    std::fstream imgService;
    std::string buffer;
    std::vector<std::string> imgDB;
    imgDB.resize(10);
    initDB(&imgDB);
    int ranNum;
    while(true){
        sleep(1);
        imgService.open("image-service.txt", std::ios::in);
        if (imgService.is_open()){
            imgService >> buffer;
            if (checkBuf(buffer)){
                ranNum = atoi(buffer.c_str());
                ranNum %= 10;
                imgService.close();
                imgService.open("image-service.txt", std::ios::out | std::ios::trunc);
                imgService << imgDB[ranNum];
            }
            
        }
        imgService.close();
    }
}