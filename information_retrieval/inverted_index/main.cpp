#include "node.h"
#include "trie.h"
#include "inverted_index.h"
#include "file_reader.h"
#include <string>

#include <vector>
#include <iostream>

int main(){
	inverted_index index = inverted_index();
	

	//file_reader reader = file_reader();
    //std::string content = reader.get_contents_line_by_line("text.txt");
	//index.feed_from_string(content.c_str()); 


    index.feed_from_file("text.txt");
	std::string to_find = "and";
	std::vector<int> response = index.search(to_find);
	for(int i = 0; i < response.size(); i++){
		std::cout << response[i] << std::endl;	
	}
    return 0;
}
