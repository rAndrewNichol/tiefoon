#include <string>
#include <vector>
#include "node.h"
#include <iostream> //delete this

#ifndef TRIE

class Trie{
   
private: 
    std::vector<Node> root;
    int max_id;
    int max_frequency;

public:
    Trie(){
        max_id = 0;
        max_frequency = 0;
    }

    void grow(std::string term, int doc_id){
		if(!term.empty()){
        	Node* endpoint;
        	endpoint = rTraverse(&root, term);
            if( !(endpoint->doc_ids).empty() && (endpoint->doc_ids).back() == doc_id ){
                // as of now we keep doc_ids unique, which means 
                // frequencies also represent the number of docs
                // that the term appears in, rather than total appearances
                return;
            }
        	(*endpoint).doc_ids.push_back(doc_id);
            (*endpoint).frequency++;
            if(doc_id > max_id){
                max_id = doc_id;
            }
            if((*endpoint).frequency > max_frequency){
                max_frequency = (*endpoint).frequency;
            }
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
		Node newNode = Node(); // declare an empty Node

        // old algo in case something breaks
        // """
        //Node newNode;

		//if(length){
        //	while(i < length){
        //	    if(curr_char >= (*curr_leaf)[i].value){
		//			if(curr_char == (*curr_leaf)[i].value){
		//				newNode = (*curr_leaf)[i]; 		
		//			}else{
		//				newNode = Node(curr_char);	
        //				(*curr_leaf).insert((*curr_leaf).begin()+i, newNode);
		//			}
        //	        break;
        //	    }else if(i == length-1){
        //          i = 0;
		//			newNode = Node(curr_char);	
        //			(*curr_leaf).insert((*curr_leaf).begin(), newNode);
		//		}
        //	    i++;
        //	}
		//}else{
		//	newNode = Node(curr_char);
        //	(*curr_leaf).insert((*curr_leaf).begin(), newNode);
		//	
		//}
        //"""
        
       	while(i < length){ // technically could be an always true loop since we will always "manually" break
       	    if(curr_char <= (*curr_leaf)[i].value){
                if(curr_char == (*curr_leaf)[i].value){
   					newNode = (*curr_leaf)[i]; 		
   				} // otherwise we surpassed the value, we can break with an empty node and the correct i
       	        break;
            }
       	    i++;
       	}
        if(newNode.empty()){
            newNode.value = curr_char;
            newNode.children = new std::vector<Node> ();
            // the line below is an alternative to the two lines above (im not sure which i prefer)
            //newNode = Node(curr_char); 
        	(*curr_leaf).insert((*curr_leaf).begin() + i, newNode);
        }

        Node* referenceNewNode = &((*curr_leaf)[i]);

		// 2. 	
		if(!remainder[1]){
            if(!(*referenceNewNode).endpoint){
                (*referenceNewNode).endpoint = true;
                (*referenceNewNode).frequency = 0;
            }
            return referenceNewNode;
		}else{
			remainder = remainder.substr(1, std::string::npos);
		    return rTraverse((*referenceNewNode).children, remainder);
		}

    }

     Node* retrieve(std::string term){
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
						return &(*curr_leaf)[j];	
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
                return 0;
			}
		}
		return 0;
    }
   
};

#define TRIE
#endif


