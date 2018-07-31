#include <string>
#include <fstream>

#include "trie.h"


#ifndef INVERTED_INDEX

#define INVERTED_INDEX

class inverted_index{
private:
	// note that max size of this string is 4294967291 characters (at least 4gb on ram), so for a proper large
 	// job, partitionining would be necessary. additionally, it might be best to add
	// functionality for this to be incrementally stored on disk.
    //
    //
	std::string full_string;
	Trie trie; // note that the inverted index data structure itself here is "trie"

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
					trie.grow(new_term, doc_id);	
					new_term = "";
					break;
				case 33:
				case 46:
				case 63:
					// this is a sentence separation character. index the new term. reset the term, increment the doc_id.
					trie.grow(new_term, doc_id);
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
            // this is the same "algorithm" as in feed_from_string(), it was copied rather 
            // than generically factored for simplicity and efficiency
 			switch (curr_char){
				case 9 :
				case 10:
				case 11:
				case 12:
				case 13:
				case 32:
					trie.grow(new_term, doc_id);	
					new_term = "";
					break;
				case 33:
				case 46:
				case 63:
					trie.grow(new_term, doc_id);
					new_term  = "";
					doc_id++;
					break;
				default:
					new_term += curr_char;
            }
        }
        infile.close();
    }

	Node* search(std::string to_find){
        return trie.retrieve(to_find);
	}

    std::vector<int> single_query(std::string to_find){
         Node* found = search(to_find);    
         if(found){
            return (*found).doc_ids;
         }
         else{
             std::vector<int> empty;
             return empty;
         }
    }

    std::vector<int> intersect_postings(std::vector<int>* p1, std::vector<int>* p2){
        // note that posting lists should be in ascending order by doc_id
        std::vector<int> result;
        int i = 0; int j = 0;
        int length_1 = (*p1).size(); int length_2 = (*p2).size();
        while(i < length_1 && j < length_2){
            if((*p1)[i] == (*p2)[j]){
                result.push_back((*p1)[i]);
                i++;j++; 
            }else if((*p1)[i] < (*p2)[j]){
                i++;
            }else{
                j++;
            }
        }
        return result;
    }

  std::vector<int> intersect_terms(std::vector<std::string> terms){
      // input ::: vector of strings which each represent a term to be intersected
      
      // for each term: 
      //    search for the term. put it into the capture vector (behind the index which it surpasses in frequency). 
      // create a new vector from that vector that is each of the nodes' postings. this is the return
      std::vector<Node> capture;
      int num_terms = terms.size();
      for(int i = 0; i < num_terms; i++){
        Node* found = search(terms[i]);
        if(found){
            int j = 0; int length = capture.size();  
            while(j < length){
                if((*found).frequency > capture[j].frequency){
                    break;
                }
                j++;
            } 
            capture.insert(capture.begin() + j, *found);
        }
      }
      // now convert to vector of postings
      std::vector< std::vector<int> > postings;
      int num_found = capture.size();
      for(int i = 0; i < num_found; i++){
        postings.push_back(capture[i].doc_ids);
      }

      for(int i = 0; i < postings.size(); i++){
        for(int j = 0; j < postings[i].size(); j++){
            std::cout << postings[i][j] << ", ";
        } 
        std::cout << std::endl;
      }
      //return intersect_multi_postings(postings, pre_sorted = true);
      return postings[0];
  }

  //std::vector<int> intersect_multi_postings(std::vector< std::vector<int> > postings, bool pre_sorted = false){
  //    // algorithm from stanfrod IR book
  //}

};

#endif
