#include <string>
#include "trie.h"
#include "file_reader.h"

#ifndef INVERTED_INDEX

#define INVERTED_INDEX

class inverted_index{

public:
	inverted_index(){
	}

	void feed(std::string content_string){	
		int curr_char;
		int i = 0;
		do{
			curr_char = content_string[i];
			// whitespace characters: 9-13, 32
			// sentence separation characters:33, 46, 63
			// other punctuation: 34-45, 47, 58-62, 64, 91-96, 123-126
			// standard alpha (upper): 65-90, (lower): 97-122
			
			//store index when starting a new term
			//increment index until end of term. when encounter a whitespace or new
			//sentence character, index that term into the document.
			//if that stop character was a new sentence character, incremeent the 
			//document id.
			i++;
		}while(curr_char); 
	}


};

#endif
