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

    void grow(std::string term){
        std::vector<Node>* curr;
        curr = &root;
        
        std::cout << (*curr).size() << std::endl;  // delete this
        
        char node_val;
        int length = (*curr).size();
        int i = 0; 
        while(i < length){
            node_val = (*curr)[i].value;
            if(term[0] > node_val){
                break;
            }
            i++;
        }
        Node newNode(term[0]); //give this an endpoint
        (*curr).insert((*curr).begin()+i, newNode);
        
        std::cout << root[0].value << std::endl; //delete this

        return;
    }

};

#define TRIE
#endif


