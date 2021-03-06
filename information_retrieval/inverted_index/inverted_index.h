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

    void process_char(char c, int &doc_id, std::string &new_term){
       // whitespace characters: 9-13, 32
       // sentence separation characters:33, 46, 63
       // other punctuation: 34-45, 47, 58-62, 64, 91-96, 123-126
       // standard alpha (upper): 65-90, (lower): 97-122
       	
       //store index when starting a new term
       //increment index until end of term. when encounter a whitespace or new
       //sentence character, index that term into the document.
       //if that stop character was a new sentence character, increment the 
       //document id.
       
       switch (c){ 
           case 9 ... 13: case 32:
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
           case 65 ... 90:
               // this is an upper-case character. convert to lowercase and add it to the term
               new_term += c + 32;
               break;
       	case 97 ... 122:
           case 45:
               // this is a lower-case character or a hyphen. add it to the term
       		new_term += c;
               break;
           default:
               // otherwise, skip this character
               break;
        }   
    }

	void feed_from_string(const char* curr_char){	
		int doc_id = 0;
		std::string new_term = "";
		do{
            process_char(*curr_char, doc_id, new_term);
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
            process_char(curr_char, doc_id, new_term);
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
      std::vector<Node*> capture;
      int num_terms = terms.size();
      for(int i = 0; i < num_terms; i++){
        Node* found = search(terms[i]);
        if(found){
            int j = 0; int length = capture.size();  
            while(j < length){
                if((*found).frequency > (*capture[j]).frequency){
                    break;
                }
                j++;
            } 
            capture.insert(capture.begin() + j, found);
        }
        else{
          capture.insert(capture.begin(), new Node);
        }
      }
      // now convert to vector of postings
      std::vector< std::vector<int>* > postings;
      int num_found = capture.size();
      for(int i = 0; i < num_found; i++){
        postings.push_back(&((*capture[i]).doc_ids));
      }

      // PRINTS FOR TESTING
      //for(int i = 0; i < postings.size(); i++){
      //  std::cout << "YES" << std::endl;
      //  for(int j=0;j < postings[i] -> size(); j++){
      //    std::cout << (*postings[i])[j];
      //  }
      //  std::cout << std::endl;
      //}

      // note that postings are already sorted in ascending order of frequency here. 
      return intersect_multi_postings(postings, true);
  }

  std::vector<int> intersect_multi_postings(std::vector< std::vector<int>* > postings, bool pre_sorted = false){
      // algorithm from stanford IR book
      if(!pre_sorted){
        //sort
          std::cout << "sorting" << std::endl;
      }
      // now intersect the postings
      std::vector<int> intersection;
      int num_postings = postings.size();
      if(!num_postings){
        return intersection; 
      }
	  else{
	    intersection = *postings[0];		  
	  }
      for(int i = 1; i < num_postings; i++){
        intersection = intersect_postings(&intersection, postings[i]);
      }
	  return intersection;      
  }

};

#endif
