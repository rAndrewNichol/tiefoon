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
	std::vector<int> response = t.find(temp);
	for(int i = 0; i < response.size(); i++){
		std::cout << response[i] << std::endl;	
	}
    return 0;
}
