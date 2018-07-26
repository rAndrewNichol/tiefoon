#include "node.h"
#include "trie.h"
#include <string>
#include "inverted_index.h"


int main(){
    Trie t;
    std::string temp = "bullshit";
    int _id = 1;
	std::string to_find = "bullshitter";
    t.grow(temp, _id);
	std::vector<int> response = t.find(temp);
	for(int i = 0; i < response.size(); i++){
		std::cout << response[i] << std::endl;	
	}

	
    return 0;
}
