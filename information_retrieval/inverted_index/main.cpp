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
	//std::string to_find = "and";
	//std::vector<int> response = index.single_query(to_find);
    std::vector<std::string> to_find;
    to_find.push_back("love");to_find.push_back("derive");
	//std::vector<int> response = index.intersect_terms(to_find);
	std::vector<int> response = index.intersect_terms(to_find);
    
    //int v1[5] = {1,2,3,5,7};
    //int v2[3] = {3,6,7};
    //std::vector<int> post1 (&v1[0], &v1[0]+5);
    //std::vector<int> post2 (&v2[0], &v2[0]+3);
    //std::vector<int> response = index.intersect_postings(&post1, &post2);

    for(int i = 0; i < response.size(); i++){
    	std::cout << response[i] << std::endl;	
	}

    //Node newNode = Node();
    //if(newNode.empty()){
    //    std::cout << "REACHED" << std::endl;
    //}

    return 0;
}
