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
        std::vector<Node>* curr;
       
        rTraverse(term, &root, term);

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

    void rTraverse(std::string const& full_term, std::vector<Node>* curr_leaf, std::string remainder){
        std::cout << full_term << std::endl;
        // curr_char is remainder[0]
        // 1. look through vector of nodes for match or surpass,
        // if match, skip to 2 with matched node as {current_node}.
        // elif surpasses node in vector:
        //    insert node into place before node it surpassed. this new node is {current_node}. go to 2
        // 2. peak forward to remainder[1]. 
        // if null, set {current_node}.endpoint to true, allocate an empty vector of ints (doc ids) for this node. (add this to node class?)
        //    return
        // else call this function recursively with (full_term, children of {current_node}, remainder[1:] (how to do this?))
        return;
    }

};

#define TRIE
#endif


