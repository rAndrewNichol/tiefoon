#include <string>
#include <vector>
#include "node.h"
#include <iostream> //delete this

#ifndef TRIE

class Trie{
   
private: 
    std::vector<Node> root;

public:
    Trie(){
    }

    void grow(std::string term, int doc_id){
		if(!term.empty()){
        	Node* endpoint;
        	endpoint = rTraverse(&root, term);
        	(*endpoint).doc_ids.push_back(doc_id);
		}
        return;
    }

    Node* rTraverse(std::vector<Node>* curr_leaf, std::string remainder){
        // curr_char is remainder[0]
        // 1. look through vector of nodes for match or surpass,
        // if match, skip to 2 with matched node as {current_node}.
        // elif surpasses node in vector:
        //    insert node into place before node it surpassed. this new node is {current_node}. go to 2
        // 2. peak forward to remainder[1]. 
        // if null, 
        //    if endpoint is false, set endpoint to true, allocate an empty vector of ints (doc ids) for this node. (add this to node class?), return pointer to node
        //	  else: return pointer to node   
		// return
        // else call this function recursively with (children of {current_node}, remainder[1:] (how to do this?))	

		char curr_char = remainder[0];
		
		// 1.
        int length = (*curr_leaf).size();

        int i = 0; 
		Node newNode;
		if(length){
        	while(i < length){
        	    if(curr_char >= (*curr_leaf)[i].value){
					if(curr_char == (*curr_leaf)[i].value){
						newNode = (*curr_leaf)[i]; 		
					}else{
						newNode = Node(curr_char);	
        				(*curr_leaf).insert((*curr_leaf).begin()+i, newNode);
					}
        	        break;
        	    }else if(i == length-1){
                    i = 0;
					newNode = Node(curr_char);	
        			(*curr_leaf).insert((*curr_leaf).begin(), newNode);
				}
        	    i++;
        	}
		}else{
			newNode = Node(curr_char);
        	(*curr_leaf).insert((*curr_leaf).begin(), newNode);
			
		} // clean this disgusting mess, u fagit
	
        Node* referenceNewNode = &((*curr_leaf)[i]);

		// 2. 	
		if(!remainder[1]){
            if(!(*referenceNewNode).endpoint){
                (*referenceNewNode).endpoint = true;
				//delete (*referenceNewNode).children; 
				// no point in deleting the children here. what if a longer string exists ("and" / "andrew")
            }
            return referenceNewNode;
		}else{
			remainder = remainder.substr(1, std::string::npos);
		    return rTraverse((*referenceNewNode).children, remainder);
		}

    }

    std::vector<int> find(std::string term){
		std::vector<Node>* curr_leaf = &root;
		int i = 0;
		char curr_char = term[i];
	    while(curr_char){
			int j = 0;
			int length = (*curr_leaf).size();
			while(j < length){
				if((*curr_leaf)[j].value == curr_char){
					break;
				}	
				j++;
			}	
			if(j < length){ // this means there was a match
				if(i == term.length() - 1){
					if((*curr_leaf)[j].endpoint){
						return (*curr_leaf)[j].doc_ids;	
					}
					else{
						break;
					}
				}
				curr_leaf = (*curr_leaf)[j].children;
				i++;
				curr_char = term[i];
			}
			else{
				std::vector<int> empty;
				return empty;
			}
		} // write this recursively? why? 	
		std::vector<int> empty_return;
		return empty_return;
    }
};

#define TRIE
#endif


