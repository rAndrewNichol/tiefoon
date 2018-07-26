#include "node.h"
#include "trie.h"
#include "inverted_index.h"
#include "file_reader.h"
#include <string>

int main(){
    //Trie t;
    //std::string temp = "bullshit";
    //int _id = 1;
	//std::string to_find = "bullshitter";
    //t.grow(temp, _id);
	//std::vector<int> response = t.find(temp);
	//for(int i = 0; i < response.size(); i++){
	//	std::cout << response[i] << std::endl;	
	//}

	file_reader reader = file_reader();
	std::string content = reader.get_contents_line_by_line("text.txt");
	inverted_index index = inverted_index();
	index.feed(content); // grows index as far as feed. should probably maintain that data and be able to continue adding 
	// as more sources are added. it should probly also store that corpus in entirety, appended onto the last
	// body that was fed into it.
    return 0;
}
