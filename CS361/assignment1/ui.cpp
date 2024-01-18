#include <iostream>
#include <fstream>
#include <string>
#include <unistd.h>

void displayIMG(){
    std::fstream file;
    std::string buffer;
    std::string command = "xdg-open ";
    file.open("prng-service.txt", std::ios::out | std::ios::trunc);
    file << "run";
    file.close();
    sleep(5);
    file.open("prng-service.txt", std::ios::in);
    file >> buffer;
    file.close();

    file.open("image-service.txt", std::ios::out | std::ios::trunc);
    file << buffer;
    file.close();
    sleep(5);
    file.open("image-service.txt", std::ios::in);
    file >> buffer;
    command.append(buffer);
    system(command.c_str());

}

int main(){
    int userIn = 0;
    while (userIn != 2){
        std::cout << "Please input 1 to generate a new image or 2 to exit" << std::endl;
        std::cin >> userIn;
        switch (userIn){
        case 1:
            displayIMG();
            break;
        case 2: 
            break;
        default:
            std::cout << "Please input a valid number." << std::endl;
            break;
        }
    }
    
}