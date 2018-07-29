#include <string>
#include <fstream>

#include "trie.h"


#ifndef INVERTED_INDEX

#define INVERTED_INDEX

class inverted_index{

	// note that max size of this string is 4294967291 characters (at least 4gb on ram), so for a proper large
 	// job, partitionining would be necessary. additionally, it might be best to add
	// functionality for this to be incrementally stored on disk.
    //
    //
	std::string full_string;
	Trie index;

public:
	inverted_index(){
	}

	void feed_from_string(const char* curr_char){	
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
        
    void feed_from_file(const char *file_name){
        std::ifstream infile;
        infile.open(file_name);

		std::string new_term = "";
    	int doc_id = 0;
        char curr_char;
        while(infile.get(curr_char)){
            // this is the same "algorithm" as in feed_from_string(), it was copied rather than generically factored
            // for simplicity and efficiency
 			switch (curr_char){
				case 9 :
				case 10:
				case 11:
				case 12:
				case 13:
				case 32:
					index.grow(new_term, doc_id);	
					new_term = "";
					break;
				case 33:
				case 46:
				case 63:
					index.grow(new_term, doc_id);
					new_term  = "";
					doc_id++;
					break;
				default:
					new_term += curr_char;
            }
        }
        infile.close();
    }

	std::vector<int> search(std::string to_find){
		return index.find(to_find);
	}


};

#endif
