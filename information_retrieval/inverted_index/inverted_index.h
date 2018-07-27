#include <string>
#include "trie.h"
#include "file_reader.h"

#ifndef INVERTED_INDEX

#define INVERTED_INDEX

class inverted_index{

	// note that max size of this string is 4294967291 characters, so for a proper large
 	// job, partitionining would be necessary. additionally, it might be best to add
	// functionality for this to be incrementally stored on disk
	std::string full_string;
	Trie index;

public:
	inverted_index(){
	}

	void feed(const char* curr_char){	
		int doc_id = 0;
		std::string new_term = "";
		do{
			// whitespace characters: 9-13, 32
			// sentence separation characters:33, 46, 63
			// other punctuation: 34-45, 47, 58-62, 64, 91-96, 123-126
			// standard alpha (upper): 65-90, (lower): 97-122
				
			//store index when starting a new term
			//increment index until end of term. when encounter a whitespace or new
			//sentence character, index that term into the document.
			//if that stop character was a new sentence character, increment the 
			//document id.
			switch (*curr_char){
				case 9 :
				case 10:
				case 11:
				case 12:
				case 13:
				case 32:
					// this is a space. index the new term, reset the term.
					index.grow(new_term, doc_id);	
					new_term = "";
					break;
				case 33:
				case 46:
				case 63:
					// this is a sentence separation character. index the new term. reset the term, increment the doc_id.
					index.grow(new_term, doc_id);
					new_term  = "";
					doc_id++;
					break;
				default:
					//otherwise: add this char to the new term.
					new_term += *curr_char;
			}
			curr_char++;
		}while(*curr_char); 
	}

	std::vector<int> search(std::string to_find){
		return index.find(to_find);
	}


};

#endif
