#include <iostream>
#include <string>

int main()
{
    std::string y;
    int x = 0;

    std::cout << "START VIRUS SCAN?" << std::endl;
    std::cin >> y;

    if (y == "N") {
        return 0;
    }

    std::cout << "STARTING VIRUS SCAN..." << std::endl;
    
    while (x <= 500) {
        x++;
    }

    std::cout << "YOU HAVE A VIRUS!!!!!!" << std::endl;
    std::cout << "VIRUSES FOUND:" << std::endl;
    std::cout << " A 004 VIRUS" << std::endl;

    std::string c;
    std::cout << "INPUT CREDIT CARD NUMBER:";
    std::cin >> c;

    std::string m;
    std::cout << "INPUT EXPIRATION DATE MONTH:";
    std::cin >> m;

    if (m.length() != 2) {
        std::cout << "EXPIRATION MONTH INCORRECT" << std::endl;
        return 0;
    }

    std::string d;
    std::cout << "INPUT EXPIRATION DATE DAY:";
    std::cin >> d;

    if (d.length() != 2) {
        std::cout << "EXPIRATION DAY INCORRECT" << std::endl;
        return 0;
    }

    std::cout << "PAYMENT OF $3000 SUCCESSFUL" << std::endl;
    std::cout << "ATTEMPTING TO REMOVE VIRUSES..." << std::endl;

    x = 0;
    while (x <= 1000) {
        x++;
    }

    std::cout << "COULD NOT REMOVE VIRUSES" << std::endl;
    std::cout << "PLEASE TRY AGAIN LATER" << std::endl;
    return 0;
}
