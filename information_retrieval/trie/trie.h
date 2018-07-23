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
        Node* endpoint;
        endpoint = rTraverse(&root, term);
        (*endpoint).doc_ids.push_back(doc_id);
        return;
    }

    Node* rTraverse(std::vector<Node>* curr_leaf, std::string remainder){
		char curr_char = remainder[0];
		
		// 1.
        int length = (*curr_leaf).size();

        int i = 0; 
		Node newNode;
		if(i){
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
		//std::cout << "new node value : " << (*referenceNewNode).value << std::endl;
		//std::cout << "new node children : " << (*(*referenceNewNode).children).size() << std::endl;

		// 2. 	
		if(!remainder[1]){
//			std::cout << "reached bottom yo. current cahracter is " << curr_char << std::endl;	
            if(!(*referenceNewNode).endpoint){
                (*referenceNewNode).endpoint = true;
            }
            return referenceNewNode;
		}else{
			remainder = remainder.substr(1, std::string::npos);
			std::cout << "ABOUT TO CALL TRAVERSE WHILE ON CHAR " << curr_char << std::endl;
		    return rTraverse((*referenceNewNode).children, remainder);
		}
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
    }

    std::vector<int> find(std::string term){
        std::cout << "find() function called" << std::endl; 
    }

};

#define TRIE
#endif


