#include "node.h"
#include "trie.h"
#include <string>

#include <iostream> //delete this

int main(){
    Trie t;
    std::string temp = "bullshit";
	//temp = temp.substr(1,std::string::npos);
	//std::cout << temp << std::endl;
    int _id = 1;
    t.grow(temp, _id);
    return 0;
}
